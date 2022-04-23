---
title: "Sending HTML Mail Using SMTP With Authorization"
tags: ["Python"]
date: 2013-07-31T01:53:31+08:00
---

Here is a  _**text/plain**_ MIME type parts in official exmaple code.  
I remove it from my sample code, because it's not show up in mail at Office Outlook 2010.  

```python
#!/usr/bin/env python
"""
File name: sendMail.py
Python send HTML mail using SMTP with authorization

Usage :
./sendMail.py to@gmail.com Subtitle [ FilePath | txt ]
"""

import smtplib
import sys,traceback
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from time import gmtime, strftime

#log file location
log_path = "./mail-log";
#log timestamp format
logger_tstamp = "%Y-%m-%d %H:%M:%S"

#SMPT server
smtp_server = "smtp.gmail.com"
#gmail 465 or 578
smtp_port = 587

#mail from 
user = "from@gmail.com"
pwd = "password"

# log method
class Logger:
    file = 1
    err = 2

class ContentType:
    file = 1
    txt = 2

#select log method 
debug_log = Logger.err
#select content type
content_type = ContentType.txt

def debug(msg):
    if debug_log == Logger.file:
        with open(log_path, 'a') as log_file:
            log_file.write(strftime(logger_tstamp, gmtime()) + msg)
        log_file.close()

    elif debug_log == Logger.err:
        sys.stderr.write(strftime(logger_tstamp, gmtime()) + msg)

    else: 
        print(strftime(logger_tstamp, gmtime()) + msg)

#check argument number
arg_count = len(sys.argv)
if arg_count !=4:
    debug("[Error]: invalid argument\n")
    sys.exit(1)
try:
    mail_to = sys.argv[1]
    subject = sys.argv[2]
    if content_type == ContentType.file:
        content_path = sys.argv[3]
        with open(content_path, 'r') as f_content:
            content = f_content.read()
        f_content.close()
    else:
        content = sys.argv[3]

    serv = smtplib.SMTP(smtp_server, smtp_port)
#    serv.ehlo()
    serv.starttls()
#    serv.ehlo()
    serv.login(user, pwd);
    msg = MIMEMultipart('alternative')
    msg['Subject'] = subject
    msg['From'] = user
    msg['To'] = mail_to
    part1 = MIMEText(content, 'html')
    msg.attach(part1)
    serv.sendmail(user, mail_to, msg.as_string())
    serv.quit()
    debug("[Debug] subject : " + subject + "\n")
except:
    debug("[Error]: send mail error\n")
    debug("[Error]:\n" + traceback.format_exc())
    sys.exit(2);
```

Reference:  
[email: Examples](http://docs.python.org/2/library/email-examples.html)  
[smtplib](http://docs.python.org/2/library/smtplib.html)  
[How to send email in Python via SMTPLIB](http://www.mkyong.com/python/how-do-send-email-in-python-via-smtplib/)  

