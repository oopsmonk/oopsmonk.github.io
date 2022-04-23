---
title: "How to split boot.img and get kernel config"
tags: ["Android", "Linux"]
date: 2012-09-12
---

boot\_cm9.img file from [mk802_legacy-compatibility_v1.zip](http://www.androidfilehost.com/main/Allwinner_A10_Developers/christiantroy/misc/legacy/mk802_legacy-compatibility_v1.zip)  
Device: Rikomagic MK802  
Script files : [Split_bootimg.pl](http://zen-droid.googlecode.com/files/split_bootimg.pl) , extract-ikconfig ( in {kernel\_source}/script )

## Split boot.img

Copy boot\_cm9.img, Split\_bootimg.pl, extract-ikconfig into 'split\_boot'  

```
$ mkdir split_boot
$ cd split_boot
$ ./split_bootimg.pl boot_cm9.img
Page size: 2048 (0x00000800)
Kernel size: 8094708 (0x007b83f4)
Ramdisk size: 178940 (0x0002bafc)
Second size: 0 (0x00000000)
Board name:
Command line: console=ttyS0,115200 rw init=/init loglevel=8
Writing boot_cm9.img-kernel ... complete.
Writing boot_cm9.img-ramdisk.gz ... complete.
```

Get kernel image (__boot_cm9.img-kernel__) and ramdisk (__boot_cm9.img-ramdisk.gz__)

## Extract kernel config

```
$ dd if=boot_cm9.img-kernel of=dd_uImage bs=1024 skip=1
7903+1 records in
7903+1 records out
8093684 bytes (8.1 MB) copied, 0.0178518 s, 453 MB/s
$./extract-ikconfig dd_uImage > kernel_config
```

## Extract ramdisk

```
$ mkdir ramdisk
$ cd ramdisk
$ gzip -dc ../boot_cm9.img-ramdisk.gz | cpio -i
6677 blocks
$ tree .
.
├── data
├── default.prop
├── dev
├── init
├── init.goldfish.rc
├── initlogo.rle
├── init.rc
├── init.sun4i.rc
├── init.sun4i.usb.rc
├── proc
├── sbin
│   ├── adbd
│   └── ueventd -> ../init
├── sys
├── system
├── ueventd.goldfish.rc
├── ueventd.rc
└── ueventd.sun4i.rc
```

Reference:  
[HOWTO: Unpack, Edit, and Re-Pack Boot Images](http://android-dls.com/wiki/index.php?title=HOWTO:_Unpack%2C_Edit%2C_and_Re-Pack_Boot_Images)

