---
title: "Web dev example : JSON & jQuery Mobile & Bottle"
tags: ["Python", "jQuery"]
date: 2013-08-07T01:53:31+08:00
---

[Bottle][] is a fast, simple and lightweight WSGI micro web-framework for Python.  
[jQuery Mobile][] base on jQuery for mobile device.  
[jQuery vs. jQuery Mobile vs. jQuery UI](http://stackoverflow.com/questions/6636388/jquery-vs-jquery-mobile-vs-jquery-ui)  

## Install bottle:

```
$ sudo apt-get install python-setuptools
$ easy_install bottle
```

## Demo server deployment

### file structure:

```
BottlejQuery
├── bottleJQuery.py
└── index.html
```

### run command:

    $ ./bottleJQuery.py

### connect to server:

    http://localhost:8080/bottle  


## Building simple web server use bottle

### bottleJQuery.py

```python
#!/usr/bin/env python
from bottle import route, static_file, debug, run, get, redirect
from bottle import post, request
import os, inspect, json

#enable bottle debug
debug(True)

# WebApp route path
routePath = '/bottle'
# get directory of WebApp (bottleJQuery.py's dir)
rootPath = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))

@route(routePath)
def rootHome():
    return redirect(routePath+'/index.html')

@route(routePath + '/<filename:re:.*\.html>')
def html_file(filename):
    return static_file(filename, root=rootPath)

@get(routePath + '/jsontest')
def testJsonGET():
    print "GET Header : \n %s" % dict(request.headers) #for debug header
    return {"id":2,"name":"Jone"}

@post(routePath + '/jsontest')
def testJsonPost():
    print "POST Header : \n %s" % dict(request.headers) #for debug header
    data = request.json
    print "data : %s" % data 
    if data == None:
        return json.dumps({'Status':"Failed!"})
    else:
        return json.dumps({'Status':"Success!"})

run(host='localhost', port=8080, reloader=True)
```  

### Test GET request:  

```
$ curl -i -X GET http://localhost:8080/bottle/jsontest

HTTP/1.0 200 OK
Date: Wed, 07 Aug 2013 16:03:53 GMT
Server: WSGIServer/0.1 Python/2.7.3
Content-Length: 25
Content-Type: application/json

{"id": 2, "name": "Jone"}
```

_bottle debug message:_  

```
GET Header :
 {'Host': 'localhost:8080', 'Content-Type': 'text/plain', 'Content-Length': '', 'Accept': '*/*', 'User-Agent': 'curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3'}
localhost - - [08/Aug/2013 00:03:53] "GET /bottle/jsontest HTTP/1.1" 200 25
```

### Test POST request:

```
$ curl -X POST -H "Content-Type: application/json" \ 
-d '{"name":"OopsMonk","pwd":"abc"}' \ 
http://localhost:8080/bottle/jsontest

{"Status": "Success!"}
```  

_bottle debug message:_  

```
POST Header :
 {'Host': 'localhost:8080', 'Content-Type': 'application/json', 'Content-Length': '31', 'Accept': '*/*', 'User-Agent': 'curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3'}
data : {u'pwd': u'abc', u'name': u'OopsMonk'}
localhost - - [08/Aug/2013 00:04:56] "POST /bottle/jsontest HTTP/1.1" 200 22
```

## Building simple web page

Create 4 buttons in the index.html file:

* __[jQuery.getJSON][jjson]__ : use jQuery.getJSON API.  
    _bottle debug message:_   

```
GET Header :
 {'Content-Length': '', 'Accept-Language': 'zh-tw,zh;q=0.8,en-us;q=0.5,en;q=0.3', 'Accept-Encoding': 'gzip, deflate', 'Host': '127.0.0.1:8080', 'Accept': 'application/json, text/javascript, */*; q=0.01', 'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0', 'Connection': 'close', 'X-Requested-With': 'XMLHttpRequest', 'Referer': 'http://192.168.1.38/bottle/index.html', 'Content-Type': 'text/plain'}  
localhost - - [08/Aug/2013 00:42:08] "GET /bottle/jsontest HTTP/1.0" 200 25
```

* __[jQuery.post][jpost]__ : use jQuery.post API.   
    Unfortunately it's not work, because the content-Type is fixed 'application/x-www-form-urlencoded; charset=UTF-8', that's a problem when using bottle.request.json API to retrieve JSON from request.  
    For this perpose we have to overwirte [jQuery.post][jpost] or use [jQuery.ajax][ajax].    
    _bottle debug message:_   

```
POST Header :
 {'Content-Length': '22', 'Accept-Language': 'zh-tw,zh;q=0.8,en-us;q=0.5,en;q=0.3', 'Accept-Encoding': 'gzip, deflate', 'Host': '127.0.0.1:8080', 'Accept': 'application/json, text/javascript, */*; q=0.01', 'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0', 'Connection': 'close', 'X-Requested-With': 'XMLHttpRequest', 'Pragma': 'no-cache', 'Cache-Control': 'no-cache', 'Referer': 'http://192.168.1.38/bottle/index.html', 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'}
data : None
localhost - - [08/Aug/2013 00:55:17] "POST /bottle/jsontest HTTP/1.0" 200 21
```
 
* __[jQuery.ajax GET][ajax], [jQuery.ajax POST][ajax]__ : use jQuery.ajax API.   

_GET debug message:_   

```
GET Header :
 {'Content-Length': '', 'Accept-Language': 'zh-tw,zh;q=0.8,en-us;q=0.5,en;q=0.3', 'Accept-Encoding': 'gzip, deflate', 'Host': '127.0.0.1:8080', 'Accept': 'application/json, text/javascript, */*; q=0.01', 'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0', 'Connection': 'close', 'X-Requested-With': 'XMLHttpRequest', 'Referer': 'http://192.168.1.38/bottle/index.html', 'Content-Type': 'text/plain'}
localhost - - [08/Aug/2013 01:00:17] "GET /bottle/jsontest HTTP/1.0" 200 25
```
    
_POST debug message:_   

```
POST Header :
 {'Content-Length': '22', 'Accept-Language': 'zh-tw,zh;q=0.8,en-us;q=0.5,en;q=0.3', 'Accept-Encoding': 'gzip, deflate', 'Host': '127.0.0.1:8080', 'Accept': 'application/json, text/javascript, */*; q=0.01', 'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0', 'Connection': 'close', 'X-Requested-With': 'XMLHttpRequest', 'Pragma': 'no-cache', 'Cache-Control': 'no-cache', 'Referer': 'http://192.168.1.38/bottle/index.html', 'Content-Type': 'application/json; charset=utf-8'}
data : {u'id': 3, u'name': u'Ping'}
localhost - - [08/Aug/2013 01:01:40] "POST /bottle/jsontest HTTP/1.0" 200 22
```

[jjson]: http://api.jquery.com/jQuery.getJSON/  
[jpost]: http://api.jquery.com/jQuery.post/  
[ajax]: http://api.jquery.com/jQuery.ajax/  

###index.html  

```html
<!DOCTYPE html>
<html>
<head>
<title>Bottle & jQuery Mobile</title>

<link rel="stylesheet" href="http://code.jquery.com/mobile/1.3.2/jquery.mobile-1.3.2.min.css" />
<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
<script src="http://code.jquery.com/mobile/1.3.2/jquery.mobile-1.3.2.min.js"></script>

</head>
 
<body>
<h3>This is a example using jQuery Mobile and pyhton bottle fromwork. </h3>
<div data-role="controlgroup" data-type="horizontal">
    <a href="#" id="btnGetJSON" data-role="button">jQuery.getJSON</a>
    <a href="#" id="btnPOSTJSON" data-role="button">jQuery.post</a>
    <a href="#" id="btnAJAXGet" data-role="button">jQuery.ajax GET</a>
    <a href="#" id="btnAJAXPOST" data-role="button">jQuery.ajax POST</a>
</div>

<script>
    //button action 
    $("#btnGetJSON").click(function(){
        $.getJSON("jsontest", function(data){
            $.each(data, function(index, value){
                alert("index: " + index + " , value: "+ value);
            });
        });
    });
    
    $("#btnPOSTJSON").click(function(){
        alert("Not easy work on bottle !!!");
        /*
        It's not work, send JSON via jQuery.post().
        because the content-Type is not 'application/json',
        The content type is fixed :
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        that's a problem on bottle.request.json.
        */

        $.post(
        "jsontest", 
        JSON.stringify({"id":3, "name":"Ping"}), 
        function(ret_data, st){
            $.each(ret_data, function(index, value){
                alert("index: " + index + " , value: "+ value);
            });
            alert("Server return status : " + st); 
        },
        'json'
        );
    });
    
    $("#btnAJAXGet").click(function(){
        $.ajax
        ({
            url: 'jsontest',
            success: function(data){
                $.each(data, function(index, value){
                    alert("index: " + index + " , value: "+ value);
                });
            },
            /*
            if dataType not set, the Accept in request header is:
            'Accept': '* / *'
            dataType = json :
            'Accept': 'application/json, text/javascript, * /*; q=0.01'
            */
            dataType: 'json'
        });
    });
    
    $("#btnAJAXPOST").click(function(){
        var post_data = {"id":3, "name":"Ping"};
        $.ajax
        ({
            type: 'POST',
            url: 'jsontest',
            data:JSON.stringify(post_data),
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            success: function(data){
                $.each(data, function(index, value){
                    alert("index: " + index + " , value: "+ value);
                });
            }
        });
    });
</script>
</body>
</html>
```

[Bottle]: http://bottlepy.org/docs/dev/  
[jQuery Mobile]: http://jquerymobile.com/  

