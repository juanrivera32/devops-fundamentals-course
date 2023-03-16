#!/usr/bin/env bash

read -p "Enter the threshold value: " user_threshold

echo $user_threshold

# set threshold level 70% by default
WARNING_THRESHOLD="${user_threshold:-70}"
df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
do
  # get partition capacity
  capacity=$(echo "${output}" | awk '{ print $1}' | cut -d'%' -f1)
  partition_name=$(echo "${output}" | awk '{ print $2 }')
  
  if [ "${capacity}" != "0B" ] && [ "${capacity}" -ge ${WARNING_THRESHOLD} ]; then
      echo "Running out of space \"$partition_name (${capacity}%)\" on $(hostname) as on $(date)" 
  fi
done