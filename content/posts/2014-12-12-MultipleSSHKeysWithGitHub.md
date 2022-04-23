---
title: "Using Git With Multiple SSH Keys and Accounts"
tags: ["git", "ssh"]
date: 2014-12-12T01:53:31+08:00
---

##  [Generating SSH keys for GitHub](https://help.github.com/articles/generating-ssh-keys/)  

Here are github account and work account. 

* GitHub:  
    SSH Key: github_id_rsa  
    Account: oopsmonk  

* Work:  
    SSH Key: work_id_rsa  
    Account: SamChen  


##  Add SSH config File  

Modify **`~/.ssh/config`** 

```
# Default github
Host github.com
    HostName github.com
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/github_id_rsa

# Work git server
Host work.gitserver.com
    HostName work.gitserver.com
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/work_id_rsa
```

##  Git Repository Configuation  

* GitHub Project: 

```
$ git clone https://github.com/abc/projectA.git  
$ cd projectA
#github account
$ git config user.name "oopsmonk"
$ git config user.email "oopsmonk@example.com.tw"
```

* Working Project: 

```
$ git clone https://work.com.tw/repo/projectW.git  
$ cd projectW
#working account
$ git config user.name "SamChen"
$ git config user.email "SamChen@example.com.tw"
```

**Now you can deal with git repositories using different accounts.** 

##  (Additional) Using [ssh-agent] to access GitHub without password     

Check key list 

```
# No ssh-agent running 
$ ssh-add -l
Could not open a connection to your authentication agent.
$  
```

Enable ssh-agent (Ubuntu12.04): 

```
#enable ssh-agent
$ eval `ssh-agent -s`

#add keys to agent
$ cd ~/.ssh
$ ssh-add work_id_rsa github_id_rsa
Identity added: work_id_rsa (work_id_rsa)
Identity added: github_id_rsa (github_id_rsa)

#list added keys
$ ssh-add -L

#delete keys in agent  
$ ssh-add -D
```

**Now you can commit modifications to git repository without password.**  
References:  
[Understanding ssh-agent and ssh-add](http://blog.joncairns.com/2013/12/understanding-ssh-agent-and-ssh-add/)  
[How can I run ssh-add automatically, without password prompt?](http://unix.stackexchange.com/questions/90853/how-can-i-run-ssh-add-automatically-without-password-prompt)  

[ssh-agent]: http://en.wikipedia.org/wiki/Ssh-agent 

