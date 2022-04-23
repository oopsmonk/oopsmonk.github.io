---
title: "LibCEC on Raspberry Pi"
tags: ["RaspberryPi"]
date: "2015-11-03 14:44:47 +0800"
---

## Install requirements

    sudo apt-get install build-essential autoconf liblockdev1-dev \
    libudev-dev git libtool pkg-config cmake libxrandr-dev -y  

Python and Swing support (Optional)  

    sudo apt-get install python-dev swig -y  

## Checkout and build libcec source code   

The current version is libcec-3.0.1, but I got an error as follows:  

    make[2]: *** No rule to make target '1', needed by 'src/libcec/libcec.so.3.0.1'.  Stop.  

Using libcec-3.0.0 instead of libcec-3.0.1, it's work properly.  

    git clone https://github.com/Pulse-Eight/libcec.git  
    cd libcec
    git checkout libcec-3.0.0 -b cec3.0.0  

Checkout platform source  

    cd libcec/src/platform  
    git clone https://github.com/Pulse-Eight/platform.git .
    mkdir build && cd $_ 

Build platform  

    cmake -DCMAKE_CXX_COMPILER=g++-4.8 ..
    make && sudo make install  

Modify `~/libcec/src/libcec/cmake/CheckPlatformSupport.cmake`  

```diff
diff --git a/src/libcec/cmake/CheckPlatformSupport.cmake b/src/libcec/cmake/CheckPlatformSupport.cmake
index 828cdb2..b1ec498 100644
--- a/src/libcec/cmake/CheckPlatformSupport.cmake
+++ b/src/libcec/cmake/CheckPlatformSupport.cmake
@@ -75,9 +75,10 @@ else()
   endif()
 
   # raspberry pi
-  check_library_exists(bcm_host vchi_initialise "" HAVE_RPI_API)
+  check_library_exists(bcm_host bcm_host_init "" HAVE_RPI_API)
   if (HAVE_RPI_API)
     set(LIB_INFO "${LIB_INFO}, 'RPi'")
+    include_directories(/opt/vc/include /opt/vc/include/interface/vcos/pthreads /opt/vc/include/interface/vmcs_host/linux)
     list(APPEND CMAKE_REQUIRED_LIBRARIES "vcos")
     list(APPEND CMAKE_REQUIRED_LIBRARIES "vchiq_arm")
     set(CEC_SOURCES_ADAPTER_RPI adapter/RPi/RPiCECAdapterDetection.cpp
```

Build libcec  

    cd ~/libcec  
    mkdir build && cd $_  
    cmake -DBUILD_SHARED_LIBS=1 -DCMAKE_CXX_COMPILER=g++-4.8 ..  

The configuration on my pi  

```
-- Configured features:
-- Pulse-Eight CEC Adapter:                yes
-- Pulse-Eight CEC Adapter detection:      yes
-- lockdev support:                        yes
-- xrandr support:                         yes
-- Raspberry Pi support:                   no
-- TDA995x support:                        no
-- Exynos support:                         no
-- Python support:                         version 2.7.3 (2.7)
-- lib info: compiled on Linux-3.18.11+, features: P8_USB, P8_detect, randr
-- Configuring done
-- Generating done
```

Make and install library  

    make && sudo make install 

## Test libcec  

Testing Samsung UA46B6000VM  
You can test via `cec-client` or `libcec/src/pyCecClient/pyCecClient.py`(if you built with python support). 
`h` for help and `q` for exit cec-client.  
As a playback device:  

