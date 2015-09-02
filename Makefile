all:
	@echo "Nothing to build, try 'make install'."

install:

	@mkdir -p ${HOME}/.config/backup2usbdisk
	@echo "# made the directory that will contain the last datetime when a backup was made"

	@echo `date` > ${HOME}/.config/backup2usbdisk/last-sync.txt
	@echo "# created the file containing the last datetime, using the current datetime for now"

	@mkdir -p ${HOME}/opt/backup2usbdisk
	@echo "# made the directory that will contain the scripts"

	@cp backup-home-to-usbdisk.sh ${HOME}/opt/backup2usbdisk
	@echo "# copied the backup script file to the install location"

	@cp check-last-backup-date.sh ${HOME}/opt/backup2usbdisk
	@echo "# copied the script that checks whether it's time to start bugging the user"
	@echo "# we will call this script at regular intervals from a crontab job later"

	@cp drive-removable-media-usb.svg ${HOME}/opt/backup2usbdisk
	@echo "# copied the image file to use in the notification"

	@cp README.md ${HOME}/opt/backup2usbdisk
	@echo "# copied the readme for documentation"

	@./add-cronjob.sh
	@echo "# added the cronjob"

	@echo
	@echo "# done."
