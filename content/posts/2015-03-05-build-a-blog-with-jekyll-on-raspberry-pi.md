---
title: "Build A Blog with Jekyll and GitHub on Raspberry Pi"
tags: ["Ubuntu", "RaspberryPi", "WebDev"]
date: "2015-03-05 23:30:11 +0800"
---

I recently switched my blog from [Google Blogger](http://oopsmonk.blogspot.tw/) to GitHub Pages, here is how I built my blog. I'll go through the following:  

* Install Jekyll on Raspberry Pi  
* Setup Jekyll Theme  
* Post a new article  
* Images minimization
* Commit to GitHub  

Using Jekyll and Minimal Mistake build a blog and host on GitHub and Raspberry Pi(or Ubuntu).  
Requirements: 

* Raspberry Pi(or Ubuntu)  
* GitHub account  
* Jekyll 2.2+  
* Minimal Mistake 
* Grunt

If you have no idea with these things, here are useful resources:  
[How Jekyll Works](http://jekyllbootstrap.com/lessons/jekyll-introduction.html)  
[Jekyll Installation](http://jekyllrb.com/docs/installation/)  
[Minimal Mistake Theme Setup](http://mmistakes.github.io/minimal-mistakes/theme-setup/)  
[GitHub Pages](https://pages.github.com/)  
[Getting started - Grunt](http://gruntjs.com/getting-started)  

## Jekyll Installation  

Because some packages are out of date in Raspberry Pi's repository, we are going to install packages manually.  
Jekyll requirements:  

* Ruby  
* RubyGems (default in Ruby1.9 above)  
* NodeJS or another JavaScript runtime (it's for CoffeeScript support)  

Build packages using Raspberry Pi will spend a lot of time. Ruby took me about 80 minutes and NodeJS around 4 hours. So have a walk after `make` :-).  
__Install Ruby2.2__   

```
$ wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.0.tar.gz
$ tar xf ruby-2.2.0.tar.gz
$ cd ruby-2.2.0
$ ./configure 
$ make
$ sudo make install
```  

__Install NodeJS__  

```
$ wget http://nodejs.org/dist/v0.10.36/node-v0.10.36.tar.gz
$ tar xf node-v0.10.36.tar.gz
$ cd node-v0.10.36
$ ./configure 
$ make
$ sudo make install
```

## Jekyll Theme Setup  

Install Jekyll Theme is pretty easy, download and do some modify in __\_config.yml__.  
I use the [Minimal Mistake](https://mmistakes.github.io/minimal-mistakes/) for example, you can find the others on [Jekyll Themes](http://jekyllthemes.org/).  
Steps: 

* Download Minimal Mistakes
* Unzip
* Install all dependencies via `bundle install`

```
$ wget https://github.com/mmistakes/minimal-mistakes/archive/master.zip
$ unsip master.zip
$ cd minimal-mistakes-master
$ sudo gem install bundler
$ bundle install
$ jekyll s
```

Now you can connect to http://127.0.0.1:4000 see the prototype.  

If you don't know how to modify \_config.yml, Please refer to [Site Setup](https://mmistakes.github.io/minimal-mistakes/theme-setup/#site-setup) or my [\_config.yml](https://github.com/oopsmonk/oopsmonk.github.io/blob/master/_config.yml).  
I got a problem when I was running `jekyll s`, to solve this problem remove the `Gemfile.lock` file and it's work properly.  
 
```
$ jekyll s                                                             
WARN: Unresolved specs during Gem::Specification.reset:
      pygments.rb (~> 0.6.0)
      redcarpet (~> 3.1)
      jekyll-watch (~> 1.1)
      classifier-reborn (~> 2.0)
WARN: Clearing out unresolved specs.
Please report a bug if this causes problems.
/usr/local/lib/ruby/gems/2.2.0/gems/jekyll-2.5.3/bin/jekyll:21:in `block in <top (required)>': cannot load such file -- jekyll
/version (LoadError)
        from /usr/local/lib/ruby/gems/2.2.0/gems/mercenary-0.3.5/lib/mercenary.rb:18:in `program'
        from /usr/local/lib/ruby/gems/2.2.0/gems/jekyll-2.5.3/bin/jekyll:20:in `<top (required)>'
        from /usr/local/bin/jekyll:23:in `load'
        from /usr/local/bin/jekyll:23:in `<main>'
$ rm Gemfile.lock 
```

## Post a new article  

The simplest way to post an article is create a file with date prefix in **\_post** folder and fill in header, but ~~as a lazy person like me~~ Minimal Mistake provide `octopress` command to create a new post. Personally, I use [vim-jekyll](https://github.com/parkr/vim-jekyll) instead.  
__[Use octopress](https://mmistakes.github.io/minimal-mistakes/theme-setup/#new-post)__  
__[Use vim-jekyll](https://github.com/parkr/vim-jekyll)__  
After vim-jekyll is installed, add configuration in `.vimrc` is shown below:  

{% highlight vim %}
let g:jekyll_post_dirs = ['_posts']
let g:jekyll_post_extension = '.md'
let g:jekyll_post_template = [
\ '---',
\ 'layout: post',
\ 'title: "JEKYLL_TITLE"',
\ 'modified: ',
\ 'categories: ',
\ 'comments: true',
\ 'excerpt:',
\ 'tags: []',
\ 'image:',
\ '  feature:',
\ 'date: "JEKYLL_DATE"',
\ '---',
\ '']
{% endhighlight %}    

## Images minimization  

Gruent is a JavaScript Task Runner performs repetitive tasks. Minimal Mistakes have a Gruntfile already, we can use it for minimizing images and JavaScript, but we have to install Gruent first and install dependencies via `npm install`. By default it minimizes all scripts into `scripts.min.js` and optimize .jpg, .png, and .svg files in the **images/** folder.  
Alternatively, you can use `grunt imagemin` to minimize images only.

```
$ cd minimal-mistakes-master 
$ sudo npm install -g grunt-cli
$ sudo npm install
$ grunt 
```

## Commit to GitHub  

You can host your blog by your own or use GitHub Pages, how to work with GitHub Pages:  

* Create a repository called __account.github.io__ (mine is __[oopsmonk.github.io](https://github.com/oopsmonk/oopsmonk.github.io)__)  
* Clone repository to your blog folder  
* Commit to GitHub

Yes, it's extremely convenient and easy, thanks GitHub.  
Here is what I did:  

```
$ cd minimal-mistakes-master
$ git clone https://github.com/oopsmonk/oopsmonk.github.io.git .
$ git add .
$ git commit
$ git push
```

Then you can see your blog at https://account.github.io

## Conclusion  

Create a Jekyll blog doesn't like Google Blogger, even use themes to build a blog, it's not ready to go after unboxing.You have to do some modifications, understanding HTML, CSS, and Jekyll is necessary. Here are Pros/Corns for using GitHub Pages with Jekyll.  

#### Pros  

* Flexible customization  
* Keep contents in local or on Internet  
* Offline writing and preview  
* Write in terminal  


#### Corn  

* Learning curve  

