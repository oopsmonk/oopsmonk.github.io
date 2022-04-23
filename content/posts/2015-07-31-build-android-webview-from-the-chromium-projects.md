---
title: "Build Android WebView From The Chromium Projects"
tags: ["Android", "Chromium"]
date: "2015-07-31 17:28:39 +0800"
---

## First, check out and install the [depot_tools](https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_setting_up) package.  

    $ git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
    $ export PATH=$PATH:/path/to/depot_tools

## Checkout source code  

    $ mkdir ~/chromium_build && cd $_
    ~/chromium_build$ fetch --nohooks android 
    //Configure GYP
    ~/chromium_build$ echo "{ 'GYP_DEFINES': 'OS=android', }" > chromium.gyp_env
    //Update projects from gyp files. 
    //You may need to run this again when you have added new files, updated gyp files, or sync'ed your repository.
    ~/chromium_build$ gclient runhooks

## Environment setup  

    ~/chromium_build$ sudo apt-get install openjdk-7-jdk
    //config default JDK
    ~/chromium_build$ sudo update-alternatives --config javac
    ~/chromium_build$ sudo update-alternatives --config java
    ~/chromium_build$ sudo update-alternatives --config javaws
    ~/chromium_build$ sudo update-alternatives --config javap
    ~/chromium_build$ sudo update-alternatives --config jar
    ~/chromium_build$ sudo update-alternatives --config jarsigner
    //install build dependencies
    ~/chromium_build$ src/build/install-build-deps-android.sh 
    // Install Google Play Services
    ~/chromium_build$ src/third_party/android_tools/sdk/tools/android update sdk --no-ui --filter 57

## Build   

    ~/chromium_build$ cd ~/chromium_build/src
    //Full browser
    ~/chromium_build/src$ ninja -C out/Debug chrome_public_apk
    //WebView
    ~/chromium_build/src$ ninja -C out/Debug android_webview_apk
    //sync source
    ~/chromium_build/src$ gclient sync

Android APK location: `~/chromium_source/src/out/Debug/apks/`  


Reference:   
[Android Build Instructions](https://www.chromium.org/developers/how-tos/android-build-instructions)  
[depot_tools_tutorial Manual Page](https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_creating_uploading_a_cl)   
[Getting Around the Chromium Source Code Directory Structure](https://www.chromium.org/developers/how-tos/getting-around-the-chrome-source-code)   
[Organization of code for Android WebView](https://docs.google.com/document/d/1a_cUP1dGIlRQFUSic8bhAOxfclj4Xzw-yRDljVk1wB0/edit?pli=1)   
[Design Documents](https://www.chromium.org/developers/design-documents)    
[HW Video Acceleration](https://docs.google.com/document/d/1LUXNNv1CXkuQRj_2Qg79WUsPDLKfOUboi1IWfX2dyQE/preview?pli=1#heading=h.c4hwvr7uzkfl)  
