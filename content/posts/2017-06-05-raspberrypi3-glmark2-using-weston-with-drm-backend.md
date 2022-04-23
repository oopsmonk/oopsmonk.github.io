---
title: "RaspberryPi3: GLMark2 using weston with DRM backend"
tags: ["RaspberryPi"]
date: "2017-06-05 09:39:30 +0800"
---

How to use weston with DRM backend in Raspbian, and gets benchmark score by GLMark2.  
With regards to hardware acceleration, We can enable VC4 driver through `raspi-config`.  

```
# update system and raspi-config script
$ sudo apt-get update && sudo apt-get upgrade  
$ sudo apt-get install raspi-config

# enable Broadcom VC4 driver 
$ sudo raspi-config
Advanced Options -> GL Driver -> GL (Full KMS)  
```

Test environment: 
* 2017-04-10-raspbian-jessie-lite  
* HDMI 1080P 60Hz  
* CPU/GPU use default settings(no overclock)

Test packages:  
* wayland 1.13.0 
* libdrm-2.4.81  
* mesa-17.1.1  
* pixman-0.34.0  
* cairo 1.15.4  
* weston 2.0.0  

In my case, it took about 2.5 hours for clone and compile all packages, so go jogging is a great choice. :-)   
Build script: [RPi3_build_weston.sh](/resource/2017-06-05/RPi3_build_weston.sh)   

```
$ cd ~ && sudo su
# ./RPi3_build_weston.sh all
```

## Run weston  