```
oopsmonk@raspberrypi ~ $ sudo cec-client -t p
[sudo] password for oopsmonk: 
== using device type 'playback device'
CEC Parser created - libCEC version 3.0.0
no serial port given. trying autodetect: 
 path:     Raspberry Pi
 com port: RPI

opening a connection to the CEC adapter...
DEBUG:   [             102]     Broadcast (F): osd name set to 'Broadcast'
DEBUG:   [             104]     InitHostCEC - vchiq_initialise succeeded
DEBUG:   [             105]     InitHostCEC - vchi_initialise succeeded
DEBUG:   [             107]     InitHostCEC - vchi_connect succeeded
DEBUG:   [             109]     logical address changed to Free use (e)
DEBUG:   [             111]     Open - vc_cec initialised
NOTICE:  [             112]     connection opened
DEBUG:   [             114]     << Broadcast (F) -> TV (0): POLL
DEBUG:   [             114]     initiator 'Broadcast' is not supported by the CEC adapter. using 'Free use' instead
TRAFFIC: [             115]     << e0
DEBUG:   [             119]     processor thread started
DEBUG:   [             176]     >> POLL sent
DEBUG:   [             176]     TV (0): device status changed into 'present'
DEBUG:   [             176]     << requesting vendor ID of 'TV' (0)
TRAFFIC: [             177]     << e0:8c
TRAFFIC: [             369]     >> 0f:87:00:00:f0
DEBUG:   [             369]     TV (0): vendor = Samsung (0000f0)
DEBUG:   [             371]     >> TV (0) -> Broadcast (F): device vendor id (87)
DEBUG:   [             372]     expected response received (87: device vendor id)
DEBUG:   [             373]     replacing the command handler for device 'TV' (0)
NOTICE:  [             373]     registering new CEC client - v3.0.0
DEBUG:   [             373]     detecting logical address for type 'playback device'
DEBUG:   [             373]     trying logical address 'Playback 1'
DEBUG:   [             373]     << Playback 1 (4) -> Playback 1 (4): POLL
TRAFFIC: [             374]     << 44
TRAFFIC: [             464]     << 44
DEBUG:   [             555]     >> POLL not sent
DEBUG:   [             555]     using logical address 'Playback 1'
DEBUG:   [             555]     Playback 1 (4): device status changed into 'handled by libCEC'
DEBUG:   [             555]     Playback 1 (4): power status changed from 'unknown' to 'on'
DEBUG:   [             555]     Playback 1 (4): vendor = Pulse Eight (001582)
DEBUG:   [             556]     Playback 1 (4): CEC version 1.4
DEBUG:   [             556]     AllocateLogicalAddresses - device '0', type 'playback device', LA '4'
DEBUG:   [             557]     logical address changed to Playback 1 (4)
DEBUG:   [             560]     Playback 1 (4): osd name set to 'CECTester'
DEBUG:   [             560]     Playback 1 (4): menu language set to 'eng'
DEBUG:   [             564]     GetPhysicalAddress - physical address = 1000
DEBUG:   [             565]     AutodetectPhysicalAddress - autodetected physical address '1000'
DEBUG:   [             565]     Playback 1 (4): physical address changed from ffff to 1000
DEBUG:   [             565]     << Playback 1 (4) -> broadcast (F): physical adddress 1000
TRAFFIC: [             565]     << 4f:84:10:00:04
NOTICE:  [             716]     CEC client registered: libCEC version = 3.0.0, client version = 3.0.0, firmware version = 1, logical address(es) = Playback 1 (4) , physical address: 1.0.0.0, compiled on Linux-3.18.11+, features: P8_USB, P8_detect, randr, 'RPi'
DEBUG:   [             717]     << Playback 1 (4) -> TV (0): OSD name 'CECTester'
TRAFFIC: [             717]     << 40:47:43:45:43:54:65:73:74:65:72
DEBUG:   [            1018]     << requesting power status of 'TV' (0)
TRAFFIC: [            1018]     << 40:8f
waiting for input
TRAFFIC: [            1162]     >> 04:90:00
DEBUG:   [            1162]     TV (0): power status changed from 'unknown' to 'on'
DEBUG:   [            1163]     expected response received (90: report power status)
DEBUG:   [            1165]     >> TV (0) -> Playback 1 (4): report power status (90)
```

Get CEC version  

```
ver 0
DEBUG:   [          209560]     << requesting CEC version of 'TV' (0)
TRAFFIC: [          209561]     << 40:9f
TRAFFIC: [          209718]     >> 04:9e:04
DEBUG:   [          209718]     TV (0): CEC version 1.3a
DEBUG:   [          209720]     >> TV (0) -> Playback 1 (4): cec version (9E)
CEC version 1.3a
DEBUG:   [          209723]     expected response received (9E: cec version)
```

Set inactive source  

```
is
DEBUG:   [          281092]     marking Playback 1 (4) as inactive source
NOTICE:  [          281094]     >> source deactivated: Playback 1 (4)
NOTICE:  [          281095]     << Playback 1 (4) -> broadcast (F): inactive source
TRAFFIC: [          281097]     << 40:9d:10:00
TRAFFIC: [          283632]     >> 0f:82:00:00
DEBUG:   [          283632]     making TV (0) the active source
DEBUG:   [          283635]     >> TV (0) -> Broadcast (F): active source (82)
TRAFFIC: [          283850]     >> 0f:80:10:00:00:00
DEBUG:   [          283852]     >> TV (0) -> Broadcast (F): routing change (80)
```  

Set active source  

