---
title: "Android Adoptable Storage"
tags: ["Android"]
date: "2017-02-13 10:08:28 +0800"
---

A study of adoptable storage in Android Marshmallow and Nougat.  

# How to Setup a Private Disk (External USB Storage)   

Android adoptable storage allow APP install to external storage that can reserve more internal space for other APPs.  

### Create Adoptable Storage Using Settings GUI   

Settings -> Storage & USB -> Portable storage -> Settings -> Format as internal   

### Use sm (Storage Manager) Command   

* Find disk id  

```  
# sm list-disks  
disk:8,16  
disk:8,0  
```  

* Format as internal   

```
# sm partition disk:8,0 private
# sm list-volumes all
public:8,17 mounted 629C-FBAF
emulated:8,2 unmounted null
private mounted null
emulated mounted null
private:8,2 mounted 3f538e6e-e6a9-4163-ac1e-e4c6602b3c34
```  
 
Now, it's a private storage in system.   

```
# mount
/dev/block/mmcblk0p1 /system ext4 ro,seclabel,noatime,data=ordered 0 0
/dev/block/mmcblk0p3 /cache ext4 rw,seclabel,nosuid,nodev,noatime,discard,journal_checksum,errors=continue,data=ordered 0 0
/dev/block/mmcblk0p2 /data ext4 rw,seclabel,nosuid,nodev,noatime,discard,journal_checksum,errors=continue,data=ordered 0 0
/dev/block/dm-0 /mnt/expand/3f538e6e-e6a9-4163-ac1e-e4c6602b3c34 ext4 rw,dirsync,seclabel,nosuid,nodev,noatime 0 0
```  

## Moving APP to External(Adoptable) Storage  

Not all APPs can move to external storage, only the APPs are declared **android:installLocation** attribute in the Androidmanifest.xml.   
The value for installLocation are **auto**, **internalOnly**, and **preferExternal**. 

```
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    android:installLocation="preferExternal"
        ... >
```

## Install APP to External   

`pm` commands can use to select or find APP's install location.  

* **pm path PACKAGE**  
  Get the location path of the APP.  
* **pm get-install-location**  
  Get the global default install location which is stored in Settings database(default_install_location).   
* **pm set-install-location [0|1|2]**   
  Set default install location 0:auto, 1:internal, 2:external.   
* **pm install -f PATH**   
  Install on internal storage.   
* **pm install -s PATH**   
  Install on external storage.  
 