```
$ sudo su
# export XDG_RUNTIME_DIR=/tmp/weston_runtime
# mkdir $XDG_RUNTIME_DIR && chmod 0700 $XDG_RUNTIME_DIR
# export LD_LIBRARY_PATH=/usr/local/lib/
# weston --tty=2 --idle-time=0 -B drm-backend.so &

Date: 2017-06-02 CST
[09:52:59.501] weston 2.0.0
               http://wayland.freedesktop.org
               Bug reports to: https://bugs.freedesktop.org/enter_bug.cgi?product=Wayland&component=weston&version=2.0.0
               Build: 2.0.0 configure.ac: bump to version 2.0.0 for the official release (2017-02-24 16:19:03 -0800)
[09:52:59.506] Command line: weston --tty=2 --idle-time=0 -B drm-backend.so
[09:52:59.507] OS: Linux, 4.9.24-v7+, #993 SMP Wed Apr 26 18:01:23 BST 2017, armv7l
[09:52:59.509] warning: XDG_RUNTIME_DIR "/tmp/weston_runtime" is not configured
correctly.  Unix access mode must be 0700 (current mode is 700),
and must be owned by the user (current owner is UID 1001).
Refer to your distribution on how to get it, or
http://www.freedesktop.org/wiki/Specifications/basedir-spec
on how to implement it.
[09:52:59.513] Starting with no config file.
[09:52:59.515] Output repaint window is 7 ms maximum.
[09:52:59.516] Loading module '/usr/local/lib/libweston-2/drm-backend.so'
[09:52:59.520] initializing drm backend
[09:52:59.526] using /dev/dri/card0
[09:52:59.528] Loading module '/usr/local/lib/libweston-2/gl-renderer.so'
[09:52:59.586] EGL client extensions: EGL_EXT_client_extensions
               EGL_EXT_platform_base EGL_KHR_client_get_all_proc_addresses
               EGL_KHR_debug EGL_EXT_platform_wayland EGL_MESA_platform_gbm
[09:52:59.588] warning: neither EGL_EXT_swap_buffers_with_damage or EGL_KHR_swap_buffers_with_damage is supported. Performance could be affected.
[09:52:59.588] EGL_KHR_surfaceless_context available
[09:52:59.596] EGL version: 1.4 (DRI2)
[09:52:59.596] EGL vendor: Mesa Project
[09:52:59.596] EGL client APIs: OpenGL OpenGL_ES 
[09:52:59.597] EGL extensions: EGL_EXT_buffer_age EGL_EXT_image_dma_buf_import
               EGL_KHR_cl_event2 EGL_KHR_config_attribs EGL_KHR_create_context
               EGL_KHR_fence_sync EGL_KHR_get_all_proc_addresses
               EGL_KHR_gl_renderbuffer_image EGL_KHR_gl_texture_2D_image
               EGL_KHR_gl_texture_cubemap_image EGL_KHR_image
               EGL_KHR_image_base EGL_KHR_image_pixmap
               EGL_KHR_no_config_context EGL_KHR_reusable_sync
               EGL_KHR_surfaceless_context EGL_KHR_wait_sync
               EGL_MESA_configless_context EGL_MESA_drm_image
               EGL_MESA_image_dma_buf_export EGL_WL_bind_wayland_display
[09:52:59.597] GL version: OpenGL ES 2.0 Mesa 17.1.1 (git-ca0a148)
[09:52:59.598] GLSL version: OpenGL ES GLSL ES 1.0.16
[09:52:59.598] GL vendor: Broadcom
[09:52:59.598] GL renderer: Gallium 0.4 on VC4 V3D 2.1
[09:52:59.598] GL extensions: GL_EXT_blend_minmax GL_EXT_multi_draw_arrays
               GL_EXT_texture_format_BGRA8888
               GL_OES_compressed_ETC1_RGB8_texture GL_OES_depth24
               GL_OES_element_index_uint GL_OES_fbo_render_mipmap
               GL_OES_mapbuffer GL_OES_rgb8_rgba8 GL_OES_stencil8
               GL_OES_texture_3D GL_OES_texture_npot GL_OES_vertex_half_float
               GL_OES_EGL_image GL_OES_depth_texture
               GL_OES_packed_depth_stencil GL_EXT_texture_type_2_10_10_10_REV
               GL_OES_get_program_binary GL_APPLE_texture_max_level
               GL_EXT_discard_framebuffer GL_EXT_read_format_bgra
               GL_EXT_frag_depth GL_NV_fbo_color_attachments
               GL_OES_EGL_image_external GL_OES_EGL_sync
               GL_OES_vertex_array_object GL_EXT_unpack_subimage
               GL_NV_draw_buffers GL_NV_read_buffer GL_NV_read_depth
               GL_NV_read_depth_stencil GL_NV_read_stencil GL_EXT_draw_buffers
               GL_EXT_map_buffer_range GL_KHR_debug GL_OES_surfaceless_context
               GL_EXT_separate_shader_objects
               GL_EXT_compressed_ETC1_RGB8_sub_texture
               GL_EXT_draw_elements_base_vertex GL_EXT_texture_border_clamp
               GL_KHR_context_flush_control GL_OES_draw_elements_base_vertex
               GL_OES_texture_border_clamp
[09:52:59.599] GL ES 2 renderer features:
               read-back format: BGRA
               wl_shm sub-image to texture: yes
               EGL Wayland extension: yes
[09:52:59.601] event0  - [09:52:59.601] USB Keyboard: [09:52:59.601] is tagged by udev as: Keyboard
[09:52:59.601] event0  - [09:52:59.601] USB Keyboard: [09:52:59.601] device is a keyboard
[09:52:59.602] event1  - [09:52:59.602] USB Keyboard: [09:52:59.602] is tagged by udev as: Keyboard
[09:52:59.602] event1  - [09:52:59.602] USB Keyboard: [09:52:59.602] device is a keyboard
[09:52:59.603] event2  - [09:52:59.603] USB Optical Mouse: [09:52:59.603] is tagged by udev as: Mouse
[09:52:59.603] event2  - [09:52:59.604] USB Optical Mouse: [09:52:59.604] device is a pointer
[09:52:59.654] Registered plugin API 'weston_drm_output_api_v1' of size 12
[09:52:59.655] Chosen EGL config details:
               RGBA bits: 8 8 8 0
               swap interval range: 0 - 0
[09:52:59.655] Failed to initialize backlight
[09:52:59.655] EDID data 'BNQ', 'BenQ GW2265', '87E05314019'
[09:52:59.656] Output HDMI-A-1, (connector 24, crtc 65)
               mode 1920x1080@60.0, preferred, current
               mode 1920x1080@59.9
               mode 1920x1080@60.0
               mode 1920x1080@59.9
               mode 1920x1080@50.0
               mode 1920x1080@50.0
               mode 1680x1050@59.9
               mode 1600x900@60.0
               mode 1280x1024@60.0
               mode 1280x800@59.9
               mode 1280x720@60.0
               mode 1280x720@59.9
               mode 1280x720@50.0
               mode 1024x768@60.0
               mode 800x600@60.3
               mode 720x576@50.0
               mode 720x576@50.0
               mode 720x480@60.0
               mode 720x480@59.9
               mode 720x480@60.0
               mode 720x480@59.9
               mode 640x480@60.0
               mode 640x480@59.9
[09:52:59.656] Compositor capabilities:
               arbitrary surface rotation: yes
               screen capture uses y-flip: yes
               presentation clock: CLOCK_MONOTONIC, id 1
               presentation clock resolution: 0.000000001 s
[09:52:59.657] Loading module '/usr/local/lib/weston/desktop-shell.so'
[09:52:59.658] launching '/usr/local/libexec/weston-keyboard'
[09:52:59.660] launching '/usr/local/libexec/weston-desktop-shell'
could not load cursor 'dnd-move'
could not load cursor 'dnd-copy'
could not load cursor 'dnd-none'
could not load cursor 'dnd-move'
could not load cursor 'dnd-copy'
could not load cursor 'dnd-none'
xkbcommon: ERROR: couldn't find a Compose file for locale "en_US.UTF-8"
could not create XKB compose table for locale 'en_US.UTF-8'.  Disabiling compose
xkbcommon: ERROR: couldn't find a Compose file for locale "en_US.UTF-8"
could not create XKB compose table for locale 'en_US.UTF-8'.  Disabiling compose
could not load cursor 'dnd-move'
could not load cursor 'dnd-copy'
could not load cursor 'dnd-none'
xkbcommon: ERROR: couldn't find a Compose file for locale "en_US.UTF-8"
could not create XKB compose table for locale 'en_US.UTF-8'.  Disabiling compose
```  

