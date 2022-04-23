---
title: "Sepolicy for Android Treble"
tags: ["Android"]
date: "2017-12-20 11:54:18 +0800"
---

A Note about sepolicy in Android Oreo.  

# First thing first

SELinux documents:

* [SELinux for Android 8.0](https://source.android.com/security/selinux/images/SELinux_Treble.pdf)  
* [What is SELinux?](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security-enhanced_linux/)  
* [What is SEAndroid?](https://source.android.com/security/selinux/)  
* [SELinux Policy Concepts and Overview](http://www.cse.psu.edu/~trj1/cse543-f07/slides/03-PolicyConcepts.pdf)  

# Android sepolicy files  

## Policy path:  

* /system/sepolicy   
* BOARD\_SEPOLICY\_DIR (device/$VENDOR/$DEVICE/sepolicy/, device/$VENDOR/$DEVICE/common/sepolicy/) 

## Policy Macros:

* system/sepolicy/public/te\_macros
* system/sepolicy/public/global\_macros
* system/sepolicy/public/ioctl\_macros
* system/sepolicy/public/neverallow\_macros
* system/sepolicy/private/mls\_macros
* system/sepolicy/reqd\_mask/mls\_macros

## Security Context:

* file\_contexts, labeling files infilesystem.  
* property\_contexts, labeling android system/vendor properties  
* genfs\_contexts, Pre-file labeling for /proc files, generic filesystem security contexts.  
* seapp\_contexts, used by zygote and installd via libselinux, mapping app UID andseinfofor /data/data directory  
* hwservice\_contexts, for hwservice manager to check  
* vndservice\_contestx, for vndservice manager to check  
* service\_contexts, for service manager to check  

## Type Enforcement

* \*.te

# Composing Policy for Android trebel  

1. Add domains for a service  

    Add security context depend on service type:  

    * Hardware service  
    Define service type in hwservice.te  

        type vnd_foo_hwservice, hwservice_manager_type;

    Labeling hwservice in hwservice\_contexts  

        vendor.realtek.foo::IfooAPI     u:object_r:vnd_foo_hwservice:s0

    * Vendor service  

    Define service type in vndservice.te  

        type  foo_service,  vndservice_manager_type;

    Labeling vndservice in vndservice\_contexts 

        fooservice  u:object_r:foo_service:s0

    * System service  
    
    Define service type in service.te  

        type foo_service,                 service_manager_type;
    
    Labeling system service in service\_contexts  

        fooservice  u:object_r:foo_service:s0

2. Add domain and type enforcement configuration  

    Create new foo.te file  

    Define service doamin and file attributes  

        type foo, domain;
        type foo_exec, exec_type, vendor_file_type, file_type;

        init_daemon_domain(foo)  


3. Add file security context in file\_contexts  

        /vendor/bin/foo  u:object_r:foo_exec:s0

# Building policy files  

There are typically seven SELinux related files under an Android device (see more details here):  

* selinux\_version  
* sepolicy: binary output after combining policy files (security\_classes, initial\_sids, \*.te, etc)  
* file\_contexts  
* property\_contexts  
* seapp\_contexts  
* service\_contexts  
* system/etc/mac\_permissions.xml  

# Building file\_contexts.bin  

find file\_contexts in /system/sepolicy and BOARD\_SEPOLICY\_DIR  

output files:  
out/target/product/$DEVICE/obj/ETC/nonplat\_file\_contexts\_intermediates/nonplat\_file\_contexts  
out/target/product/$DEVICE/obj/ETC/plat\_file\_contexts\_intermediates/plat\_file\_contexts  

binary file:  
out/target/product/$DEVICE/obj/ETC/file\_contexts.bin\_intermediates/file\_contexts.bin  

**install to root/file\_contexts.bin**  

# Building policy configuration  

find security\_classes, initial\_sids, \*.te, genfs\_contexts, and port\_contexts in /system/sepolicy and BOARD\_SEPOLICY\_DIR  

configure file:  
out/target/product/$DEVICE/obj/ETC/plat\_sepolicy.cil\_intermediates/plat\_policy.conf  
out/target/product/$DEVICE/obj/ETC/nonplat\_sepolicy.cil\_intermediates/nonplat\_policy.conf  
out/target/product/$DEVICE/obj/ETC/general\_sepolicy.conf\_intermediates/general\_sepolicy.conf  

**install to /root/sepolicy**  