```
as
DEBUG:   [          288309]     making Playback 1 (4) the active source
DEBUG:   [          288310]     marking TV (0) as inactive source
NOTICE:  [          288312]     >> source activated: Playback 1 (4)
DEBUG:   [          288314]     sending active source message for 'Playback 1'
NOTICE:  [          288315]     << powering on 'TV' (0)
TRAFFIC: [          288317]     << 40:04
NOTICE:  [          288379]     << Playback 1 (4) -> broadcast (F): active source (1000)
TRAFFIC: [          288381]     << 4f:82:10:00
DEBUG:   [          288503]     << Playback 1 (4) -> TV (0): menu state 'activated'
TRAFFIC: [          288505]     << 40:8e:00
TRAFFIC: [          288675]     >> 04:8d:02
DEBUG:   [          288675]     << Playback 1 (4) -> TV (0): menu state 'activated'
TRAFFIC: [          288675]     << 40:8e:00
DEBUG:   [          288677]     >> TV (0) -> Playback 1 (4): menu request (8D)
TRAFFIC: [          288853]     >> 04:1a:01
DEBUG:   [          288853]     << Playback 1 (4) -> TV (0): deck status 'stop'
TRAFFIC: [          288853]     << 40:1b:1a
DEBUG:   [          288855]     >> TV (0) -> Playback 1 (4): give deck status (1A)
```

Emit `Standby` command to TV  

```
standby 0
NOTICE:  [           40210]     << putting 'TV' (0) in standby mode
TRAFFIC: [           40212]     << 40:36
TRAFFIC: [           40577]     >> 0f:36
DEBUG:   [           40577]     TV (0): power status changed from 'on' to 'standby'
DEBUG:   [           40579]     >> TV (0) -> Broadcast (F): standby (36)
```  

Power on TV  

```
on 0
NOTICE:  [           57151]     << powering on 'TV' (0)
TRAFFIC: [           57153]     << 40:04
DEBUG:   [           57215]     TV (0): power status changed from 'standby' to 'in transition from standby to on'
DEBUG:   [           63175]     GetPhysicalAddress - physical address = 1000
NOTICE:  [           63176]     physical address changed to 1000
DEBUG:   [           63176]     physical address unchanged (1000)
TRAFFIC: [           70645]     >> 0f:80:00:00:10:00
DEBUG:   [           70646]     TV (0): power status changed from 'in transition from standby to on' to 'on'
DEBUG:   [           70646]     making Playback 1 (4) the active source
NOTICE:  [           70646]     >> source activated: Playback 1 (4)
DEBUG:   [           70646]     sending active source message for 'Playback 1'
NOTICE:  [           70646]     << powering on 'TV' (0)
TRAFFIC: [           70647]     << 40:04
DEBUG:   [           70648]     >> TV (0) -> Broadcast (F): routing change (80)
NOTICE:  [           70737]     << Playback 1 (4) -> broadcast (F): active source (1000)
TRAFFIC: [           70738]     << 4f:82:10:00
DEBUG:   [           70889]     << Playback 1 (4) -> TV (0): menu state 'activated'
TRAFFIC: [           70889]     << 40:8e:00
TRAFFIC: [           71160]     >> 0f:85
DEBUG:   [           71160]     >> 0 requests active source
NOTICE:  [           71161]     << Playback 1 (4) -> broadcast (F): active source (1000)
TRAFFIC: [           71161]     << 4f:82:10:00
DEBUG:   [           71162]     >> TV (0) -> Broadcast (F): request active source (85)
TRAFFIC: [           71402]     >> 0f:80:00:00:10:00
DEBUG:   [           71403]     Playback 1 (4) was already marked as active source
NOTICE:  [           71403]     >> source activated: Playback 1 (4)
DEBUG:   [           71403]     sending active source message for 'Playback 1'
NOTICE:  [           71403]     << powering on 'TV' (0)
TRAFFIC: [           71403]     << 40:04
DEBUG:   [           71405]     >> TV (0) -> Broadcast (F): routing change (80)
NOTICE:  [           71554]     << Playback 1 (4) -> broadcast (F): active source (1000)
TRAFFIC: [           71555]     << 4f:82:10:00
DEBUG:   [           71765]     << Playback 1 (4) -> TV (0): menu state 'activated'
TRAFFIC: [           71766]     << 40:8e:00
TRAFFIC: [           71947]     >> 0f:32:65:6e:67
DEBUG:   [           71947]     TV (0): menu language set to 'eng'
TRAFFIC: [           71948]     >> 04:8d:02
DEBUG:   [           71948]     << Playback 1 (4) -> TV (0): menu state 'activated'
TRAFFIC: [           71948]     << 40:8e:00
DEBUG:   [           71950]     >> TV (0) -> Broadcast (F): set menu language (32)
DEBUG:   [           71952]     >> TV (0) -> Playback 1 (4): menu request (8D)
TRAFFIC: [           72129]     >> 04:1a:01
DEBUG:   [           72129]     << Playback 1 (4) -> TV (0): deck status 'stop'
TRAFFIC: [           72129]     << 40:1b:1a
DEBUG:   [           72132]     >> TV (0) -> Playback 1 (4): give deck status (1A)
TRAFFIC: [           72371]     >> 04:8d:02
DEBUG:   [           72371]     << Playback 1 (4) -> TV (0): menu state 'activated'
TRAFFIC: [           72371]     << 40:8e:00
DEBUG:   [           72373]     >> TV (0) -> Playback 1 (4): menu request (8D)
TRAFFIC: [           72642]     >> 04:8d:02
DEBUG:   [           72643]     << Playback 1 (4) -> TV (0): menu state 'activated'
TRAFFIC: [           72643]     << 40:8e:00
DEBUG:   [           72645]     >> TV (0) -> Playback 1 (4): menu request (8D)
TRAFFIC: [           75054]     >> 04:8c
DEBUG:   [           75055]     << Playback 1 (4) -> TV (0): vendor id Pulse Eight (1582)
TRAFFIC: [           75055]     << 4f:87:00:15:82
DEBUG:   [           75057]     >> TV (0) -> Playback 1 (4): give device vendor id (8C)
TRAFFIC: [           75275]     >> 04:46
DEBUG:   [           75276]     << Playback 1 (4) -> TV (0): OSD name 'CECTester'
TRAFFIC: [           75276]     << 40:47:43:45:43:54:65:73:74:65:72
DEBUG:   [           75278]     >> TV (0) -> Playback 1 (4): give osd name (46)
TRAFFIC: [           75744]     >> 04:a0:00:00:f0:23
TRAFFIC: [           75745]     << 40:a0:00:00:f0:24:00:80
DEBUG:   [           75746]     >> TV (0) -> Playback 1 (4): vendor command with id (A0)
TRAFFIC: [           76037]     >> 04:9f
DEBUG:   [           76037]     << Playback 1 (4) -> TV (0): cec version 1.4
TRAFFIC: [           76037]     << 40:9e:05
DEBUG:   [           76039]     >> TV (0) -> Playback 1 (4): get cec version (9F)
TRAFFIC: [           76214]     >> 0f:85
DEBUG:   [           76214]     >> 0 requests active source
NOTICE:  [           76214]     << Playback 1 (4) -> broadcast (F): active source (1000)
TRAFFIC: [           76214]     << 4f:82:10:00
DEBUG:   [           76216]     >> TV (0) -> Broadcast (F): request active source (85)
TRAFFIC: [           76417]     >> 04:8d:02
DEBUG:   [           76417]     << Playback 1 (4) -> TV (0): menu state 'activated'
TRAFFIC: [           76417]     << 40:8e:00
DEBUG:   [           76419]     >> TV (0) -> Playback 1 (4): menu request (8D)
TRAFFIC: [           76595]     >> 04:8d:02
DEBUG:   [           76595]     << Playback 1 (4) -> TV (0): menu state 'activated'
TRAFFIC: [           76595]     << 40:8e:00
DEBUG:   [           76597]     >> TV (0) -> Playback 1 (4): menu request (8D)
```

