---
title: "Policy Configuration of SELinux and SEAndroid"
tags: ["Android", "Linux"]
date: "2017-11-17 08:12:13 +0800"
---

A Note for SELinux and SEAndroid policy configuration.  

## SEAndroid  

[Security-Enhanced Linux in Android](https://source.android.com/security/selinux/)  
[SELinux for Android 8 - Treble mode](https://source.android.com/security/selinux/images/SELinux_Treble.pdf)  
[SEAndroid安全機制中的文件安全上下文關聯分析](http://blog.csdn.net/luoshengyang/article/details/37749383) - file_context  
[SEAndroid安全機制中的進程安全上下文關聯分析](http://blog.csdn.net/luoshengyang/article/details/38054645) - process  

### Android 8 Treble mode:  

* Kernel early mount  
* PRODUCT_FULL_TREBLE, PRODUCT_FULL_TREBLE_OVERRIDE, BOARD_SEPOLICY_DIRS  

Android 4.3 ~ 6 TE macro define: external/sepolicy/te_macros  
Android 8 TE macro define: system/sepolicy/te_macros  

```
#####################################                                                                                            
# domain_trans(olddomain, type, newdomain)
# Allow a transition from olddomain to newdomain
# upon executing a file labeled with type.
# This only allows the transition; it does not
# cause it to occur automatically - use domain_auto_trans
# if that is what you want.
#
define(`domain_trans', `
# Old domain may exec the file and transition to the new domain.
allow $1 $2:file { getattr open read execute };
allow $1 $3:process transition;
# New domain is entered by executing the file.
allow $3 $2:file { entrypoint open read execute getattr };
# New domain can send SIGCHLD to its caller.
ifelse($1, `init', `', `allow $3 $1:process sigchld;')
# Enable AT_SECURE, i.e. libc secure mode.
dontaudit $1 $3:process noatsecure;
# XXX dontaudit candidate but requires further study.
allow $1 $3:process { siginh rlimitinh };
')

#####################################
# domain_auto_trans(olddomain, type, newdomain)
# Automatically transition from olddomain to newdomain
# upon executing a file labeled with type.
#
define(`domain_auto_trans', `
# Allow the necessary permissions.
domain_trans($1,$2,$3)
# Make the transition occur by default.
type_transition $1 $2:process $3;
')

#####################################
# tmpfs_domain(domain)                                                                                                           
# Define and allow access to a unique type for
# this domain when creating tmpfs / shmem / ashmem files.
define(`tmpfs_domain', `
type $1_tmpfs, file_type;
type_transition $1 tmpfs:file $1_tmpfs;
allow $1 $1_tmpfs:file { read write getattr };
allow $1 tmpfs:dir { getattr search };
')

#####################################
# init_daemon_domain(domain)
# Set up a transition from init to the daemon domain
# upon executing its binary.
define(`init_daemon_domain', `                                                                                                   
domain_auto_trans(init, $1_exec, $1)
tmpfs_domain($1)
')
```

### apol - SELinux policy analysis tool

```
sudo apt install setools-gui
```

## SELinux   

[Configuring the SELinux Policy](https://www.nsa.gov/resources/everyone/digital-media-center/publications/research-papers/assets/files/configuring-selinux-policy-report.pdf)  

Security context: subject(process) and object(file, socket, IPC object...) in the system is assigned a collection of security attributes.  

Security identifiers (SIDs): an integer that is mapped by the security server to a security context at runtime.  

The policy configuration sources must be compiled into a binary representation before it can be read by the kernel.  

The policy compilation involves three steps:  

  * all configuration files are concatenated together.  
  * **m4** marco processor is applied to the resulting concatenation to expand macros.  
  * **checkpolicy** policy compiler run to generate the binary representation.  

Applying the File Contexts, **restorecon** utility can be run to restore a specific list of files to their original settings from the file contexts configuration.  
The **chcon** utility is used to set the security context of a file to a specified value. The usage is similar to the **chown** or **chmod**  


```
audit: type=1400 audit(1388534435.223:4): avc:  denied  { read } for  pid=1643 comm="resize2fs" name="__properties__" dev="tmpfs" ino=1078 scontext=u:r:init_resize:s0 tcontext=u:object_r:properties_device:s0 tclass=dir permissive=0
// The init_resize domain is being denied permissions to read with the properties_device type.  

audit: type=1400 audit(1388534435.223:5): avc:  denied  { open } for  pid=1643 comm="resize2fs" path="/proc/stat" dev="proc" ino=4026532361 scontext=u:r:init_resize:s0 tcontext=u:object_r:proc_stat:s0 tclass=file permissive=0
// The init_resize domain is being denied permissions to open with the proc_stat type.  

type=1400 audit(1388534436.507:69): avc: denied { read write } for pid=1771 comm="android.hardwar" name="vndbinder" dev="tmpfs" ino=2351 scontext=u:r:hal_graphics_composer_default:s0 tcontext=u:object_r:vndbinder_device:s0 tclass=chr_file permissive=0
// The hal_graphics_composer_default domain is being denied permissions to read and write with the vndbinder_device type.  

type=1400 audit(1388534436.571:70): avc: denied { execute } for pid=1778 comm="surfaceflinger" path="/vendor/lib/hw/android.hardware.graphics.allocator@2.0-impl.so" dev="mmcblk0p17" ino=388 scontext=u:r:surfaceflinger:s0 tcontext=u:object_r:vendor_file:s0 tclass=file permissive=0
// The surfaceflinger domain is being denied permissions to execute with the vendor_file type.  

```
**scontext**: the source security context  
**tcontext**: the target security context  
**tclass**: the target security class  

### TE Statements  

**Attribute Declarations**  
A type attribute is a name that can be used to identify a set of types with a similar property.  

```
attribute domain;
attribute privuser;
attribute privrole;
```

**Type Declarations**  
The TE configuration language requires that every type be declared.  

Each type declaration specifies a primary name for the type, an optional set of aliases for the type, and an optional set of attributes for the type.  

During runtime, the example security server always uses the primary name to identify the type when it returns the security context for a SID.  

Aliases can be used to provide shorthand forms or synonyms for a type, but have no significance from a security perspective. Primary names and alias names exist in a single type name space and must all be unique.  

```
type sshd_t, domain, privuser, privrole, privlog, privowner;
type sshd_exec_t, file_type, exec_type, sysadmfile;
type sshd_tmp_t, file_type, sysadmfile, tmpfile;
type sshd_var_run_t, file_type, sysadmfile, pidfile;
```

The *sshd_t* type is the domain of the daemon process. The *sshd_exec_t* type is the type of the *sshd* executable.  

The *sshd_tmp_t* and *sshd_var_run_t* types are the types for temporary files and PID files, respectively, that are created by the daemon process.  

Each of these types has a set of associated attributes that are used in rules within the TE configuration.  

**TE Transition Rules**  
TE transition rules specify the new domain for a process or the new type for an object.  

**Create new domain**  

* Create new xxx.te file for the process  
* Add TE declaration and rules  

Ex:  

```
# file name: logrotate.te
# new type declaration  
type logrotate_t, domain, privowner;
type logrotate_exec_t, file_type, sysadmfile, exec_type;

# grant new domain via macro  
general_domain_access(logrotate_t)
app_domain(logrotate_t)
init_daemon_domain(logrotate_t)

# permission rules
allow logrotate_t var_log_t:dir rw_dir_perms;
allow logrotate_t var_log_t:file create_file_perms;
```

## Case study on Android Oreo  
Computing context error: invalid_context  

```
init: Context getfilecon
init: security_compute_create
type=1401 audit(1388534436.075:60): op=security_compute_sid invalid_context=u:r:vendor:s0 scontext=u:r:init:s0 tcontext=u:object_r:vendor_exec:s0 tclass=process
init: mycon u:r:init:s0 , filecon u:object_r:vendor_exec:s0 , Context rc = -1
init: could not get context while starting 'seserver'
```

Solution:  
Create TE configuration file and new domain for **seserver**  

```
# file name: seserver.te  
type seserver, domain;                                                                                                                                                       
type seserver_exec, exec_type, vendor_file_type, file_type;
init_daemon_domain(seserver)
allow seserver vndbinder_device:chr_file ioctl;
```