### weston-simple-egl score  

```
root@RPi3:/home/oopsmonk# weston-simple-egl 
has EGL_EXT_buffer_age and EGL_EXT_swap_buffers_with_damage
152 frames in 5 seconds: 30.400000 fps
151 frames in 5 seconds: 30.200001 fps
151 frames in 5 seconds: 30.200001 fps
^Csimple-egl exiting

root@RPi3:/home/oopsmonk# weston-simple-egl -b
has EGL_EXT_buffer_age and EGL_EXT_swap_buffers_with_damage
32542 frames in 5 seconds: 6508.399902 fps
Draw call returned Invalid argument.  Expect corruption.
30634 frames in 5 seconds: 6126.799805 fps
28265 frames in 5 seconds: 5653.000000 fps
34501 frames in 5 seconds: 6900.200195 fps
32658 frames in 5 seconds: 6531.600098 fps
^Csimple-egl exiting

root@RPi3:/home/oopsmonk# weston-simple-egl -f
has EGL_EXT_buffer_age and EGL_EXT_swap_buffers_with_damage
300 frames in 5 seconds: 60.000000 fps
300 frames in 5 seconds: 60.000000 fps
300 frames in 5 seconds: 60.000000 fps
300 frames in 5 seconds: 60.000000 fps
300 frames in 5 seconds: 60.000000 fps
^Csimple-egl exiting

root@RPi3:/home/oopsmonk# weston-simple-egl -f -b
has EGL_EXT_buffer_age and EGL_EXT_swap_buffers_with_damage
1350 frames in 5 seconds: 270.000000 fps
1325 frames in 5 seconds: 265.000000 fps
1325 frames in 5 seconds: 265.000000 fps
^Csimple-egl exiting
```  

### GLMark2 

