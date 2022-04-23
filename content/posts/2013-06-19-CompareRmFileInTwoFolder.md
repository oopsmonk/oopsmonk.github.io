---
title: "Remove the same files in two folders"
tags: ["Linux", "RaspberryPi"]
date: 2013-06-19T01:53:31+08:00
---

有時在整理照片或文件時, 需要比對2個資料匣, 把重覆的檔案拿掉.  
[**Dwonload Source Here**](/resource/2013-06-19/comp-rm.sh)  

```bash
function usage(){
    echo "Find the same file in two folders and remove it."
    echo "usage : ./comp-rm.sh target-dir source-dir"
    echo "remove the same files in target-dir."
}

if [ $# -ne 2 ]; then
    usage
    exit 1
fi

target_dir=$1
source_dir=$2
f_list1=$(find "$target_dir" -type f)
f_list2=$(find "$source_dir" -type f)


for i in $f_list1; do
    echo $f_list2 | grep $(basename $i) >/dev/null && hit_str+=$i";"
done

if [ -z $hit_str ]; then
    echo "list is empty.."
    exit 0
fi

export IFS=";"
count=0
for hit_file in $hit_str; do
    echo "$hit_file"
    let count++
done

echo "Do you want to remove these files ($count)?"
read -p "Press 'Ctrl+C' stop, 'Enter' key to continue..."

for hit_file in $hit_str; do
    echo "removing... $hit_file"
    rm -f $hit_file
done

exit 0
```  

