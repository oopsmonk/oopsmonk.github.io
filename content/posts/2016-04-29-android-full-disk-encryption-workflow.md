---
title: "Android Full Disk Encryption Workflow (default encryption)"
tags: ["Android"]
date: "2016-04-29 09:51:48 +0800"
---

This study is based on Android Marshmallow.  
Android full disk encryption use dm-crypt, which works with block devices. Please refer to the following docs for more detail:  
[Full Disk Encryption](https://source.android.com/security/encryption/)  


## How to setup full disk encryption 

Android support **forceencrypt** and **encryptable** encryption flags, and only support ext4 and f2fs file systems.  

Setup forceencrypt [fstab.bullhead](http://androidxref.com/6.0.1_r10/xref/device/lge/bullhead/fstab.bullhead#8):  

```
/dev/block/platform/soc.0/f9824900.sdhci/by-name/userdata     /data           ext4    noatime,nosuid,nodev,barrier=1,data=ordered,nomblk_io_submit,noauto_da_alloc,errors=panic wait,check,forceencrypt=/dev/block/platform/soc.0/f9824900.sdhci/by-name/metadata 
```  

Setup encryptable [fstab.hammerhead](http://androidxref.com/6.0.1_r10/xref/device/lge/hammerhead/fstab.hammerhead#7):  

``` 
/dev/block/platform/msm_sdcc.1/by-name/userdata     /data           ext4    noatime,nosuid,nodev,barrier=1,data=ordered,nomblk_io_submit,noauto_da_alloc,errors=panic wait,check,encryptable=/dev/block/platform/msm_sdcc.1/by-name/metadata 
```  


## Related Properties and source code location  

Related source code:  
* init.rc: `system/core/init/builtins.cpp`  
* fs_mgr: `system/core/fs_mgr/fs_mgr.c`  
* Vold: `system/vold/cryptfs.c`  
* Ext4Crypt: `system/vold/Ext4Crypt.cpp`  
* VoldCryptCmdListener: `system/vold/CryptCommandListener.cpp`  
* MountService: `frameworks/base/services/core/java/com/android/server/MountService.java`  


Properties:  
* vold.decrypt: **fs_mgr** and **Vold** use this property to notify **init.rc**.  
* vold.post_fs_data_done: **Vold** set it to 0 will trigger **init.rc**(on post-fs-data) to prepare necessary path in /data   
* vold.encrypt_progress: Set by **Vold** to display the percentage value.  
* vold.encrypt_time_remaining: Set by **Vold** for UX during encryption progress.  
* ro.crypto.state: Set by **init** to declare encryption status.  
* ro.crypto.type: Set by **init** to determine crypto type (file or block).  
* ro.crypto.fs_crypto_blkdev: Set by **Vold** save the name of the crypto block device so we can mount it when restarting the framework.  


## Encryptable flow

As a encryptable device, you can use Settings to lunch a full disk encryption:  
**Settings -> Security -> Encryption -> Encrypt (tablet/phone)**  

1. Encryption confirm  
When you press Encrypt, CryptKeeperConfirm will call mountService.encryptStorage(), MountService use CryptdConnector send command `cryptfs enablecrypto inplace default_password` to start encrypt process.

2. encrypt flags detection  
**Vold** receive `enablecrypto` command and get encrypt parameters in fstab.{ro.hardware}  
Set `or.crypto.state` to unencrypted  
Set `vold.decrypt` to trigger_shutdown_framework  
**init.rc** receive trigger_shutdown_framework to take down framework  

3. Unmount data  
**Vold** unmount data partition and mount tmpfs to /data 
Set `vold.encrypt_progress` to **0**  
Set `vold.post_fs_data_done` to **0** and wait DATA_PREP_TIMEOUT for **init.rc** set `vold.post_fs_data_done` to 1  
**init** receive `vold.post_fs_data_done` will create necessary path in /data  
Set `vold.encrypt_progress` to **1**  
**Vold** set `vold.decrypt` to **trigger_restart_min_framework** and create crypto device via `create_crypto_blk_dev()`  
Save Key to `/dev/block/platform/msm_sdcc.1/by-name/metadata`  
**init** receive **trigger_restart_min_framework** will bring up framework to show progress.  

4. Encrypt data  
**Vold** call `cryptfs_enable_all_volumes` to do data encryption.  
Call update_progress() to set `vold.encrypt_progress` and `vold.encrypt_time_remaining` value.  
After encryption **Vold** set `sys.powerctl` to **reboot**.  
Reboot system... 

5. Detect encrypted /data  
**init.rc**: mount_all ./fstab.{ro.hardware}  
**Vold** fs_mgr_mount_all(): possibly an encryptable blkdev /dev/block/platform/msm_sdcc.1/by-name/userdata for mount /data type ext4 )  
**Vold** fs_mgr_do_tmpfs_mount /data (mount tmpfs to /data).  
Set `ro.crypto.state` to **encrypted**   
Set `ro.crypto.type` to **block**  
Set `vold.decrypt` to **trigger_default_encryption** 
**init.rc** receive **trigger_default_encryption** will call **defaultcrypto** service to run `cryptfs mountdefaultencrypted`  

6. Mount data 
**Vold** run mountdefaultencrypted  
Call test_mount_encrypted_fs() to verify password.  
Set `ro.crypto.state` to **encrypted**  
Attempt to mount the volume with default_password and succeeded  
Unmount tmpfs, and mount the real /data volume.  
Set `vold.decrypt` to **trigger_restart_framework**  

## Forceencrypt flow

The difference with **encryptable** flag is that **forceencrypt** is auto encrypt at first boot, and no need to reboot during encrypt/decrypt.  

