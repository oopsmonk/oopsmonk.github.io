---
title: "Install LaTeX on Ubuntu 14.04"
tags: ["Ubuntu"]
date: "2015-07-09 22:49:47 +0800"
---

This is a How-To article that include installation and compile LaTeX file to PDF using Texmaker, Sublime Text 3, and Vim.  

## Install TeX Live   

Install `texlive-latex-extra` instead of `texlive-latex-base`.  

    $sudo apt-get install texlive-latex-extra -y

## Initial user tree in home directory  

Before using `tlmgr` in user mode, you have to set up the user tree with the `init-usertree` action.  
`tlmgr` is TeX Live package manager, you can run `tlmgr --help` for more detail.  
[The full documentation for tlmgr](https://www.tug.org/texlive/doc/tlmgr.html)  

    $ tlmgr init-usertree
    (running on Debian, switching to user mode!)

## Install packages  

Run `tlmgr install package-name` to install a package, if an error has occurred with following.  

    $ tlmgr install bytefield
    (running on Debian, switching to user mode!)
    /usr/bin/tlmgr: Initialization failed (in setup_unix_one):
    /usr/bin/tlmgr: could not find a usable xzdec.
    /usr/bin/tlmgr: Please install xzdec and try again.
    Couldn't set up the necessary programs.
    Installation of packages is not supported.
    Please report to texlive@tug.org.
    tlmgr: exiting unsuccessfully (status 1).  

Install zxedc to solve this problem.  

    $sudo apt-get install xzdec

If you have no problem with install a package  

    $ tlmgr install bytefield
    (running on Debian, switching to user mode!)
    tlmgr: package repository http://ftp.yzu.edu.tw/CTAN/systems/texlive/tlnet
    [1/1, ??:??/??:??] install: bytefield [5k]
    tlmgr: package log updated: /home/oopsmonk/texmf/web2c/tlmgr.log
    running mktexlsr ...
    done running mktexlsr.

[Manually install packages](https://help.ubuntu.com/community/LaTeX#Installing_packages_manually)  

## Install Editor  
Here are some editors you can choose.  

* [Texmaker]  
    `$sudo apt-get install texmaker`  

* [Sublime Text 3] with [LaTeXTools]
    1. Install latexmk  
        `$ sudo apt-get install latexmk`  
    1. Install [Package Control]  
    1. Install LaTeXTools  
        Perferences -> Package Control  
    1. Build system configuration  
        Tool -> Build System -> New Build System  
        Copy [Latex.sublime-build] and save.  

* Vim with [vimtex]  
    `NeoBundle 'lervag/vimtex'`
* [Others](http://tex.stackexchange.com/questions/339/latex-editors-ides)  

[Texmaker]: http://www.xm1math.net/texmaker/  
[Sublime Text 3]: http://www.sublimetext.com/3  
[LaTeXTools]: https://github.com/SublimeText/LaTeXTools  
[vimtex]: https://github.com/lervag/vimtex  
[Package Control]: https://packagecontrol.io/installation  
[Latex.sublime-build]: https://gist.github.com/lusentis/5092219#file-latex-sublime-build  

## Hello LaTex  

{% highlight tex %}
\documentclass[12pt]{article}
\begin{document}
Hello world!
$Hello world!$ %math mode 
\end{document}
{% endhighlight %}  

Save to `hello.tex` and compile to PDF  
**[Texmaker]**  
![](/images/2015-07-09/LaTex_Texmaker.jpg)  

**[Sublime Text 3] with [LaTeXTools]**  
![](/images/2015-07-09/LaTex_SublimeText3.jpg)  

**Vim with [vimtex]**  
launch Vim via `vim --servername vimlatex`  
![](/images/2015-07-09/LaTex_vimtex.jpg)  


References:  
[在Mac系統上撰寫台大碩士論文(XeLaTex樣板)](http://www.teeboneding.com/blog/2013/06/01/write-ntu-master-thesis-with-xelatex-template-on-mac/)  
[tlmgr cannot setup TLPDB](https://help.ubuntu.com/community/LaTeX#Installing_packages_manually)  

