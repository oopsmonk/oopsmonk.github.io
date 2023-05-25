---
title: "Browser Graphics Are Broken"
date: 2023-05-25T12:00:25+08:00
description: "Cannot see graphics in browsers on Ubuntu"
# weight: 1
tags: ["Ubuntu", "Chrome"]
# author: ["Me", "You"] # multiple authors
draft: false
hidemeta: false
# comments: false
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: false # when using page bundles set this to true
#     hidden: true # only hide on current single page
---

Since an Ubuntu update on 2023-05-24, graphics seem to be broken on Chrome and Microsoft Edge browsers.

![](/images/2023-05-25/Ubuntu-browser-1.png)

A workaround is to remove the `GPUCache` folder in `.config`

Google Chrome
```shell
rm -rf ~/.config/google-chrome/Default/GPUCache
```

Microsoft Edge
```shell
rm -rf ~/.config/microsoft-edge/Default/GPUCache
```

Reference: [Since 23 May 2023 Ubuntu 22.04 Mesa updates, Chrome won't display website graphics](https://askubuntu.com/questions/1469116/since-23-may-2023-ubuntu-22-04-mesa-updates-chrome-wont-display-website-graphi)

