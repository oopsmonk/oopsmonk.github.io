---
title: "Bash Quick Reference"
tags: ["Linux"]
date: 2014-12-04T01:53:31+08:00
---

[Advanced Bash-Scripting Guide](http://tldp.org/LDP/abs/html/index.html)  
[sed](http://www.grymoire.com/Unix/Sed.html)  
[awk](http://www.grymoire.com/Unix/Awk.html)  

## [Internal Variables](http://tldp.org/LDP/abs/html/internalvariables.html)  

```bash
#current parent pid
$$
#last background process pid
$!
#last exit status
$?
#current instance pid, Bash 4.x above.
$BASHPID
```


## [Arithmetic Expansion](http://tldp.org/LDP/abs/html/arithexp.html)  

```bash
a=12
b=$(($a + 10))

b=`expr $a + 1`
b=$(expr $a + 1)

let b=$a+3
#let b=$a + 3 #incorrect 
let "b = $a + 3"

declare -i b=$a+$a
```

## [Manipulating Strings](http://www.thegeekstuff.com/2010/07/bash-string-manipulation/)

* String is a number  

```bash
if [[ $var =~ ^-?[0-9]+$ ]]; then
    echo "$var is a number"
fi

if [[ ! $var =~ ^-?[0-9]+$ ]]; then
    echo "$var is not a number"
fi
```

* Find String between two words or characters 

```bash
var="Hello there are (123340) and (123)"
#last string between '(' and ')'.
substr=$( echo $var | sed 's/.*(\(.*\)).*/\1/' )
#String between '(' and ')'.
substr=$( echo $var | awk -v FS="(\(|\))" '{print $2 " " $4}' )

#String between 'there' and 'and'.
substr=$( echo $var | awk -v FS="(there|and)" '{print $2}' )
#String between 'there' and 'and'.
substr=$( echo $var | sed 's/.*there\(.*\)and.*/\1/' )
#String between 'there' and 'and'.
substr=$( echo $var | grep -o -P '(?<=there).*(?=and)' )
```

## Loop  

* read variables  

```bash
#read from file
echo "123, abc, hello world!" > /tmp/test
echo "12 43, ddd, !" >> /tmp/test

while IFS=',' read var1 var2 var3
do
    echo "var1=$var1 var2=$var2 var3=$var3"
done < "/tmp/test"


#read from variable
x="one, two, three"
while IFS=',' read var1 var2 var3
do
    echo "var1=$var1 var2=$var2 var3=$var3"
done <<< $x
``` 

* iterate IP address

```bash
#iterate class C ip address
for i in 192.168.100.{1..10}
do
    echo "$i"
done

#iterate class B ip address
for x in 192.168.{1..5}
do
    for i in $x.{1..10}
    do
        echo "$i"
    done
done
```

* infinite while loop 

```bash
while :
do
    echo "infinite loops [ CTRL+C to stop]" 
    sleep 5
done
```

## [Array](http://www.linuxjournal.com/content/bash-arrays)  

```bash 

# Simple array
arrayA=( Mon Tue Wed Thu Fri Sat Sun )
echo "${!arrayA[*]}"    # 0 1 2 3 4 5 6
echo "${#arrayA[*]}"    # 7
echo "${arrayA[*]}"     # Mon Tue Wed Thu Fri Sat Sun

echo "${!arrayA[@]}"    # 0 1 2 3 4 5 6
echo "${#arrayA[@]}"    # 7
echo "${arrayA[@]}"     # Mon Tue Wed Thu Fri Sat Sun

echo "${arrayA[2]}"     # Wed
echo "$arrayA"          # Mon
echo "${arrayA[20]}"    # null 

arrayA=( one two )
echo "${arrayA[*]}"     # one two
arrayA+=( three "four" )
echo "${arrayA[*]}"     # one two three four

# Key/Value 
declare -A arrayB=( ["Mon"]="Monday" ["Tue"]="Tuesday" 
["Wed"]="Wednesday" ["Thu"]="Thursday" ["Fri"]="Friday" 
["Sat"]="Saturday" ["Sun"]="Sunday" )

echo "${!arrayB[*]}"    # Thu Tue Wed Mon Fri Sat Sun
echo "${#arrayB[*]}"    # 7
echo "${arrayB[*]}"     # Thursday Tuesday Wednesday Monday Friday Saturday Sunday

echo "${!arrayB[@]}"    # Thu Tue Wed Mon Fri Sat Sun
echo "${#arrayB[@]}"    # 7
echo "${arrayB[@]}"     # Thursday Tuesday Wednesday Monday Friday Saturday Sunday

echo "${arrayB[2]}"     # null
echo "$arrayB"          # null
echo "${arrayB["Tue"]}" # Tuesday

declare -A arrayB=( ["one"]=1 ["two"]="2" )
echo "${!arrayB[*]}"    # one two
echo "${arrayB[*]}"     # 1 2
arrayB+=( ["three"]="3" ["four"]=4 )
echo "${!arrayB[*]}"    # four one two three
echo "${arrayB[*]}"     # 4 1 2 3

arrayB+=( ["four"]="aa" ["five"]="5a1c" )
echo "${!arrayB[*]}"    # four one five two three
echo "${arrayB[*]}"     # 4aa 1 5a1c 2 3

```

## [I/O redirection](http://www.tldp.org/LDP/abs/html/io-redirection.html)  


## Forking Processes  

```bash

pid_perfix="/tmp/proc-"

function doSomething(){
    local pid_file="$pid_perfix$BASHPID"
    echo "this is task $1 : $pid_file " > $pid_file
    sleep 5
}

w_pid=""
for task in {1..5}
do
    doSomething $task &
    w_pid+="$! "
    sleep 1
done

for p in $w_pid
do
    wait $p
done

#clean up
for p in $w_pid
do
    #del pid file 
    rm "$pid_perfix$p"
done

exit 0

```