Help  

```
h

================================================================================
Available commands:

[tx] {bytes}              transfer bytes over the CEC line.
[txn] {bytes}             transfer bytes but don't wait for transmission ACK.
[on] {address}            power on the device with the given logical address.
[standby] {address}       put the device with the given address in standby mode.
[la] {logical address}    change the logical address of the CEC adapter.
[p] {device} {port}       change the HDMI port number of the CEC adapter.
[pa] {physical address}   change the physical address of the CEC adapter.
[as]                      make the CEC adapter the active source.
[is]                      mark the CEC adapter as inactive source.
[osd] {addr} {string}     set OSD message on the specified device.
[ver] {addr}              get the CEC version of the specified device.
[ven] {addr}              get the vendor ID of the specified device.
[lang] {addr}             get the menu language of the specified device.
[pow] {addr}              get the power status of the specified device.
[name] {addr}             get the OSD name of the specified device.
[poll] {addr}             poll the specified device.
[lad]                     lists active devices on the bus
[ad] {addr}               checks whether the specified device is active.
[at] {type}               checks whether the specified device type is active.
[sp] {addr}               makes the specified physical address active.
[spl] {addr}              makes the specified logical address active.
[volup]                   send a volume up command to the amp if present
[voldown]                 send a volume down command to the amp if present
[mute]                    send a mute/unmute command to the amp if present
[self]                    show the list of addresses controlled by libCEC
[scan]                    scan the CEC bus and display device info
[mon] {1|0}               enable or disable CEC bus monitoring.
[log] {1 - 31}            change the log level. see cectypes.h for values.
[ping]                    send a ping command to the CEC adapter.
[bl]                      to let the adapter enter the bootloader, to upgrade
                          the flash rom.
[r]                       reconnect to the CEC adapter.
[h] or [help]             show this help.
[q] or [quit]             to quit the CEC test client and switch off all
                          connected CEC devices.
================================================================================
```  

