---
title: "Web Micro Framework Battle"
tags: ["Python", "WebDev"]
date: 2013-05-27T00:53:31+08:00
---

## WSGI Micro Framworks

這陣子一直在找適合的Micro Framwork玩第一次的Web Application.  
最後選擇用[Bottle][], 原因是:  

* Single file module, no dependencies with other library.  
* Document  

但是好不好用又是另一回事, 用了就知道..XD  

以下是由[WSGI.org][]列出的Micro [Framwork][]:  

* [bobo][]  
    Bobo is a light-weight framework. Its goal is to be easy to use and remember.

* [Bottle][]  
    Bottle is a fast and simple micro-framework for small web-applications. It offers request dispatching (Routes) with url parameter support, Templates, key/value Databases, a build-in HTTP Server and adapters for many third party WSGI/HTTP-server and template engines. All in a single file and with no dependencies other than the Python Standard Library.

* [Flask][]  
    Flask is a microframework for Python based on Werkzeug, Jinja 2 and good intentions.
    It inherits its high WSGI usage and compliance from Werkzeug.

* [Pyramid][]  
    Merger of the Pylons and repoze.bfg projects, Pyramid is a minimalist web framework aiming at composability and making developers paying only for what they use.
    
* [web.py][]  
    Makes web apps. A small RESTful library.  

## Micro Framworks Battle

Rank | Framwork | Point 
----- | ----- | ----- 
1 |  **Bottle** | 7 
2 |  pesto  |  6 
3 |  itty   |  4 
4 |  **flask**, cgi+wsgiref | 3 
5 |  werkzeug    | 2 
6 |  **web.py**  | 1 
7 |  cherrypy    | 0 
8 |  **bobo**    | -7 
9 |  aspen.io    | -5 

Reference :   
[Web Micro Framework Battle 1](http://www.slideshare.net/r1chardj0n3s/web-microframework-battle)  
[Web Micro Framework Battle 2](https://pydanny-event-notes.readthedocs.org/en/latest/PyconAU2011/web_micro_framework_battle.html)  

[WSGI.org]: http://wsgi.readthedocs.org/en/latest/index.html  
[Framwork]: http://wsgi.readthedocs.org/en/latest/frameworks.html  
[bobo]: http://bobo.digicool.com/  
[Bottle]: http://bottle.paws.de/  
[Flask]: http://flask.pocoo.org/  
[Pyramid]: https://www.pylonsproject.org/projects/pyramid/about  
[web.py]: http://webpy.org/  
