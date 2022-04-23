---
title: "Redirect and Save iptables on Ubuntu 12.04"
tags: ["Ubuntu", "Linux"]
date: 2013-07-05T01:53:31+08:00
---

Redirect port 8080 to 80  

    sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080  

Check iptables setting  

    sudo iptables -t nat -L  

Save configure to `iptables.rules`  

    sudo iptables-save > /etc/iptables.rules  

## Save Solution #1  

Configre `/etc/network/interfaces`  

```bash
iface eth0 inet dhcp  
    pre-up iptables-restore < /etc/iptables.rules  
```

## Save Solution #2

Configure `/etc/network/if-pre-up.d/iptablesload`  

```bash
#!/bin/sh
iptables-restore < /etc/iptables.rules
exit 0
```  

Configure `/etc/network/if-post-down.d/iptablessave`  

```bash
#!/bin/sh
iptables-save -c > /etc/iptables.rules
if [ -f /etc/iptables.downrules ]; then
    iptables-restore < /etc/iptables.downrules
fi
exit 0
``` 

Change permissions  

    sudo chmod +x /etc/network/if-post-down.d/iptablessave  
    sudo chmod +x /etc/network/if-pre-up.d/iptablesload  


Reference:  
[Tomcat: redirecting traffic from port 8080 to 80 using iptables](http://glassonionblog.wordpress.com/2011/04/08/tomcat-redirecting-traffic-from-port-8080-to-80-using-iptables/)  
[IptablesHowTo](https://help.ubuntu.com/community/IptablesHowTo)  