```
root@RPi3:/home/oopsmonk# glmark2-es2-wayland 
=======================================================
    glmark2 2014.03
=======================================================
    OpenGL Information
    GL_VENDOR:     Broadcom
    GL_RENDERER:   Gallium 0.4 on VC4 V3D 2.1
    GL_VERSION:    OpenGL ES 2.0 Mesa 17.1.1 (git-ca0a148)
=======================================================
[build] use-vbo=false: FPS: 281 FrameTime: 3.559 ms
[build] use-vbo=true: FPS: 303 FrameTime: 3.300 ms
[texture] texture-filter=nearest: FPS: 375 FrameTime: 2.667 ms
[texture] texture-filter=linear: FPS: 345 FrameTime: 2.899 ms
[texture] texture-filter=mipmap: FPS: 289 FrameTime: 3.460 ms
[shading] shading=gouraud: FPS: 199 FrameTime: 5.025 ms
[shading] shading=blinn-phong-inf: FPS: 145 FrameTime: 6.897 ms
[shading] shading=phong: FPS: 85 FrameTime: 11.765 ms
[shading] shading=cel: FPS: 84 FrameTime: 11.905 ms
[bump] bump-render=high-poly: FPS: 80 FrameTime: 12.500 ms
[bump] bump-render=normals: FPS: 461 FrameTime: 2.169 ms
[bump] bump-render=height: FPS: 390 FrameTime: 2.564 ms
[effect2d] kernel=0,1,0;1,-4,1;0,1,0;: FPS: 161 FrameTime: 6.211 ms
[effect2d] kernel=1,1,1,1,1;1,1,1,1,1;1,1,1,1,1;: FPS: 85 FrameTime: 11.765 ms
[pulsar] light=false:quads=5:texture=false: FPS: 314 FrameTime: 3.185 ms
[desktop] blur-radius=5:effect=blur:passes=1:separable=true:windows=4: FPS: 40 FrameTime: 25.000 ms
[desktop] effect=shadow:windows=4: FPS: 121 FrameTime: 8.264 ms
[buffer] columns=200:interleave=false:update-dispersion=0.9:update-fraction=0.5:update-method=map: FPS: 59 FrameTime: 16.949 ms
[buffer] columns=200:interleave=false:update-dispersion=0.9:update-fraction=0.5:update-method=subdata: FPS: 59 FrameTime: 16.949 ms
[buffer] columns=200:interleave=true:update-dispersion=0.9:update-fraction=0.5:update-method=map: FPS: 75 FrameTime: 13.333 ms
[ideas] speed=duration: FPS: 269 FrameTime: 3.717 ms
[jellyfish] <default>: FPS: 138 FrameTime: 7.246 ms
[terrain] <default>: FPS: 5 FrameTime: 200.000 ms
[shadow] <default>: FPS: 106 FrameTime: 9.434 ms
[refract] <default>: FPS: 21 FrameTime: 47.619 ms
[conditionals] fragment-steps=0:vertex-steps=0: FPS: 392 FrameTime: 2.551 ms
[conditionals] fragment-steps=5:vertex-steps=0: FPS: 259 FrameTime: 3.861 ms
[conditionals] fragment-steps=0:vertex-steps=5: FPS: 389 FrameTime: 2.571 ms
[function] fragment-complexity=low:fragment-steps=5: FPS: 357 FrameTime: 2.801 ms
[function] fragment-complexity=medium:fragment-steps=5: FPS: 48 FrameTime: 20.833 ms
[loop] fragment-loop=false:fragment-steps=5:vertex-steps=5: FPS: 329 FrameTime: 3.040 ms
[loop] fragment-steps=5:fragment-uniform=false:vertex-steps=5: FPS: 329 FrameTime: 3.040 ms
[loop] fragment-steps=5:fragment-uniform=true:vertex-steps=5: FPS: 119 FrameTime: 8.403 ms
=======================================================
                                  glmark2 Score: 203 
=======================================================
```

### GLMark2 Fullscreen  

