---
title: "Linux Graphic Stack相關的名詞"
tags: ["Linux"]
date: "2017-05-30 14:46:40 +0800"
---

Linux graphic 架構還滿複雜的, 在看時需要大略了解几個名詞及之間的關係.  

* [X Window System](https://en.wikipedia.org/wiki/X_Window_System):  
目前來到第11版本所以叫X11, 是以[X window System Core protocol](https://en.wikipedia.org/wiki/X_Window_System_core_protocol)為基礎的window system.  

* [wayland](https://en.wikipedia.org/wiki/Wayland_(display_server_protocol)):  
由於X11太過複雜且在embbeded system中的效能不佳, 用來取代X window System Core protocol.  

* weston (wayland compositor):  
以wayland protocol來實做的compositor做為參考的範例, 實用上會用Westeros, Clutter...等.  

* [KMS/UMS](https://en.wikipedia.org/wiki/Mode_setting):  
Kernel mode-setting 及User mode-setting.  

* OpenGL: 
由[Khronos Group](https://en.wikipedia.org/wiki/Khronos_Group)制定的跨平台graphic API.  

* GLX:  
是一個extension, 做為OpenGL與X window system之間的橋樑. 就像embedded system的EGL, MacOS的AGL.  

* [DRM(Direct Rendering Manager)](https://en.wikipedia.org/wiki/Direct_Rendering_Manager):  
為了防止世界被破壞, 保護世界的和平. 防止同時使用graphic buffer.   

* [DRI(Direct Rendering Infrastructure)](https://en.wikipedia.org/wiki/Direct_Rendering_Infrastructure):  
Mesa及DRM之間的橋樑. Ref: [Introduction to the Direct Rendering Infrastructure](http://dri.sourceforge.net/doc/DRIintro.html)  

* [CRTC (CRT Controller)](https://en.wikipedia.org/wiki/Video_display_controller):  
Crtc is in charge of reading the framebuffer memory and routes the data to an encoder.  

Other resources:  
[Linux GPU Driver Developer’s Guide](https://01.org/linuxgraphics/gfx-docs/drm/gpu/index.html)  
[dri-explanation.txt](https://people.freedesktop.org/~ajax/dri-explanation.txt)  
[Linux Graphics Drivers: an Introduction](https://people.freedesktop.org/~marcheu/linuxgraphicsdrivers.pdf)  
[Direct Rendering Manager (DRM)](https://dri.freedesktop.org/wiki/DRM/)  
[Using Linux Media Controller for Wayland/Weston Renderer](http://events.linuxfoundation.org/sites/events/files/slides/als2015_wayland_weston_v2.pdf)  
[Graphics Stack Update](https://www.slideshare.net/linaroorg/bkk16315-graphics-stack-update)  


## Graphic Architectures  

**Linux Graphics Stack 2013** [Source](https://commons.wikimedia.org/wiki/File:Free_and_open-source-software_display_servers_and_UI_toolkits.svg)  
![](/images/2017-05-30/Linux_Graphics_Stack_2013.svg)  

**Intel Graphics Stack Architecture Diagram** [Source](https://01.org/linuxgraphics/documentation/build-guide-0)  
![](/images/2017-05-30/intel-gfx-stack-architecture2.jpg)  

**Wayland/X11 Graphics Architecture** [Source](https://www.slideshare.net/linaroorg/bkk16315-graphics-stack-update) 
![](/images/2017-05-30/WaylandX11GraphicsArchitecture.png)  

**Android Graphics Architecture** [Source](https://www.slideshare.net/linaroorg/bkk16315-graphics-stack-update)  
![](/images/2017-05-30/AndroidGraphicsArchitecture.png)  

