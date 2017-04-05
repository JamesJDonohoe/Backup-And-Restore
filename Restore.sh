#!/bin/bash

# Where to create the backups; It should already exist
BACKUP=backup/daily

echo "--------------------------------------------------------------------------------------"
echo "-----------------------------------Restore Menu---------------------------------------"
echo "--------------------------------------------------------------------------------------"
echo "Press 1 to Restore automatic backup or press 2 to select a backup"

read number
if [ $number -lt 1 ]
then
	echo "$0 ERROR!! Please enter 1 or 2"
	exit 1
else
	if [ "$number" = "1" ]
	then
		echo "Automatic Restore....."
  		FILESYSTEMS="/home"
	else
		echo "Enter a folder to backup"
		read file
		FILESYSTEMS="/$file"
		echo "The folder you picked is $file"
		#if blank it will spit error
		if [[ "$file" == "" ]]
		then
			echo "ERROR!! Please enter a folder"
			exit 1
		fi
	fi
fi


if [ ! -d "$BACKUP" ]
then
    echo " $BACKUP does not exist."
	
else
	echo "Backing up to from $BACKUP"
fi


LATESTDIR=$(ls -t $BACKUP | head -1)
RESTORE=$BACKUP/$LATESTDIR
if [ ! -d "$RESTORE" ]
then 
	echo "No restore created"
else
	echo "$RESTORE is restoring"
fi

echo "$FILESYSTEMS:"

# x - get files from the archive, v - getting extrended information, z - to read archives through gzip, f - use the file in the command
echo "tar xvzf $RESTORE/$FILESYSTEMS"
FULLDIR=$RESTORE/$FILESYSTEMS.tar
tar xvf $FULLDIR

echo "Done"
