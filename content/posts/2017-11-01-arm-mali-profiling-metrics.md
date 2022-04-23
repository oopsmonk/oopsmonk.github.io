---
title: "ARM Mali Profiling Metrics"
tags: ["ARM"]
date: "2017-11-01 19:14:00 +0800"
---

Some metrics for ARM Mali performance analysis in DS-5 Streamline or MGD.  

# DS-5 Streamline  

## Mali-470 (Utgard)  

GPU Bandwidth = (Words read, master + Words written, master) * Bus Width  
Overdraw = Fragments Passed Z/stencil count * Number of Cores / Resolution * FPS

![](/images/2017-11-01/Mali470MP4_750MHz_DS5.png)  

GPU Bandwidth = (38342943+38661456) * (128/8) = 1232070384 bytes/s = 1174.99 MB/s
Overdraw = (79194586+79152584+79112550+79117609)/(1920x1080) = 152.67  

## Mali-T820 (Midgard)  

Job Slots  

* JS0: fragment shading.  
* JS1: vertex, geometry, compute, and tiling.  
* JS2: vertex, geometry, and compute.  

Fragment Percentage = (JS0 Active / GPU frequency) * 100  
Vertex percentage = (JS1 Active / Frequency) * 100  
Load Store CPI = Full Pipeline issues / Load Store Instruction Words Completed  
GPU Bandwidth  = (External read beats + External write beats) * Bus Width  
Overdraw = Fragment Threads Started * Number of Cores/ Resolution * FPS  

![](/images/2017-11-01/T820MP3_AFBC_520MHz_1080P.png)  

GPU Bandwidth  = (35942654+29615172) * (128/8) = 1048925216 bytes/s = 1000.33 MB/s  

![](/images/2017-11-01/T820MP3_AFBC_520MHz_1080P_JS.png)  
Fragment Percentage = (10347901 / 10351030) * 100 = 99.96%  
Vertex percentage = ( 1635340 / 10351030) * 100 = 15.79%  


# Mali Graphic Debugger(MGD)  

**GPU Budget**  
Total vertex cycle count/frame/pixel = vertex cycles / frame buffer pixels  
Total fragment cycle count/frame/pixel = fragment cycles / frame buffer pixels  
Total cycle count/frame/pixel = fragment cycle + vertex cycle  

## Mali-470 (Utgard)  

T470MP4@750MHz with 1920x1080 resolution, application rendering framebuffer 512x512.  
Total vertex cycle count/frame/pixel = 1224001 / (512 * 512) ~= 4.66 cycles/frame/pixel  
Total fragment cycle count/frame/pixel = 6429459 / (512 * 512) = 24.52 cycles/frame/pixel  
Total cycle count/frame/pixel = 24.52+4.66 = 29.18 cycles/frame/pixel  
vertexCycleBudget = (750M cycles/sec) / (60 frames/sec * 108926)  = 114.75 cycles/frame/vertex  

![](/images/2017-11-01/MGD_Mali-470MP4_750M_Vertex.png)  
![](/images/2017-11-01/MGD_Mali-470MP4_750M_Fragment.png)  


## Mali-T820 (Midgard)  

T820MP3@620MHz with 1920x1080 resolution, application rendering framebuffer 512x512.  

Total vertex cycle count/frame/pixel = 919273 / (512 * 512) = 3.5 cycles/frame/pixel  
Total fragment cycle count/frame/pixel = 6713456 / (512 * 512) = 25.6 cycles/frame/pixel  
Total cycle count/frame/pixel = 29.1 cycles/frame/pixel  
vertexCycleBudget = (620M * 3 cycles/sec) / (60 frames/sec * 92141)  = 672.88 cycles/frame/vertex  

![](/images/2017-11-01/MGD_MaliT820MP3_620MHz_Vertex.png)  
![](/images/2017-11-01/MGD_MaliT820MP3_620MHz_Fragment.png)  

References:  
[GPU Processing Budget Approach to Game Development](https://community.arm.com/graphics/b/blog/posts/gpu-processing-budget-approach-to-game-development)  
[Mali Midgard Family Performance Counters](https://community.arm.com/graphics/b/blog/posts/mali-midgard-family-performance-counters)  
[Using Streamline to Guide Cache Optimization](https://community.arm.com/tools/b/blog/posts/using-streamline-to-guide-cache-optimization)  
[Mali GPU Tools: A Case Study, Part 1](https://community.arm.com/graphics/b/blog/posts/mali-gpu-tools-a-case-study-part-1-profiling-epic-citadel)  
[Using Streamline to Optimize Applications for Mali GPUs](https://developer.arm.com/products/software-development-tools/ds-5-development-studio/resources/tutorials/using-streamline-to-optimize-applications-for-mali-gpus)  
[Performance Analysis and Debugging with Mali.pdf](https://community.arm.com/cfs-file/__key/telligent-evolution-components-attachments/01-2066-00-00-00-00-47-97/Performance-Analysis-and-Debugging-with-Mali.pdf)  

