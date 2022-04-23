---
title: "uWSGI & Nginx on Ubuntu"
tags: ["Nginx", "Ubuntu"]
date: 2013-05-21T08:53:31+08:00
---

## Install uWSGI

### Configure uWSGI

```
$ sudo apt-get install python-dev python-pip  
$ sudo pip uwsgi  
################# uWSGI configuration #################  
pcre = False  
kernel = Linux  
malloc = libc  
execinfo = False  
ifaddrs = True  
ssl = True  
matheval = False  
zlib = True  
locking = pthread_mutex  
plugin_dir = .  
timer = timerfd  
yaml = True  
json = False  
filemonitor = inotify  
routing = False  
debug = False  
zeromq = False  
capabilities = False  
xml = expat  
event = epoll  
############## end of uWSGI configuration #############  
*** uWSGI is ready, launch it with /usr/local/bin/uwsgi ***  
Successfully installed uwsgi  
Cleaning up...  
$  
```

### Test uWSGI

Create test file called `hello.py`:   

```python
def application(env, start_response):  
    start_response('200 OK', [('Content-Type','text/html')])  
    return "Hello WSGI!!"  
```

Run uWSGI:  

    uwsgi --http :8000 --wsgi-file hello.py  

Open browser connect on port 8000.  

    http://localhost:8000


## Install Nginx

### Configure nginx

    $ sudo apt-get install nginx-full  

The configure file path : `/etc/nginx/sites-enabled/default`  
Add your site in nginx configure file.  

```
location /wsgi/ {
    uwsgi_pass 127.0.0.1:8001;
    include uwsgi_params;
}  
```

We use localhost port 8001 for uwsgi protocol, and 80 port for nginx.  
Run uwsgi and start nginx.  

```
$ uwsgi --socket :8001 --wsgi-file hello.py  
$ sudo service nginx start  
```

Test your web site:  

    http://your-ip/wsgi/  

or

    http://localhost/wsgi/

Ref:  
[uWSGI Tutorial - Django and nginx](https://github.com/unbit/uwsgi-docs/blob/master/tutorials/Django_and_nginx.rst)  
[WSGI using uWSGI and nginx on Ubuntu 12.04 (Precise Pangolin)](https://library.linode.com/web-servers/nginx/python-uwsgi/ubuntu-12.04-precise-pangolin)

