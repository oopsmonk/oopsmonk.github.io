---
title: "Extend Volume Size on AWS EC2"
date: 2023-08-11T14:15:05+08:00
description: "Extend EBS size on EC2 instance"
# weight: 1
tags: ["AWS"]
# author: ["Me", "You"] # multiple authors
draft: false
hidemeta: false
# comments: false
# disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: false # when using page bundles set this to true
#     hidden: true # only hide on current single page
---

If we wanna extend the storage space of the computer, we need to shut the machine down then you are able to add another storage device for it.

Advantages of using Elastic Block Store(EBS) are
- reboot the instance is not needed.
- the space can be extended instead of adding a new device.

Increase EBS volume size on EC2 is easy:
1. Modify the volume on AWS Console
2. Extend the partition by `growpart`
3. Extend the file system by `resize2fs`(ext4) or `xfs_growfs`(xfs)

## Step 1: Modify the volume on AWS Console

Login to [AWS Console](https://aws.amazon.com/console/) and select a volume via the `Volume ID` then click the `Modify` button on the top right corner. It will bring you to the modify configuration page.

Change the volume type or the size then click the `Modify` button again.

![](/images/2023-08-11/modify-volume.png)

The **Volume state** column and the **Volume state** field in the **Details** tab contain information in the following format: `volume-state` - `modification-state` (`progress`%). Once you modify the volume, the `modification-state` could be `modifying`, `optimizing`, and `completed`. you can proceed when the `modification-state` changed to `optimizing`.

![](/images/2023-08-11/volume-state.png)

## Step 2: Extend The Partition by `growpart`

Connect to the EC2 instance, find the partition name and number via `lsblk` command.

```bash
ubuntu@ip-xxx-xxx-xxx-xx:~$ sudo lsblk
NAME         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0          7:0    0  24.4M  1 loop /snap/amazon-ssm-agent/6312
loop1          7:1    0  24.8M  1 loop /snap/amazon-ssm-agent/6563
...
loop8          7:8    0  63.4M  1 loop /snap/core20/1950
loop9          7:9    0  53.3M  1 loop /snap/snapd/19361
loop10         7:10   0  55.7M  1 loop /snap/core18/2785
nvme0n1      259:0    0   200G  0 disk 
├─nvme0n1p1  259:1    0  99.9G  0 part /
├─nvme0n1p14 259:2    0     4M  0 part 
└─nvme0n1p15 259:3    0   106M  0 part /boot/efi
```

We are changing the root partition `nvme0n1p1`, where the partition name is `nvme0n1` and partition number is `1`.

```bash
ubuntu@ip-xxx-xxx-xxx-xx:~$ sudo growpart /dev/nvme0n1 1
CHANGED: partition=1 start=227328 old: size=209487839 end=209715167 new: size=419203039 end=419430367
```

Check the modification

```bash
ubuntu@ip-xxx-xxx-xxx-xx:~$ sudo lsblk
NAME         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0          7:0    0  24.4M  1 loop /snap/amazon-ssm-agent/6312
...
loop10         7:10   0  55.7M  1 loop /snap/core18/2785
nvme0n1      259:0    0   200G  0 disk 
├─nvme0n1p1  259:1    0 199.9G  0 part /
├─nvme0n1p14 259:2    0     4M  0 part 
└─nvme0n1p15 259:3    0   106M  0 part /boot/efi
ubuntu@ip-xxx-xxx-xxx-xx:~$
```

## Step 3: Extend The File System by `resize2fs` or `xfs_growfs`

The size of file system is remain the same after we changed the partition size, here my file system type is `etx4`.

```bash
ubuntu@ip-xxx-xxx-xxx-xx:~$ df -hT
Filesystem      Type   Size  Used Avail Use% Mounted on
/dev/root       ext4    97G   92G  5.4G  95% /
tmpfs           tmpfs  3.8G     0  3.8G   0% /dev/shm
tmpfs           tmpfs  1.6G  996K  1.6G   1% /run
tmpfs           tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/nvme0n1p15 vfat   105M  6.1M   99M   6% /boot/efi
tmpfs           tmpfs  777M  4.0K  777M   1% /run/user/1000
```

We are able to extend the `ext4` via `resize2fs`

```bash
ubuntu@ip-xxx-xxx-xxx-xx:~$ sudo resize2fs /dev/nvme0n1p1
resize2fs 1.46.5 (30-Dec-2021)
Filesystem at /dev/nvme0n1p1 is mounted on /; on-line resizing required
old_desc_blocks = 13, new_desc_blocks = 25
The filesystem on /dev/nvme0n1p1 is now 52400379 (4k) blocks long.
```

Using `xfs_growfs` for `xfs` file system, like

```bash
sudo xfs_growfs -d /
```

Double check! 

```bash
ubuntu@ip-xxx-xxx-xxx-xx:~$ df -hT
Filesystem      Type   Size  Used Avail Use% Mounted on
/dev/root       ext4   194G   92G  103G  48% /
tmpfs           tmpfs  3.8G     0  3.8G   0% /dev/shm
tmpfs           tmpfs  1.6G  996K  1.6G   1% /run
tmpfs           tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/nvme0n1p15 vfat   105M  6.1M   99M   6% /boot/efi
tmpfs           tmpfs  777M  4.0K  777M   1% /run/user/1000
```

## Troubleshooting

`resize2fs: Bad magic number in super-block while trying to open /dev/nvme0n1p1`:  
it's not an `ext4` file system, check the file system type with `df -hT`

`open: No such file or directory while opening /dev/nvme0n1p1`:  
wrong partition name, check the name with `df -hT`

`The filesystem is already 52400379 (4k) blocks long.  Nothing to do!`:  
make sure the **Step 2** was succeeded.
 