[pm::makeInstallParams](http://androidxref.com/7.1.1_r6/xref/frameworks/base/cmds/pm/src/com/android/commands/pm/Pm.java#makeInstallParams)  

## How to Move APPs to External    

Moving around External and Internal storage:   

* Settings    
Settings -> APPs -> package -> Storage -> Storage Used.   

* pm (Package Manager)    
Move APP between internal, and external storage.   
`pm move-package PACKAGE [internal|UUID]`    

Ex:  

```
# pm install /data/app-debug.apk
# pm path com.oopsmonk.testinternalinstall                       
package:/data/app/com.oopsmonk.testinternalinstall-1/base.apk 

# sm list-volumes
emulated:8,2 unmounted null
private mounted null
emulated mounted null
private:8,2 mounted 9c019bf2-bb58-4c81-9afe-8ed22d752f91

# pm move-package com.oopsmonk.testinternalinstall 9c019bf2-bb58-4c81-9afe-8ed22d752f91 
# pm path com.oopsmonk.testinternalinstall                     
package:/mnt/expand/9c019bf2-bb58-4c81-9afe-8ed22d752f91/app/com.oopsmonk.testinternalinstall-1/base.apk
```  

# Gaming Rules   

1. Adoptable storage will create a new partition table and destroy data on the disk. 
2. System APP should not install on external storage.  
3. APPs data may lost if external storage was broken. 
4. You can create different external storage using separate disks.   

You should carefully consider whether to install APPs on external storage. 


# How Adoptable Storage Work?  

**Vold**(Volume Daemon) is in charge of creating and mounting storage include adoptable storage. It will create two partitions (android_meta and android_expand) for adoptable storage, the android_meta is a reserved space for feature use and android_expand is the external storage which is encrypted via dm-crypt.  
Both partitions have specific type code.   

    android_meta: 19A710A2-B3CA-11E4-B026-10604B889DCF  
    android_expand: 193D1EA4-B3CA-11E4-B075-10604B889DCF  

The encrypt key is located in /data/misc/vold/expand_GUID.key.   

## Declare Adoptable Devices  

Vold parses mount flags from `fstab.{ro.hardware}`. As an adoptable device, the flags of **voldmanaged** and **encryptable** should be defined. In the meantime, **vold.has_adoptable** is set to 1.    

[fstab.fugu](http://androidxref.com/7.1.1_r6/xref/device/asus/fugu/fstab.fugu)  

```
/devices/*/dwc3-host.2/usb*	auto	auto	defaults	voldmanaged=usb:auto,encryptable=userdata
```

[vold/main](http://androidxref.com/7.1.1_r6/xref/system/vold/main.cpp#process_config)  

```c
    /* Loop through entries looking for ones that vold manages */
    bool has_adoptable = false;
    for (int i = 0; i < fstab->num_entries; i++) {
        if (fs_mgr_is_voldmanaged(&fstab->recs[i])) {
            if (fs_mgr_is_nonremovable(&fstab->recs[i])) {
                LOG(WARNING) << "nonremovable no longer supported; ignoring volume";
                continue;
            }

            std::string sysPattern(fstab->recs[i].blk_device);
            std::string nickname(fstab->recs[i].label);
            int flags = 0;

            if (fs_mgr_is_encryptable(&fstab->recs[i])) {
                flags |= android::vold::Disk::Flags::kAdoptable;
                has_adoptable = true;
            }
            if (fs_mgr_is_noemulatedsd(&fstab->recs[i])
                    || property_get_bool("vold.debug.default_primary", false)) {
                flags |= android::vold::Disk::Flags::kDefaultPrimary;
            }

            vm->addDiskSource(std::shared_ptr<VolumeManager::DiskSource>(
                    new VolumeManager::DiskSource(sysPattern, nickname, flags)));
        }
    }
    property_set("vold.has_adoptable", has_adoptable ? "1" : "0");
    return 0;
```

fstab is parsed in [fs_mgr_fstab.c](http://androidxref.com/7.1.1_r6/xref/system/core/fs_mgr/fs_mgr_fstab.c#mount_flags) 
 
```c
static struct flag_list mount_flags[] = {
    { "noatime",    MS_NOATIME },
    { "noexec",     MS_NOEXEC },
    { "nosuid",     MS_NOSUID },
    { "nodev",      MS_NODEV },
    { "nodiratime", MS_NODIRATIME },
    { "ro",         MS_RDONLY },
    { "rw",         0 },
    { "remount",    MS_REMOUNT },
    { "bind",       MS_BIND },
    { "rec",        MS_REC },
    { "unbindable", MS_UNBINDABLE },
    { "private",    MS_PRIVATE },
    { "slave",      MS_SLAVE },
    { "shared",     MS_SHARED },
    { "defaults",   0 },
    { 0,            0 },
};

static struct flag_list fs_mgr_flags[] = {
    { "wait",        MF_WAIT },
    { "check",       MF_CHECK },
    { "encryptable=",MF_CRYPT },
    { "forceencrypt=",MF_FORCECRYPT },
    { "fileencryption=",MF_FILEENCRYPTION },
    { "forcefdeorfbe=",MF_FORCEFDEORFBE },
    { "nonremovable",MF_NONREMOVABLE },
    { "voldmanaged=",MF_VOLDMANAGED},
    { "length=",     MF_LENGTH },
    { "recoveryonly",MF_RECOVERYONLY },
    { "swapprio=",   MF_SWAPPRIO },
    { "zramsize=",   MF_ZRAMSIZE },
    { "verify",      MF_VERIFY },
    { "noemulatedsd", MF_NOEMULATEDSD },
    { "notrim",       MF_NOTRIM },
    { "formattable", MF_FORMATTABLE },
    { "slotselect",  MF_SLOTSELECT },
    { "nofail",      MF_NOFAIL },
    { "latemount",   MF_LATEMOUNT },
    { "defaults",    0 },
    { 0,             0 },
};
```

## Creating Private Partition  

Tracing the code flow via `sm partition DISK private` command.  
[frameworks/base/cmds/sm/src/com/android/commands/sm/Sm.java](http://androidxref.com/7.1.1_r6/xref/frameworks/base/cmds/sm/src/com/android/commands/sm/Sm.java#runPartition)  
  
```
public void runPartition() throws RemoteException {
    final String diskId = nextArg();
    final String type = nextArg();
    if ("public".equals(type)) {
	mSm.partitionPublic(diskId);
    } else if ("private".equals(type)) {
	mSm.partitionPrivate(diskId);
    } else if ("mixed".equals(type)) {
	final int ratio = Integer.parseInt(nextArg());
	mSm.partitionMixed(diskId, ratio);
    } else {
	throw new IllegalArgumentException("Unsupported partition type " + type);
    }
}
```

then VoldConnector issues partition command to Vold.  
[MountService::partitionPrivate](http://androidxref.com/7.1.1_r6/xref/frameworks/base/services/core/java/com/android/server/MountService.java#partitionPrivate)  

```
mConnector.execute("volume", "partition", diskId, "private"); 
```

[CommandListener::VolumeCmd::runCommand](http://androidxref.com/7.1.1_r6/xref/system/vold/CommandListener.cpp#141)  

```
return sendGenericOkFail(cli, disk->partitionPrivate());
```

Vold handles the partition request.  
[Disk::partitionMixed](http://androidxref.com/7.1.1_r6/xref/system/vold/Disk.cpp#partitionMixed)  

```c
# Force unmount all volumes  
    destroyAllVolumes(); 

# Destory the GPT data structures and then exit.
# /system/bin/sgdisk
#     --zap-all 
#     /dev/block/vold/disk:8,0
    // Zap sometimes returns an error when it actually succeeded, so
    // just log as warning and keep rolling forward.
    if ((res = ForkExecvp(cmd)) != 0) {
        LOG(WARNING) << "Failed to zap; status " << res;
    }

# Create encrypt key and parition GUID for android_expand. 
    if (ReadRandomBytes(16, partGuidRaw) || ReadRandomBytes(16, keyRaw)) {
	LOG(ERROR) << "Failed to generate GUID or key";
	return -EIO;
    }

# Write key to /data/misc/vold/expand_GUID.key   
    if (!WriteStringToFile(keyRaw, BuildKeyPath(partGuid))) {
	LOG(ERROR) << "Failed to persist key";
	return -EIO;
    } else {
	LOG(DEBUG) << "Persisted key for GUID " << partGuid;
    }

# Run partition command via sgdisk tool 
# /system/bin/sgdisk
#     --new=0:0:+16M
#     --typecode=0:19A710A2-B3CA-11E4-B026-10604B889DCF
#     --change-name=0:android_meta
#     --new=0:0:-0
#     --typecode=0:193D1EA4-B3CA-11E4-B075-10604B889DCF
#     --partition-guid=0:c245733cd8ed24d20047ba0c3213de60
#     --change-name=0:android_expand
#     /dev/block/vold/disk:8,0
    if ((res = ForkExecvp(cmd)) != 0) {
        LOG(ERROR) << "Failed to partition; status " << res;
        return res;
    }

```

## Mounting Private Partition  

After disk's partition is changed, kernel rescans the disk and emits an uevent to notify Vold.  
[VolumeManager::handleBlockEvent](http://androidxref.com/7.1.1_r6/xref/system/vold/VolumeManager.cpp#handleBlockEvent)  

```c
    case NetlinkEvent::Action::kAdd: {
		...
                auto disk = new android::vold::Disk(eventPath, device,
                        source->getNickname(), flags);
                disk->create();
                mDisks.push_back(std::shared_ptr<android::vold::Disk>(disk));
                break;
            }
        }
        break;
    }
```

[Disk::create](http://androidxref.com/7.1.1_r6/xref/system/vold/Disk.cpp#create)   

```c

    notifyEvent(ResponseCode::DiskCreated, StringPrintf("%d", mFlags));
# Read lable, size, and system path 
    readMetadata();
# parsing partition table 
    readPartitions();
```

[Disk::readPartitions](http://androidxref.com/7.1.1_r6/xref/system/vold/Disk.cpp#readPartitions)  

```c
# Force unmount all volumes  
    destroyAllVolumes();

# Parsing partition table 
# /system/bin/sgdisk
#     --android-dump
#     /dev/block/vold/disk:8,0
    status_t res = ForkExecvp(cmd, output);

# Encrypted storage is used GPT partition table only. 
# Starting to create private volume   
            } else if (table == Table::kGpt) {
                const char* typeGuid = strtok(nullptr, kSgdiskToken);
                const char* partGuid = strtok(nullptr, kSgdiskToken);

                if (!strcasecmp(typeGuid, kGptBasicData)) {
                    createPublicVolume(partDevice);
                } else if (!strcasecmp(typeGuid, kGptAndroidExpand)) {
                    createPrivateVolume(partDevice, partGuid);
                }
            }

    ...
# Notify MountService  
    notifyEvent(ResponseCode::DiskScanned); 
```

Creating private volume 
[Disk::createPrivateVolume](http://androidxref.com/7.1.1_r6/xref/system/vold/Disk.cpp#createPrivateVolume)  

```c
# Verify GUID and encrypt key
    if (NormalizeHex(partGuid, normalizedGuid)) {
        LOG(WARNING) << "Invalid GUID " << partGuid;
        return;
    }

    std::string keyRaw;
    if (!ReadFileToString(BuildKeyPath(normalizedGuid), &keyRaw)) {
        PLOG(ERROR) << "Failed to load key for GUID " << normalizedGuid;
        return;
    }

# Create private volume and format then destroy it.

    auto vol = std::shared_ptr<VolumeBase>(new PrivateVolume(device, keyRaw));
    if (mJustPartitioned) {
        LOG(DEBUG) << "Device just partitioned; silently formatting";
        vol->setSilent(true);
        vol->create();
        vol->format("auto");
        vol->destroy();
        vol->setSilent(false);
    }

# volume create again  
    mVolumes.push_back(vol);
    vol->setDiskId(getId());
    vol->setPartGuid(partGuid);
    vol->create();
```

[VolumeBase::create](http://androidxref.com/7.1.1_r6/xref/system/vold/VolumeBase.cpp#create)   

```c
# PrivateVolume::doCreate  
    status_t res = doCreate();

# Notify MountService to mount volume use onVolumeCreatedLocked()  
    notifyEvent(ResponseCode::VolumeCreated,
            StringPrintf("%d \"%s\" \"%s\"", mType, mDiskId.c_str(), mPartGuid.c_str()));
```

[PrivateVolume::doCreate](http://androidxref.com/7.1.1_r6/xref/system/vold/PrivateVolume.cpp#doCreate)  

```c
    if (CreateDeviceNode(mRawDevPath, mRawDevice)) {
        return -EIO;
    }

    // Recover from stale vold by tearing down any old mappings
    cryptfs_revert_ext_volume(getId().c_str());

    // TODO: figure out better SELinux labels for private volumes

    unsigned char* key = (unsigned char*) mKeyRaw.data();
    char crypto_blkdev[MAXPATHLEN];
    int res = cryptfs_setup_ext_volume(getId().c_str(), mRawDevPath.c_str(),
            key, mKeyRaw.size(), crypto_blkdev);
    mDmDevPath = crypto_blkdev;
    if (res != 0) {
        PLOG(ERROR) << getId() << " failed to setup cryptfs";
        return -EIO;
    }

    return OK;
```

When MountService receives VOLUME\_CREATED event from VolumeBase::create(), it calls Vold to do mount process. 

[MountService::onEventLocked](http://androidxref.com/7.1.1_r6/xref/frameworks/base/services/core/java/com/android/server/MountService.java#onEventLocked)

```java
# Handle event from VolumeBase::create then get disk info.  
    case VoldResponseCode.VOLUME_CREATED: {
	final String id = cooked[1];
	final int type = Integer.parseInt(cooked[2]);
	final String diskId = TextUtils.nullIfEmpty(cooked[3]);
	final String partGuid = TextUtils.nullIfEmpty(cooked[4]);

	final DiskInfo disk = mDisks.get(diskId);
	final VolumeInfo vol = new VolumeInfo(id, type, disk, partGuid);
	mVolumes.put(id, vol);
# Ack Vold to mount this volume. 
	onVolumeCreatedLocked(vol);
	break;
    }
```

[MountService::handleMessage](http://androidxref.com/7.1.1_r6/xref/frameworks/base/services/core/java/com/android/server/MountService.java#handleMessage)  

```java
# Ack Vold to run mount command via vold/CommandListener.   
    case H_VOLUME_MOUNT: {
	final VolumeInfo vol = (VolumeInfo) msg.obj;
	if (isMountDisallowed(vol)) {
	    Slog.i(TAG, "Ignoring mount " + vol.getId() + " due to policy");
	    break;
	}
	try {
	    mConnector.execute("volume", "mount", vol.id, vol.mountFlags,
		    vol.mountUserId);
	} catch (NativeDaemonConnectorException ignored) {
	}
	break;
    }
```

[CommandListener::VolumeCmd::runCommand](http://androidxref.com/7.1.1_r6/xref/system/vold/CommandListener.cpp#208)  

```c
    } else if (cmd == "mount" && argc > 2) {
        // mount [volId] [flags] [user]
        std::string id(argv[2]);
        auto vol = vm->findVolume(id);
        if (vol == nullptr) {
            return cli->sendMsg(ResponseCode::CommandSyntaxError, "Unknown volume", false);
        }

        int mountFlags = (argc > 3) ? atoi(argv[3]) : 0;
        userid_t mountUserId = (argc > 4) ? atoi(argv[4]) : -1;

        vol->setMountFlags(mountFlags);
        vol->setMountUserId(mountUserId);
# Call VolumeBase::mount() then PrivateVolume::doMount() 
        int res = vol->mount();
        if (mountFlags & android::vold::VolumeBase::MountFlags::kPrimary) {
            vm->setPrimary(vol);
        }
        return sendGenericOkFail(cli, res);

    } else if (cmd == "unmount" && argc > 2) {
```

# Conclusion  

The prosess of adoptable storage is more simple than [Full Disk Encryption](/blog/2016/04/29/android-full-disk-encryption-workflow)  

1. Unmount all volumes.
1. Create new GPT table, GUID, and encrypt key. 
1. Generate android\_meta, android\_expand, and shared (if ratio partition) partitions. 
1. Get block device added uevent from Kernel. 
1. Decrypt private volumes. 
1. Mount public and private volumes.  

# Related Source code  

```
# Communicate with Vold and Framework. 
frameworks/base/services/core/java/com/android/server/MountService.java

# Parse fstab. 
system/core/fs_mgr  

# Partition, mount, unmout, and format private volume
# Genrate encrypt key. 
system/vold/

# Decrytp and encrypt private volume, crypto type name is "aes-cbc-essiv:sha256" 
system/vold/cryptfs.c

# Partition tool 
external/gptfdisk/sgdisk.cc
```

