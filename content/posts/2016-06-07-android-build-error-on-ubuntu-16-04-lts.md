---
title: Android build error on Ubuntu 16.04 LTS
tags: ["Android"]
date: "2016-06-07 13:21:48 +0800"
---

After update system from Ubuntu 14.04 to 16.04, I got some problems, when I was building Android source code.  

## **openjdk-7-jdk is gone**  

Add PPA for OpenJDK7  

```bash  
sudo add-apt-repository ppa:openjdk-r/ppa  
sudo apt remove openjdk-* icedtea-* icedtea6-*  
sudo apt update && sudo apt install openjdk-7-jdk git ccache automake lzop bison gperf build-essential zip curl zlib1g-dev zlib1g-dev:i386 g++-multilib python-networkx libxml2-utils bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool make optipng maven  
``` 

If you have other java version in system, make sure your java version is correct. 

```bash  
sudo update-alternatives --config java 
sudo update-alternatives --config javac 
sudo update-alternatives --config javadoc 
sudo update-alternatives --config javap 
sudo update-alternatives --config javaws 
sudo update-alternatives --config jar 
```  

Reference: [\[GUIDE\] How to Setup Ubuntu 16.04 LTS Xenial Xerus for Compiling Android ROMs](http://forum.xda-developers.com/chef-central/android/guide-how-to-setup-ubuntu-16-04-lts-t3363669) 

## **unsupported reloc 43**  

```bash  
prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.11-4.6//x86_64-linux/include/c++/4.6/bits/basic_string.h:270: error: unsupported reloc 43
prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.11-4.6//x86_64-linux/include/c++/4.6/bits/basic_string.h:270: error: unsupported reloc 43
prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.11-4.6//x86_64-linux/include/c++/4.6/bits/basic_string.h:235: error: unsupported reloc 43
prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.11-4.6//x86_64-linux/include/c++/4.6/bits/basic_string.h:235: error: unsupported reloc 43
libnativehelper/JNIHelp.cpp:310: error: unsupported reloc 43
libnativehelper/JNIHelp.cpp:311: error: unsupported reloc 43
libnativehelper/JNIHelp.cpp:332: error: unsupported reloc 43
libnativehelper/JNIHelp.cpp:322: error: unsupported reloc 43
libnativehelper/JNIHelp.cpp:338: error: unsupported reloc 43
...
libnativehelper/JniInvocation.cpp:165: error: unsupported reloc 43
libnativehelper/JniInvocation.cpp:165: error: unsupported reloc 43
libnativehelper/JniInvocation.cpp:165: error: unsupported reloc 43
clang: error: linker command failed with exit code 1 (use -v to see invocation)
build/core/host_shared_library_internal.mk:44: recipe for target 'out/host/linux-x86/obj32/lib/libnativehelper.so' failed
make: *** [out/host/linux-x86/obj32/lib/libnativehelper.so] Error 1 
```  

The older prebuilt toolchain have some problems with newer version of 'as' in the native environment.  
This error will show up when your environment is Ubuntu 16.04 and AOSP before May 7, 2106.  
To solve this problem:  

* Modify **build/core/clang/HOST_x86_common.mk**  

```diff  
diff --git a/core/clang/HOST_x86_common.mk b/core/clang/HOST_x86_common.mk
index 0241cb6..77547b7 100644
--- a/core/clang/HOST_x86_common.mk
+++ b/core/clang/HOST_x86_common.mk
@@ -8,6 +8,7 @@ ifeq ($(HOST_OS),linux)
 CLANG_CONFIG_x86_LINUX_HOST_EXTRA_ASFLAGS := \
   --gcc-toolchain=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG) \
   --sysroot=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/sysroot \
+  -B$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/x86_64-linux/bin \
   -no-integrated-as
 
 CLANG_CONFIG_x86_LINUX_HOST_EXTRA_CFLAGS := \  
```  

* Use AOSP after May 7, 2016  

Reference: [https://android-review.googlesource.com/#/c/223100/](https://android-review.googlesource.com/#/c/223100/)  

