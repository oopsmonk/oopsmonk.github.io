---
title: "How to extract kernel config from uImage"
tags: ["Linux", "Android"]
date: 2012-08-21
---

### Get extract-ikconfig in kernel-source/scripts/

```
$mkdir extreact-uImage
$cd extreact-uImage
$cp {kernel-source}/scripts/extract-ikconfig .
```

### Dump uImage skip 1024 bytes

```
$cp {uImage/what/you/want} uImage
$dd if=uImage of=dd_uImage bs=1024 skip=1
$./extract-ikconfig dd_uImage > config 
```
