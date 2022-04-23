---
title: "Build XBMC for Android on lubuntu 12.04"
tags: ["Android", "Linux"]
date: 2012-07-28
---

### Install required packages

```
# sudo apt-get install build-essential default-jdk git curl autoconf \
 unzip zip zlib1g-dev gawk gperf
```

### Getting the Android SDK and NDK

http://developer.android.com/sdk/index.html  
SDK : [android-sdk_r20.0.1-linux.tgz](http://dl.google.com/android/android-sdk_r20.0.1-linux.tgz)  
crystax-5 NDK with enabled support of C++ exceptions, RTTI and Standard C++ Library  
http://www.crystax.net/en/android/ndk/7#download  
NDK : [android-ndk-r7-crystax-5.beta2-linux-x86.tar.bz2](http://www.crystax.net/en/download/android-ndk-r7-crystax-5.beta2-linux-x86.tar.bz2)  

### Installing Android SDK packages

\<android-sdk\> : $HOME/XBMC_Project/android-sdk-linux

```
# cd <android-sdk>/tools
# ./android update sdk -u -t platform,platform-tool
```  

### Setup the Android toolchain

\<android-ndk\> :  $HOME/XBMC_Project/android-ndk-r8b
\<android-toolchain\> :  $HOME/XBMC_Project/android_toolchain/android-9

```
# cd <android-ndk>
# ls platforms
# cd build/tools
# ./make-standalone-toolchain.sh --ndk-dir=../../ \
  --install-dir=<android-toolchain>/android-9 --platform=android-9
```

### Create a (new) debug key to sign debug APKs

All packages must be signed. The following command will generate a self-signed debug key. If the result is a cryptic error, it probably just means a debug key already existed, no cause for alarm.  

```
# keytool -genkey -keystore ~/.android/debug.keystore -v -alias \
  androiddebugkey -dname "CN=Android Debug,O=Android,C=US" -keypass \
  android -storepass android -keyalg RSA -keysize 2048 -validity 10000
```

### Getting the source code

```
# cd $HOME/XBMC_Project
# git clone git://github.com/xbmc/android.git xbmc-android-git
# cd xbmc-android-git
# git submodule update --init addons/skin.touched
```

### Building dependencies

```
# cd $HOME/XBMC_Project/xbmc-android-git/tools/android/depends
# ./bootstrap
# ./configure --help
#export XBMC_ANDROID_NDK=~/XBMC_Project/android-ndk-r7-crystax-5.beta2
#export XBMC_ANDROID_SDK=~/XBMC_Project/android-sdk-linux
#export XBMC_ANDROID_TARBALLS=~/XBMC_Project/xbmc-tarballs
#./configure --with-toolchain=~/XBMC_Project/android-toolchain/android-9
checking for g++... g++
checking whether the C++ compiler works... yes
checking for C++ compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C++ compiler... yes
checking whether g++ accepts -g... yes
checking for gcc... gcc
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for main in -lz... yes
checking for unzip... yes
checking for zip... yes
checking for curl... /usr/bin/curl
checking for tar... /bin/tar
checking for -gcc... no
configure: WARNING: host was not specified. guessing.
checking for gcc... /home/oopsmonk/XBMC_Project/android-toolchain/android-9/arm-linux-androideabi/bin/gcc
        toolchain:       /home/oopsmonk/XBMC_Project/android-toolchain/android-9
        cpu:             armeabi-v7a
        host:            arm-linux-androideabi
        sdk-platform:    android-10
configure: creating ./config.status
config.status: creating Makefile
config.status: creating Makefile.include
#make -j4
make[1]: Leaving directory `/home/oopsmonk/XBMC_Project/xbmc-android-git/tools/android/depends/libssh'
Dependencies built successfully.
```

### Building XBMC

```
#cd ~/XBMC_Project/xbmc-android-git/tools/android/depends/xbmc
#make -j4
```

__APK location : ~/XBMC_Project/xbmc-android-git/xbmcapp-armeabi-v7a-debug.apk__  
Enjoy it !!

References:  
https://github.com/xbmc/android/blob/android-rebase-8/docs/README.android  
http://xbmc.org/theuni/2012/07/13/xbmc-for-android/  

