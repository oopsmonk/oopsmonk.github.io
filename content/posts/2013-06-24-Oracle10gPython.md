---
title: "Connect Oracle 10g Database use JDBC"
tags: [Database]
date: 2013-06-24T01:53:31+08:00
---

install jayDeBeApi & jpype  

    $ sudo apt-get install python-setuptools  
    $ sudo easy_install JayDeBeApi  
    $ sudo easy_install jpype  

Download Oracle JDBC Drivers ojdbc6.jar to local.

```python
import jpype
import jaydebeapi
jHome = jpype.getDefaultJVMPath()
print jHome
jpype.startJVM(jHome, '-Djava.class.path=/path/to/ojdbc6.jar')
conn = jaydebeapi.connect('oracle.jdbc.driver.OracleDriver', 'jdbc:oracle:thin:user/password@DB_HOST_IP:1521:DB_NAME')
curs = conn.cursor()
curs.execute("select * from ACCOUNT")
acc = curs.fetchall()
curs.close()
conn.close()
jpype.shutdownJVM()
print acc

```

Reference:  
<https://pypi.python.org/pypi/JayDeBeApi>  
<http://wiki.python.org/moin/Oracle>  

