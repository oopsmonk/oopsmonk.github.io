---
title: "The Littlest JupyterHub - TLJH"
date: 2024-10-20T10:44:48+08:00
tags: ["Python"]
cover:
    image: "/images/2024-10-20/tljh-logo.png" # image path/url
---

The [Jupyter](https://jupyter.org/) project is a free software, open standards, and web services for interactive computing across all programming languages.
It provides:

- [Jupyter Notebook](https://jupyter-notebook.readthedocs.io/en/latest/): the classic notebook interface
- [JupyterLab](https://jupyterlab.readthedocs.io/en/latest/): the next-generation notebook interface
- [Voilà](https://github.com/voila-dashboards/voila): share your results with a secure, stand-alone web applications.
- [JupyterHub](https://jupyterhub.readthedocs.io/en/stable/): the multi-user server for Jupyter Notebook and JupyterLab
- [The littlest JupyterHub(TLJH)](https://tljh.jupyter.org/en/latest/index.html): the simplest JupyterHub for a small group running on a single machine.
- [Zero to JupyterHub with Kubernetes(Z2JH)](https://z2jh.jupyter.org/en/latest/): Provides user-friendly steps to deploy JupyterHub on a cloud using [Kubernetes](https://kubernetes.io/) and [Helm](https://helm.sh/).

I was confused by the JupyterHub and TLJH since they can run on a single server with the multiple users feature but after reading [The Littlest Jupyterhub by Yuvi](https://words.yuvi.in/post/the-littlest-jupyterhub/)

> The Littlest JupyterHub serves [the long tail](https://en.wikipedia.org/wiki/Long_tail) of potential JupyterHub users who have the following needs only.
> 
> 1. Support a very small number of students (around 20–30, maybe 50)
> 2. Run on only one node, either [a cheap VPS](http://digitalocean.com/) or a VM on their [favorite cloud provider](https://cloud.google.com/)
> 3. Provide the same environment for all students
> 4. Allow the instructor / admin to easily modify the environment for students with no specialized knowledge
> 5. Be extremely low maintenance once set up & easily fixable when it breaks
> 6. Allow easy upgrades
> 7. Enforce memory / CPU limits for students
>  

TLJH provides a system command called `tljh-config` to deal with `jupyterhub_config.py` which is not easy to use by normal users.
For more details, see: [TLJH: What does the installer do?](https://tljh.jupyter.org/en/latest/topic/installer-actions.html)

Reference:
- [JupyterHub Technical Overview](https://jupyterhub.readthedocs.io/en/stable/reference/technical-overview.html)
- [TLJH doc](https://tljh.jupyter.org/en/latest/#)
	- [When to use The Littlest JupyterHub](https://tljh.jupyter.org/en/latest/topic/whentouse.html)

## Install TLJH

Installation is very easy, just need to run:

```bash
sudo apt install python3 python3-dev git curl
# change the USERNAME and USERPWD
curl -L https://tljh.jupyter.org/bootstrap.py  | sudo python3 - --admin ${USERNAME}:${USERPWD}
```

then you can access http://localhost/ via your browser

Install python packages in the user environment

```bash
sudo -E pip install <something>
```

Customize configuration

```bash
# change default 8000 port to 9000
sudo tljh-config set http.port 9000
sudo tljh-config reload proxy
# Enable native authenticator, let users sign up
sudo tljh-config set auth.type nativeauthenticator.NativeAuthenticator
sudo tljh-config set auth.NativeAuthenticator.open_signup true
sudo tljh-config reload
# Check configuration
sudo tljh-config show
# Output
# Configure file location: `/opt/tljh/config/config.yaml`
users:
  admin:
  - oopsmonk
http:
  port: 9000
auth:
  type: nativeauthenticator.NativeAuthenticator
  NativeAuthenticator:
    open_signup: true
```

Reference: 
- [Installing on your own server](https://tljh.jupyter.org/en/latest/install/custom-server.html)
- [Configuring TLJH with `tljh-config`](https://tljh.jupyter.org/en/latest/topic/tljh-config.html)
- [Let users sign up with a username and password](https://tljh.jupyter.org/en/latest/howto/auth/nativeauth.html)

## Create an user

http://localhost:9000/hub/signup

![](/images/2024-10-20/jupyterhub-sign-up.png)

## Remove an user

1. delete the user from Hub GUI: http://localhost/hub/admin#/
2. delete the user from system
```bash
# stop the services
sudo systemctl stop jupyter-<username>
# disable the services
sudo systemctl disable jupyter-<username>
# reset the state of all units
sudo systemctl daemon-reload
sudo systemctl reset-failed
# remove user from system
sudo userdel -r jupyter-<username>
```

## Uninstall TLJH

Uninstall steps are depended on the admin's specific modifications, the way to remove it is undoing steps in [What does the installer do?](https://tljh.jupyter.org/en/latest/topic/installer-actions.html#what-does-the-installer-do) properly.

Here is a simple example:

```bash
# stop the services
sudo systemctl stop jupyterhub.service
sudo systemctl stop traefik.service
sudo systemctl stop jupyter-<username>

# disable the services
sudo systemctl disable jupyterhub.service
sudo systemctl disable traefik.service
# run this command for all the Jupyter users
sudo systemctl disable jupyter-<username>

# remove the systemd unit
sudo rm /etc/systemd/system/jupyterhub.service
sudo rm /etc/systemd/system/traefik.service

# reset the state of all units
sudo systemctl daemon-reload
sudo systemctl reset-failed

# unlink configuration command
sudo unlink /usr/bin/tljh-config

# remove tljh data
# $ ls /opt/tljh/
#   config  hub  installer.log  state  user
sudo rm -rf /opt/tljh

# remove all jupyter users in the system
sudo userdel jupyter-<username>

# remove the user groups
sudo delgroup jupyterhub-users
sudo delgroup jupyterhub-admins
# remove jupyterhub-admins from the sudoers group
sudo rm /etc/sudoers.d/jupyterhub-admins
```

