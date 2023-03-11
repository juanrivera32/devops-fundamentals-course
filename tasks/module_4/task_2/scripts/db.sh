#!/bin/bash

typeset fileName=users.db
typeset fileDir=../data
typeset filePath=$fileDir/$fileName

function checkIfFileExists {
	if [ -f $filePath ]
	then
		return 1
	else
    read -p "Do you want to create users.db file? [Y/n]" wantToCreate
		if [ "$wantToCreate" == "Y" ] || [ "$wantToCreate" == "y" ]
		then
			touch $filePath
			return 1
		else
			exit 0
		fi
	fi
}

function validateLatinLetters {
  if [[ $1 =~ ^[A-Za-z_]+$ ]]; then return 0; else return 1; fi
}

function add {
	checkIfFileExists
	
	while :
	do
		read -p "Enter username: " username

		validateLatinLetters $username
		if [[ "$?" == 1 ]];
		then
			echo "Name must have only latin letters. Try again."
		else
			break
		fi
	done

	
  while :
	do
		read -p "Enter user role: " role
		validateLatinLetters $role
		if [[ "$?" == 1 ]];
		then
			echo "Role must have only latin letters. Try again"
		else
			break
		fi

	done
	echo "${username}, ${role}" | tee -a $filePath
}

function backup {
  checkIfFileExists
  cat $filePath > "$fileDir/$(date +%F_%H-%M-%S)-users.db.backup"
}

function restore {
  backupFile=$(ls $fileDir/*-$fileName.backup | tail -n 1)
  
  if [[ ! -f $backupFile ]]
  then
    echo "No backup file found"
  else
    cat $backupFile > $filePath
  fi 
}

function find {
  checkIfFileExists

  read -p "Enter username: " username
  
  # It feels a little hacky as I didn't find another way to print each entry in a different line
  if [[ $(grep $username $filePath) == "" ]]
  then
    echo "User not found"
  else
    grep $username $filePath >> temp.db
    cat temp.db
    rm temp.db
  fi
  
}

echo $2
inverseParam="$2"
function list {
    if [[ $inverseParam == "--inverse" ]]
    then
      cat -n $filePath | tac
    else
      cat -n $filePath
    fi
}

function help {
	checkIfFileExists

	echo "Manages users in db. It accepts a single parameter with a command name."
  echo
  echo "Syntax: db.sh [command]"
  echo
  echo "List of available commands:"
  echo
  echo "add     Adds a new line to the users.db. Script must prompt user to type a
        username of new entity. After entering username, user must be prompted to
       	type a role." 
  echo "backup  Creates a new file, named  "$filePath".backup which is a copy of current " $fileName
  echo "find    Prompts user to type a username, then prints username and role if such
        exists in users.db. If there is no user with selected username, script must print:
        “User not found”. If there is more than one user with such username, print all
        found entries."
  echo "list    Prints contents of users.db in format: N. username, role
        where N – a line number of an actual record
        Accepts an additional optional parameter inverse which allows to get
        result in an opposite order – from bottom to top"
}

# export $1

case $1 in
  add)            add ;;
  backup)         backup ;;
  restore)        restore ;;
  find)           find ;;
  list)           list ;;
  help | '' | *)  help ;;
esac
