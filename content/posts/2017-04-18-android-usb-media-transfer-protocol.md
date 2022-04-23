---
title: "Android USB Media Transfer Protocol(MPT)"
tags: ["Android"]
date: "2017-04-18 11:55:32 +0800"
---

Study USB MTP Device and Host mode in Android M.  
Source Code Cross Reference: [Android 6.0.1_r10](http://androidxref.com/6.0.1_r10/)  

## MTP Device Mode 

**Enable device mode:**  
Settings -> Developer options -> Select USB Configuration -> MTP  
UsbDeviceManager: Setting USB config to mtp  
device/lge/hammerhead/init.hammerhead.usb.rc : on property:sys.usb.config=mtp   
system/core/rootdir/init.usb.configfs.rc: on property:sys.usb.config=mtp && property:sys.usb.configfs=1  

**USB plug to PC:**  
MtpReceiver: listen to android.hardware.usb.action.USB\_STATE and bring up MtpService  
UsbDeviceManager: get uevent USB\_STATE=CONFIGURED from kernel  
MtpService: create MtpDatabase
MtpDatabase: create volume and storage path  
MtpService: starting MTP server in MTP mode  

**Start transfer data to PC:**  
MtpDatabase: getObjectList storageID 65537 , formate 0 , parent -1  
MtpDatabase: object\_query to get object from media provider.  


Handle UEVENT from Kernel, UsbHandler send MSG\_UPDATE\_STATE to UsbDeviceManager  

    frameworks/base/services/usb/java/com/android/server/usb/UsbDeviceManager.java  

handleUsbState start MTPService   

    packages/providers/MediaProvider/src/com/android/providers/media/MtpReceiver.java  

Set USB function: setCurrentFunction  

    frameworks/base/core/java/android/hardware/usb/UsbManager.java  


## MTP Host Mode   

UsbHostManager uses monitorUsbHostBus function to monitor usb’s event when system ready. monitorUsbHostBus is implemented at android_server_UsbHostManager_monitorUsbHostBus in JNI.  

```
frameworks/base/services/usb/java/com/android/server/usb/UsbHostManager.java
frameworks/base/services/core/jni/com_android_server_UsbHostManager.cpp
```

After receiving USB attach event(ACTION_USB_DEVICE_ATTACHED) UsbHostManager adds an USB device via endUsbDeviceAdded() function, and deviceAttached() is called to figure out which activity should be lunched. Meanwhile, MtpClient will try to open MTP device use openDeviceLocked() function.  

```
frameworks/base/services/usb/java/com/android/server/usb/UsbSettingsManager.java
packages/apps/Gallery2/src/com/android/gallery3d/data/MtpClient.java
```

In this case IngestActivity is selected from UsbSettingsManager::resolveActivity(). Because class is 6 and subclass is 1 in USB configuration that is matched in IngestActivity’s device_fileter.xml file.   

    packages/apps/Gallery2/res/xml/device_filter.xml

When IngestActivity is created, it will bind to IngestService which handled MTP protocol and provided MTP’s functionality.   

```
packages/apps/Gallery2/src/com/android/gallery3d/ingest/IngestActivity.java
packages/apps/Gallery2/src/com/android/gallery3d/ingest/IngestService.java
```

### MTP device detection issue in host mode   

Android uses mClass, mSubclass, and mProtocal values in UsbInterface object to detect MTP devices.  
For instance:  

```
iPhone: UsbInterface[mId=0,mAlternateSetting=0,mName=null,mClass=6,mSubclass=1,mProtocol=1  
Samsung: UsbInterface[mId=0,mAlternateSetting=0,mName=MTP,mClass=6,mSubclass=1,mProtocol=1  
Sony: UsbInterface[mId=0,mAlternateSetting=0,mName=MTP,mClass=255,mSubclass=255,mProtocol=0
```

The Sony cannot recognised as a MTP device.  
We can modify MtpClient and device\_filter.xml to fix this issue.  

## Relate source code  

```
packages/providers/MediaProvider/src/com/android/providers/media/MtpReceiver.java  
packages/providers/MediaProvider/src/com/android/providers/media/MtpService.java  
packages/providers/MediaProvider/AndroidManifest.xml  
frameworks/base/services/usb/java/com/android/server/usb/  
frameworks/base/media/java/android/mtp/  
frameworks/base/media/jni/android_mtp_*  
frameworks/av/media/mtp/  
device/lge/hammerhead/init.hammerhead.usb.rc  
system/core/rootdir/init.usb.configfs.rc  
```