```
root@RPi3:/home/oopsmonk# glmark2-es2-wayland --fullscreen
=======================================================
    glmark2 2014.03
=======================================================
    OpenGL Information
    GL_VENDOR:     Broadcom
    GL_RENDERER:   Gallium 0.4 on VC4 V3D 2.1
    GL_VERSION:    OpenGL ES 2.0 Mesa 17.1.1 (git-ca0a148)
=======================================================
[build] use-vbo=false: FPS: 183 FrameTime: 5.464 ms
[build] use-vbo=true: FPS: 200 FrameTime: 5.000 ms
[texture] texture-filter=nearest: FPS: 198 FrameTime: 5.051 ms
[texture] texture-filter=linear: FPS: 192 FrameTime: 5.208 ms
[texture] texture-filter=mipmap: FPS: 190 FrameTime: 5.263 ms
[shading] shading=gouraud: FPS: 166 FrameTime: 6.024 ms
[shading] shading=blinn-phong-inf: FPS: 162 FrameTime: 6.173 ms
[shading] shading=phong: FPS: 134 FrameTime: 7.463 ms
[shading] shading=cel: FPS: 128 FrameTime: 7.812 ms
[bump] bump-render=high-poly: FPS: 77 FrameTime: 12.987 ms
[bump] bump-render=normals: FPS: 202 FrameTime: 4.950 ms
[bump] bump-render=height: FPS: 188 FrameTime: 5.319 ms
[effect2d] kernel=0,1,0;1,-4,1;0,1,0;: FPS: 65 FrameTime: 15.385 ms
[effect2d] kernel=1,1,1,1,1;1,1,1,1,1;1,1,1,1,1;: FPS: 33 FrameTime: 30.303 ms
[pulsar] light=false:quads=5:texture=false: FPS: 173 FrameTime: 5.780 ms
[desktop] blur-radius=5:effect=blur:passes=1:separable=true:windows=4: FPS: 16 FrameTime: 62.500 ms
[desktop] effect=shadow:windows=4: FPS: 48 FrameTime: 20.833 ms
[buffer] columns=200:interleave=false:update-dispersion=0.9:update-fraction=0.5:update-method=map: FPS: 51 FrameTime: 19.608 ms
[buffer] columns=200:interleave=false:update-dispersion=0.9:update-fraction=0.5:update-method=subdata: FPS: 51 FrameTime: 19.608 ms
[buffer] columns=200:interleave=true:update-dispersion=0.9:update-fraction=0.5:update-method=map: FPS: 51 FrameTime: 19.608 ms
[ideas] speed=duration: FPS: 126 FrameTime: 7.937 ms
[jellyfish] <default>: FPS: 70 FrameTime: 14.286 ms
[terrain] <default>: FPS: 2 FrameTime: 500.000 ms
[shadow] <default>: FPS: 84 FrameTime: 11.905 ms
[refract] <default>: FPS: 17 FrameTime: 58.824 ms
[conditionals] fragment-steps=0:vertex-steps=0: FPS: 205 FrameTime: 4.878 ms
[conditionals] fragment-steps=5:vertex-steps=0: FPS: 122 FrameTime: 8.197 ms
[conditionals] fragment-steps=0:vertex-steps=5: FPS: 209 FrameTime: 4.785 ms
[function] fragment-complexity=low:fragment-steps=5: FPS: 176 FrameTime: 5.682 ms
[function] fragment-complexity=medium:fragment-steps=5: FPS: 79 FrameTime: 12.658 ms
[loop] fragment-loop=false:fragment-steps=5:vertex-steps=5: FPS: 171 FrameTime: 5.848 ms
[loop] fragment-steps=5:fragment-uniform=false:vertex-steps=5: FPS: 172 FrameTime: 5.814 ms
[loop] fragment-steps=5:fragment-uniform=true:vertex-steps=5: FPS: 58 FrameTime: 17.241 ms
=======================================================
                                  glmark2 Score: 121 
=======================================================
```

### GLMark2 repaint time  

glmark2 set eglSwapInterval() to 0, so it will not waite for vblank.  

**canvas_clear**: glClearColor, glClearDepthf, glClear  
**sence_draw**: glBindBuffer, glBindBuffer  
**sence_update**: update frame counter and elapsed time  
**canvas_update**: eglSwapBuffers, wl_display_roundtrip  
**total_draw**: canvas_clear + sence_draw + canvas_update  

![](/images/2017-06-05/RPi3_jellyfish_100f.png)  

![](/images/2017-06-05/RPi3_refract_100f.png)  

![](/images/2017-06-05/RPi3_shadow_100f.png)  

![](/images/2017-06-05/RPi3_terrain.png)  


