---
title: "GitHub SVN Upstream (on Ubuntu12.04)"
tags: ["git"]
date: 2013-08-26T01:53:31+08:00
---

This is a git tutorial, create svn upstream on GitHub.  
Use [MOC](http://moc.daper.net/) project as a example.  

#Checkout SVN and push to GitHub.    
Install packages  

    $ sudo apt-get install subversion git-svn

Create git repository (it will take a long time)  

```
$ git svn clone svn://daper.net/moc/trunk --no-metadata ./moc-svn-git  
$ cat moc-svn-git/.git/config  
[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[svn-remote "svn"]
        noMetadata = 1
        url = svn://daper.net/moc/trunk
        fetch = :refs/remotes/git-svn
```

Update SVN repository  

```
$ git svn fetch
$ git cehckout remotes/git-svn -b svn-upstream  
```

Creat repository on GitHub  

```
$ cd moc-svn-git  
$ git svn show-ignore > .gitignore  
$ git add -f .gitignore  
$ git commit -m "Convert svn:ignore to .gitignore"  
$ mkdir ../moc-bare  
$ git clone --bare ../moc-bare  
$ cd ../moc-bare/
Create empty repository on GitHub. (named moc-git)  
$ git push --mirror https://github.com/'your-account'/moc-git.git  

```  

After this step, we create two folders.  
`moc-svn-git`: SVN and Git Workspace.  
`moc-bare`: Git bare for GitHub.  

#Add GitHub repository to workspace  

```
$ cd moc-svn-git  
$ git remote add github-moc https://github.com/'your-account'/moc-git.git  
$ git remote update  
$ git branch -a
* master
  svn-upstream
  remotes/git-svn
  remotes/github-moc/master  

$ git checkout remotes/github-moc/master -b github-moc
$ git branch -a
* github-moc
  master
  svn-upstream
  remotes/git-svn
  remotes/github-moc/master

```    

#Merge upstream  

```
$ cd moc-svn-git
$ git pull 
fetch remotes/git-svn
$ git svn fetch
$ git checkout remotes/git-svn -b upstream-now
$ git checkout master
$ git merge upstream-now
Fix Conflicts...
$ git add .
$ git commit
$ git push
```

Ref:  
[Converting a Subverion repository to Git](http://john.albin.net/git/convert-subversion-to-git)  
[Git SVN Tutorial](http://trac.parrot.org/parrot/wiki/git-svn-tutorial)  
