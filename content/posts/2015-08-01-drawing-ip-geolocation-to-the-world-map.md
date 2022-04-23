---
title: "Drawing IP Geolocation on World Map"
tags: ["Nginx", "Ubuntu"]
date: "2015-08-01 20:28:47 +0800"
cover:
  image: "/images/2015-08-01/mapquest-ipmap.jpg"
---

I found some mystery visitors in nginx's access log. I tried to figure out the location of those visitors and what they did.   

## IP collection

First copy nginx's access log to a folder and save all logs into a single file.

    $ mkdir mysteryIPs && cd $_
    $ sudo cp /var/log/nginx/access.log.* .
    $ zcat access.log.* > access-gz.log
    $ cat access.log.1 >> access-gz.log
    $ cat access.log >> access-gz.log

Remove LAN accesses from log file, for example my subnet IP rang is 192.168.x.x  

    $ sed '/^192.168/d' ./access-gz.log > removeLAN.log

Getting unique IP list.  

    $ cat removeLAN.log | awk '{print $1}' | sort -u > uniqueIP 

## Drawing visitors on the world map

We have to know where are visitors from and mark them on map.  
I found an example of plotting GeoIP on map, [PyGeoIpMap](https://github.com/pierrrrrrre/PyGeoIpMap). But it took too long on geolocation when I was trying to use it. So I modified it, I use [Geocoder](https://github.com/DenisCarriere/geocoder) instead of the original one.  

Install dependencies for our python script  

    $ sudo apt-get install python-numpy python-matplotlib python-mpltoolkits.basemap
    $ sudo pip install geocoder  

Here is the script [Ggeoipmap.py](/resource/2015-08-01/Ggeoipmap.py), please right click to save.  

    $ chmod +x Ggeoipmap.py 
    $ ./Ggeoipmap.py -i uniqueIP -o ipmap.jpg  
    [maxmind] 101.xxx.xx9 (1/332) country: Thailand
    [maxmind] 104.xxx.xx0 (2/332) country: Canada
    [maxmind] 104.xxx.xx(3/332) country: United States
    [maxmind] 104.xxx.xx (4/332) country: United States
    [maxmind] 104.xxx.xx (5/332) country: United States
    [maxmind] 104.xxx.xx1 (6/332) country: United States
    [maxmind] 108.xxx.xx (7/332) country: United States
    [maxmind] 110.xxx.xx0 (8/332) country: Thailand
    [maxmind] 111.xxx.xx (9/332) country: Taiwan
    [maxmind] 112.xxx.xx9 (10/332) country: Republic of Korea
    [maxmind] 112.xxx.xx5 (11/332) country: Republic of Korea
    [maxmind] 113.xxx.xx3 (12/332) country: China
    ...
    [mapquest] 94.xxx.xx.195 (331/332) country: TH
    [mapquest] 94.xx.xx.102 (332/332) country: PL
    Generating map and saving it to mapquest-ipmap.jpg

You can find graphics prefixed with geocoding service providers.  

    $ find . -name '*ipmap.jpg'
    ./yahoo-ipmap.jpg
    ./mapquest-ipmap.jpg
    ./tomtom-ipmap.jpg
    ./maxmind-ipmap.jpg
    ./osm-ipmap.jpg
    ./google-ipmap.jpg

Yahoo  
![](/images/2015-08-01/yahoo-ipmap.jpg)

MapQuest  
![](/images/2015-08-01/mapquest-ipmap.jpg)

TOMTOM  
![](/images/2015-08-01/tomtom-ipmap.jpg)

MaxMind  
![](/images/2015-08-01/maxmind-ipmap.jpg)

OSM  
![](/images/2015-08-01/osm-ipmap.jpg)

Google  
![](/images/2015-08-01/google-ipmap.jpg)

## Other information from access log

We can find more information from those logs, as follows.

**Access counts per visitor**   
Display access counts with each visitor.  

```bash
$ cat removeLAN.log | awk '{print $1}' | sort | uniq -c | sed 's/^[ \t]*//' | sort -k1 -n 
1 11x.xxx.xxx.187
1 1.x.xxx.xxx.0
1 11x.xxx.xxx.1
1 11x.xxx.xxx.225
1 11x.xxx.xxx
1 12x.xxx.xxx.111
13 1x.xxx.xxx.54
13 1x.xxx.xxx.12
13 2x.xxx.xxx.250
14 9x.xxx.xxx.69
15 1x.xxx.xxx.166
15 1x.xxx.xxx.167
15 1x.xxx.xxx.135
15 6x.xxx.xxx.8
17 2x.xxx.xxx.51
45 2x.xxx.xxx.56
52 2x.xxx.xxx.89
56 1x.xxx.xxx.5
62 1x.xxx.xxx.0
84 8x.xxx.xxx.6
85 1x.xxx.xxx.211
90 1x.xxx.xxx.3
100 1xx.xxx.x49
100 6xx.xxx.x6
101 1xx.xxx.x.1
101 8xx.xxx.x146
159 1xx.xxx.x28
$
```

**Requests**   
Display request and counts with visitors. 

```bash
$ cat removeLAN.log | awk 'split($0, a, "\"") {$6 = "\""a[2]"\""} {print $1 " " $6}' | sort | uniq -c | sort -k 1 -n  
     23 1xx.xxx.xxx.231 "GET / HTTP/1.1"
     23 5x.xxx.xxx.182 "GET http://www.baidu.com/ HTTP/1.1"
     26 2xx.xxx.xxx.130 "\x03\x00\x00)$\xE0\x00\x00\x00\x00\x00Cookie: mstshash=NCRACK_USER"
     27 2xx.xxx.xxx.6 "GET http://www.baidu.com/ HTTP/1.1"
     30 5xx.xxx.xxx.169 "GET http://www.baidu.com/ HTTP/1.1"
     32 5xx.xxx.xxx.136 "GET http://www.baidu.com/ HTTP/1.1"
     34 1xx.xxx.xxx.0 "GET / HTTP/1.1"
     34 2xx.xxx.xxx.55 "GET http://www.baidu.com/ HTTP/1.1"
     34 2xx.xxx.xxx.90 "GET http://www.baidu.com/ HTTP/1.1"
     38 2xx.xxx.xxx.54 "GET http://www.baidu.com/ HTTP/1.1"
     42 2xx.xxx.xxx.52 "GET http://www.baidu.com/ HTTP/1.1"
     42 2xx.xxx.xxx.53 "GET http://www.baidu.com/ HTTP/1.1"
     44 2xx.xxx.xxx.58 "GET http://www.baidu.com/ HTTP/1.1"
     45 2xx.xxx.xxx.56 "GET http://www.baidu.com/ HTTP/1.1"
     52 2xx.xxx.xxx.89 "GET http://www.baidu.com/ HTTP/1.1"
     54 2xx.xxx.xxx.50 "GET http://www.baidu.com/ HTTP/1.1"
     54 6x.xxx.xxx.229 "-"
```

**Counting Requests**  
Display what kind of request from visitor.  

```bash
$ cat removeLAN.log | awk 'split($0, a, "\"") {$6 = "\""a[2]"\""} {print $6}' | sort | uniq -c | sort -n  
      2 "GET /phpMyAdmin-2.2.3/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.2.6/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.3.0/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.3.1/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.3.2/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.3.3/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.3.4/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.3.5/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.3.6/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.3.7/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.3.8/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.3.9/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.4.0/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.4.1/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.4.2/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.4.3/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.4.4/ HTTP/1.1"
      2 "GET /phpMyAdmin-2.4.5/ HTTP/1.1"
     15 "GET //cpphpmyadmin/scripts/setup.php HTTP/1.1"
     15 "GET //forum/phpmyadmin/scripts/setup.php HTTP/1.1"
     15 "GET //_phpmyadmin/scripts/setup.php HTTP/1.1"
     15 "GET //websql/scripts/setup.php HTTP/1.1"
     16 "GET //php-my-admin/scripts/setup.php HTTP/1.1"
     16 "GET //php/phpmyadmin/scripts/setup.php HTTP/1.1"
     16 "GET //typo3/phpmyadmin/scripts/setup.php HTTP/1.1"
     16 "GET //web/scripts/setup.php HTTP/1.1"
     17 "GET //admin/phpmyadmin/scripts/setup.php HTTP/1.1"
     17 "GET //admin/pma/scripts/setup.php HTTP/1.1"
     17 "GET //admin/scripts/setup.php HTTP/1.1"
     17 "GET //db/scripts/setup.php HTTP/1.1"
     17 "GET //phpadmin/scripts/setup.php HTTP/1.1"
     17 "GET //scripts/setup.php HTTP/1.1"
     17 "GET //web/phpMyAdmin/scripts/setup.php HTTP/1.1"
     17 "GET //xampp/phpmyadmin/scripts/setup.php HTTP/1.1"
     18 "GET //dbadmin/scripts/setup.php HTTP/1.1"
     18 "GET //mysql/scripts/setup.php HTTP/1.1"
     18 "GET //phpMyAdmin-2/scripts/setup.php HTTP/1.1"
     19 "GET /myadmin/scripts/setup.php HTTP/1.1"
     19 "GET /pma/scripts/setup.php HTTP/1.1"
     20 "GET //mysqladmin/scripts/setup.php HTTP/1.1"
     20 "GET /phpMyAdmin/scripts/setup.php HTTP/1.1"
    591 "GET http://www.baidu.com/ HTTP/1.1"
    692 "GET / HTTP/1.1"
```
 
**Response Codes**  
Display count of response codes.  

```bash
$ cat removeLAN.log | cut -d '"' -f3 | cut -d ' ' -f2 | sort | uniq -c | sort -rn
   4567 200
   1970 404
    255 400
    244 304
     22 206
     18 302
     12 408
     11 502
     11 401
      9 405
      7 409
      2 499
      1 500
$ 
```

**Weird requests**  

```
"MZ\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x18\x00\x00\x00\x00\x00\x00\x00G\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00"
"MZ\x02\x01\x90\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00~\x00\x00\x00\x00\x00\x00\x00\x01\x02\x01\x00\xFF\x01\x00\x00\x01\x00\x00\x00\x00microsof-c5a626\x00Windows XP Professional Service Pack 3 Version 5.1.2600\x00Intel(R) Core(TM) i5-4200U CPU @ 1.60GHz\x00"
"POST /cgi-bin/php5?%2D%64+%61%6C%6C%6F%77%5F%75%72%6C%5F%69%6E%63%6C%75%64%65%3D%6F%6E+%2D%64+%73%61%66%65%5F%6D%6F%64%65%3D%6F%66%66+%2D%64+%73%75%68%6F%73%69%6E%2E%73%69%6D%75%6C%61%74%69%6F%6E%3D%6F%6E+%2D%64+%64%69%73%61%62%6C%65%5F%66%75%6E%63%74%69%6F%6E%73%3D%22%22+%2D%64+%6F%70%65%6E%5F%62%61%73%65%64%69%72%3D%6E%6F%6E%65+%2D%64+%61%75%74%6F%5F%70%72%65%70%65%6E%64%5F%66%69%6C%65%3D%70%68%70%3A%2F%2F%69%6E%70%75%74+%2D%64+%63%67%69%2E%66%6F%72%63%65%5F%72%65%64%69%72%65%63%74%3D%30+%2D%64+%63%67%69%2E%72%65%64%69%72%65%63%74%5F%73%74%61%74%75%73%5F%65%6E%76%3D%30+%2D%6E HTTP/1.1"
"POST /cgi-bin/php-cgi?%2D%64+%61%6C%6C%6F%77%5F%75%72%6C%5F%69%6E%63%6C%75%64%65%3D%6F%6E+%2D%64+%73%61%66%65%5F%6D%6F%64%65%3D%6F%66%66+%2D%64+%73%75%68%6F%73%69%6E%2E%73%69%6D%75%6C%61%74%69%6F%6E%3D%6F%6E+%2D%64+%64%69%73%61%62%6C%65%5F%66%75%6E%63%74%69%6F%6E%73%3D%22%22+%2D%64+%6F%70%65%6E%5F%62%61%73%65%64%69%72%3D%6E%6F%6E%65+%2D%64+%61%75%74%6F%5F%70%72%65%70%65%6E%64%5F%66%69%6C%65%3D%70%68%70%3A%2F%2F%69%6E%70%75%74+%2D%64+%63%67%69%2E%66%6F%72%63%65%5F%72%65%64%69%72%65%63%74%3D%30+%2D%64+%63%67%69%2E%72%65%64%69%72%65%63%74%5F%73%74%61%74%75%73%5F%65%6E%76%3D%30+%2D%6E HTTP/1.1"
"POST /cgi-bin/php.cgi?%2D%64+%61%6C%6C%6F%77%5F%75%72%6C%5F%69%6E%63%6C%75%64%65%3D%6F%6E+%2D%64+%73%61%66%65%5F%6D%6F%64%65%3D%6F%66%66+%2D%64+%73%75%68%6F%73%69%6E%2E%73%69%6D%75%6C%61%74%69%6F%6E%3D%6F%6E+%2D%64+%64%69%73%61%62%6C%65%5F%66%75%6E%63%74%69%6F%6E%73%3D%22%22+%2D%64+%6F%70%65%6E%5F%62%61%73%65%64%69%72%3D%6E%6F%6E%65+%2D%64+%61%75%74%6F%5F%70%72%65%70%65%6E%64%5F%66%69%6C%65%3D%70%68%70%3A%2F%2F%69%6E%70%75%74+%2D%64+%63%67%69%2E%66%6F%72%63%65%5F%72%65%64%69%72%65%63%74%3D%30+%2D%64+%63%67%69%2E%72%65%64%69%72%65%63%74%5F%73%74%61%74%75%73%5F%65%6E%76%3D%30+%2D%6E HTTP/1.1"
"POST /cgi-bin/wlogin.cgi HTTP/1.1"
"POST / HTTP/1.1"
"POST /login.action HTTP/1.1"
"POST /login.do HTTP/1.1"
"POST /OvCgi/getnnmdata.exe HTTP/1.1"
"POST /user.action HTTP/1.1"
"\x03\x00\x00)$\xE0\x00\x00\x00\x00\x00Cookie: mstshash=NCRACK_USER"
"\x04\x01\x1F\x00\x00\x00\x00\x00\x00"
"\x05\x01\x00"
```

