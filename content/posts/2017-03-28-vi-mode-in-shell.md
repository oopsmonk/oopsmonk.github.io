---
title: "在Shell使用vi-mode"
tags: ["Linux"]
date: "2017-03-28 15:36:08 +0800"
---

Vi用慣了, 那在shell也可以vi-style嗎? 答案是可以的!  

這個方法可使用在常用的shell, 例如bash, ksh, zsh, mksh.  
btw, mksh 是Android使用的shell, 但Ubuntu預設的dash 是不支援的. 

在shell中執行**set -o vi** 後按'i'進入insert mode, 'ESC'為normal mode.  
回到原本的模式則是**set -o emacs**  
如下圖:  
![](/images/2017-03-28/vi-mode-in-shell.png)  

Reference: [Using vi-mode in your shell](https://opensource.com/article/17/3/fun-vi-mode-your-shell)  

