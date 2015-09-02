#!/bin/bash

# this script needs notify-send from libnotify-bin package


# define the UUID of the target disk (edit the number to match your
# own disk's UUID)
USB_DISK_UUID=7e89d57b-ff95-4a20-9fd2-be228f1419c8



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                     #
#           no need to edit anything below this line                  #
#                                                                     #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #




if [ ${USER} == "root" ]; then
    notify-send "Error during backup" "Don't run the whole "\
                         "script as root. Backup aborted." -t 15000 \
                         -i ${HOME}/opt/backup2usbdisk/drive-removable-media-usb.svg
    exit -1
fi


# define the source directory
SRC=${HOME}/

# retrieve the device from the disk UUID
USB_DISK_DEV=`blkid -U $USB_DISK_UUID -o device`

# find where $USB_DISK_UUID is mounted
USB_DISK_MNT=`findmnt -rn -S UUID=$USB_DISK_UUID -o TARGET`

# define the destination directory
DEST=${USB_DISK_MNT}/${USER}.bak/

# url of the local copy of the last sync date
lastSyncSRC=${HOME}"/.config/backup2usbdisk/last-sync.txt"

# url of the remote copy of the last sync date
lastSyncDEST=${DEST}"last-sync.txt"

str=`cat ${lastSyncSRC}`
epochLastSync=`date --date="${str}" "+%s"`
epochNow=`date "+%s"`
epochDiff=$(($epochNow-$epochLastSync))
nDays=$(($epochDiff/(60*60*24)))
nDaysMax=5

# check if the USB_DISK_UUID exists
if [ -z "$USB_DISK_DEV" ]; then
    notify-send "Error during backup" "I do not know that UUID. Backup aborted." -t 15000 -i ${HOME}/opt/backup2usbdisk/drive-removable-media-usb.svg
    exit -1
fi

# check if USBDISK is mounted
if [ -z "${USB_DISK_MNT}" ]; then
    notify-send "Error during backup" "$USB_DISK_DEV is not mounted. Aborting." -t 15000 -i ${HOME}/opt/backup2usbdisk/drive-removable-media-usb.svg
    exit -1
fi

notify-send "Starting the backup" "" -t 15000 -i ${HOME}/opt/backup2usbdisk/drive-removable-media-usb.svg

# I'm not using compression even if that's faster. This is because rsync
# sometimes has trouble with large files such as virtual machine disk
# images (e.g. *.vdi) which I happen to have.
sudo rsync --delete    \
           --verbose   \
           --recursive \
           --links     \
           --perms     \
           --times     \
           --group     \
           --owner     \
           --devices   \
           --specials  \
           --dry-run   \
           ${SRC}      \
           ${DEST}


theDate=`date`

# write the current date and time to a file 'last-sync.txt' in ${DEST}
echo "${SRC} was last synchronized with ${DEST} on ${theDate}" > ${lastSyncDEST}

# write the current date and time to a file 'last-sync.txt' in ${SRC}
echo "${theDate}" > ${lastSyncSRC}


