---
title: "Building Different Android Version Using schroot"
tags: ["Android", "Ubuntu"]
date: "2017-10-24 10:07:29 +0800"
---

I have a build environment with make4.1 and JDK8 for Android N/O, but JDK6 and make3.81 are required by Android KitKat.  
Here is a way to create a clean environment for Android KK.  

## Create a new environment in current Ubuntu 16.04  
install schroot and debootstrap  

`sudo apt install schroot debootstrap`  

if xenial no exist, update to latest version of debootstrap  
`ls -l /usr/share/debootstrap/scripts/xenial`  

### Configure new environment  

edit `/etc/schroot/schroot.conf`  

```
[Build_KK]
description=ubuntu16.04 Android_KK
type=directory
directory=/srv/chroot/Build_KK
users=oopsmonk
groups=oopsmonk
root-groups=root
profile=default
```

### Adding Mount points 

edit `/etc/schroot/default/fstab`  

```
/opt 			/opt 			none 	rw,bind		0 	0
/home/oopsmonk/2t 	/home/oopsmonk/2t       none    rw,bind 	0	0
```

### Installing new system  

```
$ mkdir -p /srv/chroot/Build_KK
$ sudo debootstrap --arch amd64 xenial /srv/chroot/Build_KK/ http://archive.ubuntu.com/ubuntu
```

## Using new environment  

Login to new environment  

```
$ schroot -c Build_KK -u oopsmonk
```  

### Install packages

edit `/etc/apt/sources.list`   
deb http://archive.ubuntu.com/ubuntu xenial main  
change to   
deb http://archive.ubuntu.com/ubuntu xenial main **restricted universe**  

```
$ sudo apt update
$ sudo apt install curl git subversion python wget xz-utils vim make ccache cmake lsof unzip u-boot-tools zip m4 bison 
$ sudo apt install g++-multilib gcc-multilib lib32ncurses5-dev lib32readline-dev lib32z1-dev libxml2-utils bc
$ sudo apt install xsltproc flex gperf 
$ wget https://bootstrap.pypa.io/get-pip.py
$ sudo python get-pip.py 
```

### JDK6 for Android KK  

Put JDKs in /opt that we can share with the original env or the third env and it can reduce HDD space for creating new envs.  
unzip sun-jdk-1.6.0.37.tgz to /opt/

```
$ sudo update-alternatives --install /usr/bin/javac javac /opt/sun-jdk-1.6.0.37/bin/javac 0
$ sudo update-alternatives --install /usr/bin/java java /opt/sun-jdk-1.6.0.37/bin/java 0
$ sudo update-alternatives --install /usr/bin/javaws javaws /opt/sun-jdk-1.6.0.37/bin/javaws 0
```  

### Make 3.81 for Android KK  

```
$ wget "http://ftp.gnu.org/gnu/make/make-3.81.tar.bz2"
$ tar xjf make-3.81.tar.bz2
$ cd make-3.81
$ ./configure && make 
$ sudo make install 
$ hash -r make
$ make --version
GNU Make 3.81
Copyright (C) 2006  Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.
```

Ready to build! 

In this case, 881MB is used by the new environment, so we should reserve 1GB space or more for creating a new environment.  

```
$ sudo du -hs /srv/chroot/Build_KK
881M    /srv/chroot/Build_KK
```
