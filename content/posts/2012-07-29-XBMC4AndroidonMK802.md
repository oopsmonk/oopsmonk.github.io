---
title: "XBMC for Android on MK802"
tags: ["Android"]
date: 2012-07-29
---

XBMC announced [XBMC for Android](http://xbmc.org/theuni/2012/07/13/xbmc-for-android/).  
不過並不打算放上Google Play, 需要自行compile及打包, 方法可參考:  
[Build XBMC for Android on lubuntu 12.04](/blog/2012/07/28/BuildXBMC)  

在此記錄一下目前在MK802跑起來的情況.  
MK802介紹可參考:  
[Android 4.0 mini PC 最小的主機MK802](http://dacota.pixnet.net/blog/post/30077383)  
CPU : Allwinner A10 - ARM Cortex A8 SoC  
GPU : ARM Mali 400  
RAM : 1GB  
以公定價$79USD及讓人跌破眼鏡的入手價, 拿來玩真是夠本了.  
這次是要用Android 手機來控制 XBMC, 因為MK802沒有IR只能用滑鼠操作上有些不便.  
Google Play上有[Official XBMC Remote](https://play.google.com/store/apps/details?id=org.xbmc.android.remote&hl=zh_TW)可直接下載來用.  

![](/images/2012-07-29/DSCN1987_re_note.jpg)  

中文設定: 切換到Appearance -> Setting -> International -> Language  
![](/images/2012-07-29/DSCN1995_re.jpg)  
![](/images/2012-07-29/DSCN2003_re.jpg)  

為了能透過HTTP連到MK802的XBMC, 需要將"網站伺服"的功能打開, 設定port number  
![](/images/2012-07-29/DSCN2004_re.jpg)  

接著查看IP, 設定手機上的XBMC Remote如下:  
![](/images/2012-07-29/DSCN2005_re_note.jpg)  

連線成功就會出現控制選項  
![](/images/2012-07-29/DSCN2006_re.jpg)  

用手機上"Remote Control" Navigation, 測試播放USB裡的影片  
![](/images/2012-07-29/DSCN2008_re.jpg)  

影片開播後選手機上的"Now Playing", 可以做seek, FF/FB功能, 音量控制是使用手機上的音量鍵.  
(當初還因為無法控制音量煩腦, 沒想到直接用就可以...冏)  
![](/images/2012-07-29/DSCN2011_re.jpg)  

播放online radio, 用的是SKY.FM, 可以到"附加元件"中下載安裝.  
![](/images/2012-07-29/DSCN2013_re.jpg)  

音樂Full screen播放, 可以看到背景的GL動畫還可以跑到31fps, 似乎還OK.  
![](/images/2012-07-29/DSCN2015_re.jpg)  

天氣+音樂播放, 後面的GL動畫還是正常顯示, 並不是靜態的.  
![](/images/2012-07-29/DSCN2016_re.jpg)  

後記:  

1. 透過附加元件下載安裝的YouTube及Time.com無法正常播放video.  
1. 很吃記憶體大約要吃掉80MB.  
1. 研究XBMC在Android 如何implement, 應該是很有趣的.必竟XBMC是用自己的GUI系統, 還要克服Bionic libc在dlopen的不足之處.   

