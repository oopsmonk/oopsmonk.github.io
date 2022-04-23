---
title: "Android Threads, Handlers and AsyncTask"
comments: true
tags: ["Android", "Linux"]
date: 2012-06-14
---

先看過[Processes and Threads](http://developer.android.com/guide/components/processes-and-threads.html)會有比較清楚的概念, 當Adnroid Application 啟動後, 系統會建一個主要的thread 稱 "main thread" or "UI thread", 所有的components 皆跑在這個UI thread, system calls 也是透過UI thread dispatched給各個component, ex: onKeyDown, touch event.  
UI thread 如因大量運算或等待而blocked, 預設超過5秒ANR(Application Not Responding)就會發生.  
且Android UI components 並非thread-safe, 使用上要特別小心.  
所以:

* long time computation使用另外的thread, 不要寫在 UI Thread.
* 不要在UI thread 之外使用UI component method.
* 透過Thread, Handler and AsyncTask perform asynchronous processing, 避免UI thread block.

## [Threads](http://developer.android.com/reference/java/lang/Thread.html)  
Android 提供以下的method, 可在其它的thread 下調用 UI thread.  

```java
Activity.runOnUiThread(Runnable)
View.post(Runnable) <-- used in example code.
View.postDelayed(Runnable, long)
```  
或是使用Handler or AsyncTasks class 達到同樣的效果.

## [Handler](http://developer.android.com/reference/android/os/Handler.html)
有2個主要用途:  

1. message scheduling,  post action at specific point.
1. 將其它thread發出來的action 放入message queue中, 避免race condition.  

處理message 需要override handleMessage(), 透過sendMessage() or sendEmptyMessage() method.  
執行Runnanble則是使用post() method.  
一個Activity 只需有一個Handler instance.  

## [AsyncTask](http://developer.android.com/reference/android/os/AsyncTask.html)  
使用AsyncTask必需繼承它, 且override doInBackground() method.  
用法：  
呼叫execute() 開始執行, 之後onPerExecute()接著自動被呼叫, 通常用來 initial status of task.  
接著doInBackground() 被調用, 一般為long time computation時使用.  
call publishProgress()後會調用onProgressUpdate(), onProgressUpdate()調用於UI thread, 一般用來update progress bar, UI animate.  
publishProgress() trigger時間點是無法預期的.  
doInBackground() 結束後會trigger onPostExecute()調用於UI thread, 用來返回結果.  

__Thread, Handler 在Avtivity 結束後 thread就結束, 但AsyncTack則否.__  
Ans:  
Internally, AsyncTask uses fixed thread pool.  
(See http://developer.android.com/reference/java/util/concurrent/ThreadPoolExecutor.html)  
So, even if AsyncTask finished, thread does not die. But thread in thread pool can be killed.  

Example:  
[res/layout/demothreads.xml](/resource/2012-06-14/demothreads.xml)  
[DemoThreads.java](/resource/2012-06-14/DemoThreads.java)  
[DemoHandler.java](/resource/2012-06-14/DemoHandler.java)  
[DemoAsyncTask.java](/resource/2012-06-14/DemoAsyncTask.java)  

References:  
http://www.vogella.com/articles/AndroidPerformance/article.html  
http://android-er.blogspot.tw/2010/11/progressbar-running-in-asynctask.html  
http://stackoverflow.com/questions/10688878/android-how-to-reconnect-to-asynctask-after-ondestroy-and-relaunch-oncreate  

