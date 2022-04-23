---
title: "Enable gzip compression in Nginx"
tags: ["Nginx"]
date: "2017-05-19 15:21:10 +0800"
---

How to enable and test gzip in Nginx.  

Official document: [ngx_http_gzip_module](http://nginx.org/en/docs/http/ngx_http_gzip_module.html)  

## Enable gzip  

I use [Raspberry Pi System Monitor](https://github.com/oopsmonk/rpi-monitor) to test gzip module.   
Modify `/etc/nginx/sites-available/default` to enable gzip.  
In this case I only change the RpiMonitor website in the server, you can apply it to global by `/etc/nginx/nginx.conf`   

```
location /rpi {
	proxy_pass http://127.0.0.1:9999/RpiMonitor;
}
```

Change to  


```
location /rpi {
	proxy_pass http://127.0.0.1:9999/RpiMonitor;
	gzip on;
	gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
	gzip_proxied any;
}
```

Then reload nginx.conf via `sudo nginx -s reload`  

## Test and Result 

Before gzip enable:  

```
$ curl -I -H "Accept-Encoding: gzip" http://xxx.xxx.com.tw/rpi/assets/javascriptrrd.wlibs.min.js
HTTP/1.1 200 OK
Server: nginx/1.6.2
Date: Fri, 19 May 2017 07:13:57 GMT
Content-Type: application/javascript
Content-Length: 212364
Connection: keep-alive
Last-Modified: Tue, 30 Dec 2014 06:47:20 GMT
Accept-Ranges: bytes
```

After gzip enable:  

```
$ curl -I -H "Accept-Encoding: gzip" http://xxx.xxx.com.tw/rpi/assets/javascriptrrd.wlibs.min.js
HTTP/1.1 200 OK
Server: nginx/1.6.2
Date: Fri, 19 May 2017 07:14:37 GMT
Content-Type: application/javascript
Connection: keep-alive
Last-Modified: Tue, 30 Dec 2014 06:47:20 GMT
Content-Encoding: gzip
```

[WebPage Speed Analysis](https://my.we-amp.com/pagespeed/test/) result:  

![](/images/2017-05-19/nginx_gzip.png)  

Additional resource - [How to: Brotli compression with Nginx](https://www.enovate.co.uk/blog/2017/02/28/how-to-brotli-compression-with-nginx)  
