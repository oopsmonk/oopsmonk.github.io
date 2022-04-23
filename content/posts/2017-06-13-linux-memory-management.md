---
title: "[Paper] - An Evolutionary Study of Linux Memory Management for Fun and Profit"
tags: ["Linux"]
date: "2017-06-13 14:47:22 +0800"
---

Memory management主要的功能是page mapping, memory protection, and sharing, 但隨著時間不斷的演進已經算是kernel裡不小的subsystem.  
這份研究分析2009~2015年之間4587筆有關memory management(mm)的patches, Linux版本由v2.6.32.1 ~ v4.0-rc4.  
Source: [An Evolutionary Study of Linux Memory Management for Fun and Profit](https://www.usenix.org/system/files/conference/atc16/atc16_paper-huang.pdf)  

## Memory Bugs  

5種bugs存在mm: memory error, checking, concurrency, logic and programming.  
![](/images/2017-06-13/Table2.png)  

透過heat map可清楚看到主要bug發生地方  
![](/images/2017-06-13/Figure6.png)

主要的bug fix在: Memory Allocation, Garbage Collection (GC), Virtual Memory Management.  
大部份memory leak並不是因為忘了free, 而是錯誤的page fault handling和 free page的計算.  
MM較大的問題是很難去track正確的狀態.  

## Memory optimization  

定義3種optimization patches  

* data structure: 避免nested data structure. Scalability的實現, scalability問題是因為locking for atomic access to shared data structures.  
* memory policy: 使用合理的policy design (latency/throughput, sync/async, lazy/non-lazy, local/global, fairness/performance).  
* fast path: 加速頻繁使用的source code, reduction跟lockless optimization是廣泛被使用. Optimistic barrier是為了減少呼叫barrier/fence system call時的synchronous overheads. (Code reduction, lockless optimization, new function, state caching, inline, code shifting, group excution, optimistic barrier)  

### MM常見的Data structure  

* Radix tree: In adress_space, 主要特色是有效率的存放(sparse)資料.  
* Red-black tree: In vm_area_struct, 可快速的search, insert, delete. 相較於[AVL](https://stackoverflow.com/questions/13852870/red-black-tree-over-avl-tree) 雖然在search上較快但需要額外的空間, insert/delete比較慢, rotation比較困難.  
* Bitmap: 通常用在RAM的page indexing.  
* List: 廣泛使用的DS, 例如LRU(Last Recently Used) list, 用來追蹤active/inactive pages.  

![](/images/2017-06-13/Table3.png)


### Data structure optimization  

* Reducing software overhead(76.2%): 避免nested data structure.  
* Improving scalability for data structure(23.8%): Most of the scalability issues are caused by locking for atomic access to shared data structures.  

### Policy design tackling trade-offs  

![](/images/2017-06-13/Table4.png)  

### Fast Path  

![](/images/2017-06-13/Table6.png)  

## Memory Semantics  

**Memory allocation**: buddy system(page_alloc, slab, slub, slob)已成熟的發展, 但在maintain page status上有許多bug, 主要是checking/lock issues.  

**Memory Resource Controller**: 主要的patches都在memcontrol. Concurrency是最大的問題，其次Fault handler(OOM/page fault)在於錯的page status資訊.  
![](/images/2017-06-13/Table7.png)  

**Virtual Memory Management**: 是MM裡最大的一個component, 仍存在一堆bug, 因為新的硬體, 新的使用方法(huge page)  

**Garbage Collection**: vmscan的kswapd, shrinker, 和 other GC helper, 大多的patch為shrinker的policy design, 為了減少scan時的overhead和決定哪些space該free. shrinker是造成memory performance難以預測的原因. A scalable and coordinated GC is desirable.  

