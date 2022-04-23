---
title: "Android Media Framework"
tags: ["Android"]
date: "2016-06-16 15:45:54 +0800"
---

Android APIs for media playback: MediaPlayer and MediaCodec.  

* MediaPlayer  

```java 
mediaPlayer.setDataSource(path);    //fd or url
mediaPlayer.setDisplay(SurfaceHolder sh);  //SurfaceView or VideoView  
mediaPlayer.prepare(); // 
MediaPlayer.start(); //

```

* MediaCodec  

```java  

/* init  
use MediaExtractor to get mime data  
create decoder by mime type 
configure decoder by video format and surface view  
*/ 
MediaExtractor mExtractor;
MediaCodec mDecoder;
mExtractor = new MediaExtractor();
mExtractor.setDataSource(filePath);
MediaFormat format = mExtractor.getTrackFormat(track_index);  
String mime = format.getString(MediaFormat.KEY_MIME);
if mime.startsWith("video/")  
    mExtractor.selectTrack(track_index);
    mDecoder = MediaCodec.createDecoderByType(mime);
    mDecoder.configure(format, surface, null, 0 /* Decoder */);  
    mDecoder.start();


/*run
start decode video, fill / empty buffer  
*/

```

[MediaCodecExample](https://github.com/taehwandev/MediaCodecExample)    

# Simple Video Decode/Encode Flow  

* FFmpeg   

![](/images/2016-06-16/FFMPEG-command-Sequence.png)  
[Demultiplexer](https://en.wikipedia.org/wiki/Demultiplexer_(media_file))  
[Mux? Demux? Remux? Huh?](http://adubvideo.net/informative/mux-demux-remux-huh)  

* GStreamer  

![](/images/2016-06-16/GStreamer-simple-player.png)  

* The Chromium  

![](/images/2016-06-16/the_chromium_video_stack_arch.png)  


Reference:  
[A Weekend with GStreamer](http://www.oz9aec.net/index.php/gstreamer/345-a-weekend-with-gstreamer)  
[The Chromium Projects](https://www.chromium.org/developers/design-documents/video)  
[Handy FFMPEG commands for all video processing needs](http://www.mediaentertainmentinfo.com/2015/06/5-technical-series-handy-ffmpeg-commands-to-get-your-video-processing-done.html/)  

# History of Android Media Framework  

* OpenCore (Android 1.0)  

![](/images/2016-06-16/Android_OpenCoreArch.jpg)  

* OpenCore and Stagefright (Android 2.1, Eclair)  

![](/images/2016-06-16/OpenCoreAndStagefright.jpg)  
[stagefright框架（一）Video Playback的流程](http://blog.csdn.net/mlbcday/article/details/7319674)  

* Stagefright and AwesomePlayer (Android 4.0, Ice Cream Sandwich)  

* Stagefright and NuPlayer (Android 5.1, Lollipop)  

![](/images/2016-06-16/Android4.1_MediaArch.png)  
[Android MediaPlayerService Architecture](https://edwardlu0904.wordpress.com/2015/09/04/android-mediaplayerservice-architecture/)  

## What are StagefrightPlayer, AwesomePlayer, NuPlayer, OpenCore, OpenMAX, and Exoplayer?  

OpenCore is a media framework witch is replaced by Stagefright in Android 2.x. Stagefright relies only on OpenMAX interface for all the codecs.  

StagefrightPlayer is an implement of AwesomePlayer, it call AwesomePlayer's API. [StagefrightPlayer Constructor](http://androidxref.com/6.0.1_r10/xref/frameworks/av/media/libmediaplayerservice/StagefrightPlayer.cpp#30)   

NuPlayer and AwesomePlayer both are a player. At first NuPlayer is designed for stream playback, but it replaces AwesomePlayer in Android 5.1 (Lollipop).  

![](/images/2016-06-16/NuPlayerAndAwesomePlayer.png)  

ExoPlayer is an open source, application level media player built on top of Android’s low level media APIs, support Android 4.1 above(API level 16).   
![](/images/2016-06-16/exoplayer-standard-model.png)  
[ExoPlayer Developer Guide](https://google.github.io/ExoPlayer/guide.html)  
[Introduction to Android ExoPlayer](http://www.tothenew.com/blog/introduction-to-android-exoplayer/)  
[Interface ExoPlayer](https://google.github.io/ExoPlayer/doc/reference/com/google/android/exoplayer/ExoPlayer.html)  


# Dive into Android 6 Media Framework  

## Current Media Framework  

![Current Media Framework](/images/2016-06-16/Android_MediaFramework_20160616.png)  

* Application Framework  
    At the application framework level is the app's code, which utilizes the **android.media** APIs to interact with the multimedia hardware. 
* Binder IPC  
    The Binder IPC proxies facilitate communication over process boundaries. They are located in the **frameworks/av/media/libmedia** directory and begin with the letter "I".  
* Native Multimedia Framework  
    At the native level, Android provides a multimedia framework that utilizes the Stagefright engine for audio and video recording and playback. Stagefright comes with a default list of supported software codecs and you can implement your own hardware codec by using the OpenMax integration layer standard. For more implementation details, see the various MediaPlayer and Stagefright components located in **frameworks/av/media**.    
* OpenMAX Integration Layer (IL)  
    The OpenMAX IL provides a standardized way for Stagefright to recognize and use custom hardware-based multimedia codecs called components. You must provide an OpenMAX plugin in the form of a shared library named **libstagefrighthw.so**. This plugin links your custom codec components to Stagefright. Your custom codecs must be implemented according to the OpenMAX IL component standard.   

![](/images/2016-06-16/AndroidMediaPlaybackFramework-AOSP.png)  

**AwesomePlayer is deprecated**, but source code still in the path *frameworks/av/media/libmediaplayerservice/StagefrightPlayer.cpp* 

## Media Playback Architecture   


![](/images/2016-06-16/AndroidM_MediaArchitecture.png)  

MediaPlayerFactory: For different format media files, there are different **scoring rule** for choosing player. Each factory must has its own score function implement. 

![](/images/2016-06-16/MediaPlayerFactory.png)  



[Android Multimedia Framework](http://www.slideshare.net/pickerweng/android-multimedia-framework)  
[Inside of Stagefright](https://prezi.com/qp0qeotjn4zb/inside-of-stagefright/)  
[Android’s Stagefright Media Player Architecture](https://quandarypeak.com/2013/08/androids-stagefright-media-player-architecture/)  


## Media Playback Use MediaPlayer  

[android多媒體框架之流媒體具體流程篇1----base on jellybean](http://blog.csdn.net/tjy1985/article/details/8123515)  

## Media Playback Use MediaExtractor  

![](/images/2016-06-16/MediaExtractor_native_init.png)  


## Resources  
[Stagefright vs Gstreamer](http://stackoverflow.com/questions/15809365/stagefright-vs-gstreamer)  
[Android多媒体开发](http://blog.csdn.net/tx3344/article/category/1207767)  
[Handy FFMPEG commands for all video processing needs](http://www.mediaentertainmentinfo.com/2015/06/5-technical-series-handy-ffmpeg-commands-to-get-your-video-processing-done.html/)  
[MediaExtractor介绍](http://blog.csdn.net/dtplayer/article/details/11330343)  
[Implement a custom codec](http://wangjw.info/wordpress/implement-a-custom-codec/)  
[NuPlayer for HTTP live streaming](http://www.cnblogs.com/zhgyee/archive/2011/10/31/2230852.htm)  

