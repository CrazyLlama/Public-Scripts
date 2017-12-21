#!/usr/bin/env bash

# By: The Magnificent Brett
# Alias: ApproximatelyBee
# Tweet me: @odin_the_mighty

## To-do - add user options and whether they want anything stopping/killing

echo "Enter the string you would like to search the process list for:"

read proc

# Stick processes output into array - prepending `/proc/` for later usage
proc_array=( $(ps faux | grep $proc | grep -v root | awk '{print $2}' | sed 's/^/\/proc\//g') )

# Stick processes output into array - specifically the names of the processes
array=( $(ps faux | grep $proc | grep -v root | awk '{ s = ""; for (i = 11; i <= NF; i++) s = s $i " "; print s }')

## https://media.giphy.com/media/26DOs997h6fgsCthu/giphy.gif ##

echo ""
echo "Applicable processes:"
echo ${array[@]}
echo ""

# Then give both cwd and exe to the user
echo "Current working directories and executables:"

for i in ${proc_array[@]};
do
    echo "process directory - $i"
    echo "cwd - $(ls -al $i | grep cwd | awk '{print $11}')"
    echo "exe - $(ls -al $i | grep exe | awk '{print $11}')"
    echo ""
done

## Remotely executing this: bash <(curl -s <RAW-LINK>)
