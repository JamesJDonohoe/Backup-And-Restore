#!/bin/bash

# backing up in the backup folder
BACKUP=backup
# Folder for all daily backups
DAYBACKUP=$BACKUP/daily
# Name of directory to create for current backup  
TODAYBACKUP=$DAYBACKUP/$DAYOFWEEK
# directory to store last weeks data
ARCHIVE=$BACKUP/archive
# Location of a file to hold the date stamp of last level 0 backup
DATESTAMP=$BACKUP/.datestamp
NOW=$(date)
# Log dir
LOG=$BACKUP/logs
# Logfile
LOGFILE=$LOG/$(date +"%m%d%Y_%s").log
echo "------------------------------------------------------------------------------"
echo "--------------------------------Backup Menu-----------------------------------"
echo "------------------------------------------------------------------------------"
echo "Press 1 to Backup or press 2 to enter a filesystem to backup"

read number
if [ $number -lt 1 ]
then
	echo "$0 ERROR!! Please enter 1 or 2"
	exit 1
else
	if [ "$number" = "1" ]
	then
		echo "Backing up everything"
  		FILESYSTEMS="/home"
	else
		echo "Enter a filesystem to backup"
		read file
		FILESYSTEMS="/$file"
		echo "You picked $file to backup"
		if [[ "$file" == "" ]]
		then
			echo "ERROR! Enter a filesystem"
			exit 1
		fi
	fi
fi


# if no backup directory is found it will create it
if [ ! -d "$BACKUP" ]
then
    echo "The specified backup directory $BACKUP does not exist."
    mkdir $BACKUP
	echo "Making $BACKUP directory"
else
	echo "Backing up to $BACKUP directory."
fi

# if there isn't a log file it will create one 
if [ ! -d $LOG ]
then
	mkdir $LOG
	echo "Making $LOG directory"
else 
	echo "$LOG directory exists"
fi

echo "Piping to $LOGFILE"
exec 3>&1                         # creating a file discriptor and putting it into 1 
exec 1> "$LOGFILE"                   # putting stdout into logfile 
exec 2>&1                         

	echo "Piping information" 1>&3
	#Incremental backup
	# Makes a todaybackup if it doesn't exist, if it does it prints out the directery and pipes into it
	if [ ! -d $TODAYBACKUP ]
		then
		mkdir $TODAYBACKUP
		echo "Making $TODAYBACKUP directory" 1>&3
	else
		echo "$TODAYBACKUP directory exists" 1>&3
	fi

	# creates timestamp file and putting time and date of backup into it
	if [ ! -w $DATESTAMP ]
	then
		touch $DATESTAMP
		echo "2014-04-16" > $DATESTAMP
		echo "Date stamp is $DATESTAMP" 1>&3
	else
		echo "Date stamp is $DATESTAMP" 1>&3
	fi

	for BACKUPFILES in $FILESYSTEMS
	do
		echo "Logging output and backing up" 1>&3
		OUTFILENAME=$BACKUPFILES.tar
		OUTFILE=$TODAYBACKUP/$OUTFILENAME
		STARTTIME=`date`
		tar --create \
		--file $OUTFILE \
		--label "Backup ${NOW}" \
		$BACKUPFILES 
		echo "Outfile name is $OUTFILE" 1>&3
		gzip -verbose $OUTFILE
        #rm -f $OUTFILE
	done
	echo "done" 1>&3


SCRIPTFINISHTIME=`date`
exit 1
