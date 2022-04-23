---
title: "Add Git SHA1 property in Apache ANT build.xml"
tags: ["git"]
date: 2013-06-13T01:53:31+08:00
---

Create `git.SHA1` property in build.xml file.  

```xml
<available file=".git" type="dir" property="git.present"/>
<target name="git.info" description="Store git info" if="git.present">

    <exec executable="git" outputproperty="git.SHA1" failifexecutionfails="false" errorproperty="">
        <arg value="log"/>
        <arg value="--pretty=oneline"/>
        <arg value="-n1"/>
    </exec>
    <condition property="git.version" value="${git.SHA1}" else="unknown">
        <and>
            <isset property="git.SHA1"/>
            <length string="${git.SHA1}" trim="yes" length="0" when="greater"/>
        </and>
    </condition>

    <echo message="print git log : " />
    <echo message="${git.SHA1}" />

</target>
```  

Reference:

[How to lookup the latest git commit hash from an ant build script](http://stackoverflow.com/questions/2974106/how-to-lookup-the-latest-git-commit-hash-from-an-ant-build-script)  

