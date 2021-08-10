#!/bin/bash

# Installation:
# crontab -e
# 30 9,12,16 * * 1-5 ~/.local/share/cron-scripts/workstation-backup.sh

# Define the <user>
USER=twysto;

# Define the <user> home directory
HOME=/home/$USER;

# Define the source directories where the files you want to backup are located
SOURCE1=$HOME/Documents;
SOURCE2=$HOME/Homestead;
SOURCE3=$HOME/Partage-Reseau;
SOURCE4=$HOME/Workspaces;

# Defining the target directory where to store the backups
TARGET=$HOME/Workstation-Backups;

# Get current date and time (YmdHMS)
DATETIME=$(date '+%Y%m%d%H%M%S');

# Get 1 month ago date and time (YmdHMS)
MONTHAGO=$(date '+%Y%m%d%H%M%S' --date '1 week ago');

# Going into the directory /home/<user>/
cd $TARGET;

# Create a new backup directory where to put the archive
mkdir -p $DATETIME;

# Gzip the directory /home/<user>/Documents/
# Gzip the directory /home/<user>/Homestead/
# Gzip the directory /home/<user>/Partage-Reseau/
# Gzip the directory /home/<user>/Workspaces/
#  - Excluding the directories named /vendor/
#  - Excluding the directories named /node_modules/
#  - Excluding the SQL Dumps larger than 1M 
tar -I 'gzip -9' -cvp \
	-X <(find $SOURCE4 -type d | egrep '/(vendor|node_modules)/') \
	-X <(find $SOURCE4 -type f -name *.sql -size +1M) \
	-f $DATETIME/workstation-backup.tar.gz $SOURCE1 $SOURCE2 $SOURCE3 $SOURCE4;

# Deleting the backup directories that are older than 1 month
for backup_dir in *
do
	test $backup_dir -lt $(date '+%Y%m%d%H%M%S' --date '1 week ago') && rm -r $TARGET/$backup_dir;
done
