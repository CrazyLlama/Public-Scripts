#!/usr/bin/env bash

## Need to add user input for file parsing or even pulling the needful out automatically
## For now it finds limited types of files and attempts to decode them
##
## Example start of line of files this will find: 
## `eval(gzuncompress(base64_decode('`
##
## Please please please don't run this anywhere important/enterprise - the line that gathers the array contents also finds a lot of false
## positives and it would be irresponsable to send these out to a third party

# Put API key here:
API="<API-KEY-HERE>"

alias find_evil="grep '((eval.*(base64_decode|gzinflate|\$_))|\$[0O]{4,}|FilesMan|JGF1dGhfc|IIIl|die\(PHP_OS|posix_getpwuid|Array\(base64_decode|document\.write\("\\u00|sh(3(ll|11)))' . -lroE --include=*.php*"
array=( (find_evil) )
# Send off to decode on unphp.net API
for i in $array[@]; 
do
  curl  -o /tmp/out.$i -i -F api_key=$API -F file=@$i http://www.unphp.net/api/v2/post
done
# What's it got?
ls -al /tmp/out.*

printf "see /tmp/out.<filename> for full output"

## To give credit: I pulled the one liner from this - https://djlab.com/2010/09/finding-php-shell-scripts-and-php-exploits/
