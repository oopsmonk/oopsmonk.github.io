---
title: "Building MOC"
tags: ["Linux", "RaspberryPi"]
date: 2013-08-23T01:53:31+08:00
---

## clone MOC svn repository to github

Ref: [Converting a Subversion repository to Git](http://john.albin.net/git/convert-subversion-to-git)  

```
$ sudo apt-get install subversion git-svn  
$ mkdir moc-svn  
$ cd moc-svn  
$ svn co svn://daper.net/moc/trunk  
$ svn log -q | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > authors-transform.txt  
$ cd ..  
$ mkdir moc-git  
$ git svn clone svn://daper.net/moc/trunk --no-metadata -A ./moc-svn/authors-transform.txt ./moc-git  
$ cd moc-git  
$ git svn show-ignore > .gitignore  
$ git add -f .gitignore  
$ git commit -m "Convert svn:ignore to .gitignore."  
$ mkdir ../moc-bare  
$ git clone --bare ../moc-bare  
$ cd ../moc-bare/moc-git.git  
#Create empty repository on GitHub.  
$ git push --mirror https://github.com/oopsmonk/moc-git.git  
```

## install develop package for MOC (Ubuntu)

```
$ sudo apt-get install build-essential libdb-dev gettext  

Optional libraries:  

Sound driver:
ALSA - libasound2-dev
JACK - libjack-dev

Decoder:
FLAC - libflac-dev
MP3 - libmad0-dev, libid3tag0-dev
sndfile, vorbis - libsndfile1-dev

Network: libcurl4-gnutls-dev
RCC: librcc-dev
Resample : libsamplerate0-dev
MIME magic: libmagic-dev
After release 2.5 MOC will require libpopt.

$ sudo apt-get install libasound2-dev libjack-dev \ 
 libflac-dev libmad0-dev libid3tag0-dev libsndfile1-dev 
$ sudo apt-get install libcurl4-gnutls-dev librcc-dev \
 libsamplerate0-dev libmagic-dev libpopt

-----------------------------------------------------------------------
MOC will be compiled with:

Decoder plugins:   flac mp3 sndfile vorbis
Sound Drivers:     OSS ALSA JACK
DEBUG:             yes
RCC:               yes
Network streams:   yes
Resampling:        yes
MIME magic:        yes
-----------------------------------------------------------------------
```

## install develop package for MOC (Raspberry Pi)  

```
$ sudo apt-get install build-essential autoconf automake libtool
$ sudo apt-get install libncurses5-dev libdb-dev gettext
$ sudo apt-get install libasound2-dev libjack-dev libflac-dev \ 
 libmad0-dev libid3tag0-dev libsndfile1-dev 
$ sudo apt-get install libcurl4-gnutls-dev librcc-dev libsamplerate0-dev libmagic-dev

Build libpopt
$ wget http://rpm5.org/files/popt/popt-1.16.tar.gz
$ tar xf popt-1.16.tar.gz  
$ cd popt-1.16
$ autoreconf  
$ ./configure --prefix=/usr/lib --enable-shared
$ make 
$ sudo make install  

```

## check out from repository  

    $ svn co svn://daper.net/moc/trunk  moc-svn

## Build step  

    $ cd moc-svn  
    $ autoreconf 
    $ ./configure --enable-debug --perfix=/path/to/dev  
    $ make && make install  

## Debugging  

    $cd /path/to/dev
    $ ./bin/mocp --debug  

