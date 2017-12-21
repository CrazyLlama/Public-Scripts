#!/usr/bin/env bash

# A little script to compare and gather evil IPs from /var/messages
# Compare output and file, check for current occurences and add to counter if it exists. If not then append to end of the file

comparison_1() { # Add newly appearing IPs to the evilIPs var file aka checking for those freshly grown IPs
        printf "Comparing /var/messages with stored evilIPs"
        diff --unchanged-line-format= --old-line-format= --new-line-format='%L' /var/evilIPs.var <(grep host-deny.sh /var/log/messages | awk '{print $16}' | sort | uniq -c | sort -bgr) >> /var/evilIPs.var # Despite popular opinion, I'm dead inside but whatever works
}

comparison_2() { # Enumerate recurring IPs and add to count aka checking for those sad, disgusting, and down right rotten IPs

        LOG_OUT=$(grep host-deny.sh /var/log/messages | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | awk '{print $16}' | sort | uniq -c | sort -bgr) # I get paid hourly
        VAR_OUT=$(grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' /var/evilIPs.var)
        COMM_OUT=$(comm -12 <(sort $LOG_OUT) <(sort $VAR_OUT) | uniq -c | sort -n -r))
        
        printf "Looking for any recurring IPs and enumerating"
        
        # Remove any current occurences of the matching IPs and add back in with updated counters. 
        # If you're gonna use something like this and have log rotation in use - I'd make sure that the dilation between this running and log rotation is as close to nothing as possible
        sed -i.bak '/$(comm -12 <(sort $LOG_OUT) <(sort $VAR_OUT))/d' /var/evilIPs.var
        
        $COMM_OUT >> /var/evilIPs.var
        
}

if [ -f /var/evilIPs.var ]; then
        printf "File exists!"
else
        printf "\nNo IPs have been extracted, file has been renamed, or is missing.\n\nCreating evilIPs.var\n\n"
        printf  > /var/evilIPs.var
fi

comparison_1
comparison_2

sed -i '/^$/d' /var/evilIPs.var
# What can I say, I like to clean up after my sweet sweet victory (You can remove this as wanted)


## If passed the -s flag then sort the IPs at the end
while getopts ":s:" opt; do
  case $opt in
    a)
      printf "Sorting /var/evilIPs.var as well..." >&2
      sort -n -r /var/evilIPs.var
      ;;
    \?)
      printf "Invalid option: -$OPTARG" >&2
      printf "Options are:"
      printf "-s      Sort the file /var/evilIPs.var at the end"
      ;;
  esac
done

