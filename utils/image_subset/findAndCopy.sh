#!/bin/bash
#
#arg 1: text list of file names
#arg 2: directory to search
#arg 3: directory to copy files to
#
#
b=$2
c=$3

while read line
do
    name=$line
    find "${b}" -name "$name" -exec cp -n {} "${c}" \;    

done < $1

