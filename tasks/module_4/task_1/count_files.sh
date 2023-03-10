#!/usr/bin/env bash

RED='\033[0;31m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

read -p "Enter the directory path you'd like to use: " dir_name

if [ ! -d $dir_name ] 
then
    echo "${RED}Directory $dir_name does not exist." 
    exit 0
fi

echo "${CYAN}===============================${CYAN}"
number_of_files=`find $dir_name -type f | wc -l`

echo "The number of files inside ${GREEN}$dir_name${NC} is: ${GREEN}$number_of_files"
