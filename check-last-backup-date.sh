#!/bin/bash

# this script needs notify-send from libnotify-bin package

# exit on any error
set -o errexit

# disallow unset variables
set -o nounset


# url of the local copy of the last sync date
lastSyncSRC=${HOME}"/.config/backup2usbdisk/last-sync.txt"

str=`cat ${lastSyncSRC}`
epochLastSync=`date --date="${str}" "+%s"`
epochNow=`date "+%s"`
epochDiff=$(($epochNow-$epochLastSync))
nDays=$(($epochDiff/(60*60*24)))
nDaysMax=5

if [ "${nDays}" -lt "${nDaysMax}" ]; then
    # it's all good, the last backup was less than nDaysMax days ago
    notify-send "Backup" "It's all good, the last backup was less than ${nDaysMax} days ago." -t 15000 -i ${HOME}/opt/backup2usbdisk/drive-removable-media-usb.svg
    exit 0
else
    notify-send "Reminder" "The last backup was ${nDays} days ago." -t 15000 -i ${HOME}/opt/backup2usbdisk/drive-removable-media-usb.svg
fi

