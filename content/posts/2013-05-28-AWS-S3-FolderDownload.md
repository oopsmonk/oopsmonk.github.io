---
title: "AWS S3 Download Bucket Folder"
tags: ["AWS"]
date: 2013-05-28T01:53:31+08:00
---

Currently, AWS web console not provide folder downloading. We can use [s3cmd][] or [s3Browser][] for this purpose.  
[s3Browser][] is a freeware Windows client for S3 and CloudFront.  
s3cmd download Bucket folder:  

```
s3cmd sync s3://bucketname/folder /local/folder  
```

For download files using s3Browser, here is a tutorial.  
[Uploading and Downloading Files to and from Amazon S3](http://s3browser.com/how-to-upload-and-download-files.php)  


[s3cmd]: http://s3tools.org/s3cmd  
[s3Browser]: http://s3browser.com/  

