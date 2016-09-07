This repository contains the files necessary to semi-automatically do backups. Currently the user's entire /home is backed up (using ecryptfs encryption, which the user is assumed to have enabled). The backup process is based on the UUID of the partition on the external USB drive that was supplied to NLeSC employees. A crontab job is used to notify the user when it's time to back up again.

Tested on:

* Lubuntu 14.10  (64 bit)
* Fedora 22  (64 bit)
* Ubuntu 15.04 Desktop (64 bit)
* Lubuntu 16.04 Desktop (64 bit)


Below are the steps to set it up.

**Install notification software**

1. The backup scripts use ``notify-send`` from the ``libnotify-bin`` package to send notifications to the desktop. You may need to install ``libnotify-bin`` with ``sudo apt-get install libnotify-bin``.

**Formatting the USB disk using GParted**

1. Install GParted with ``sudo apt-get install gparted``
1. Start GParted (needs root)
1. In the upper right corner of GParted, your disk devices are listed in a drop-down. Write down which devices you have (e.g. I have only '/dev/sda', the SSD in my laptop)
1. Now plug in your new USB disk
1. In GParted go to menu item 'GParted' -> 'Refresh devices'
1. The dropdown list should now include your new disk device (for me, '/dev/sdb'). Note the size of this disk (mine says 1.82 TiB).
1. Select the new device from the dropdown.
1. It's likely formatted as NTFS, a common file system used on Windows. GParted uses the color green (#42e5ac) to identify the partition as NTFS. We will reformat it to ext4, the default linux ubuntu file system. Obviously, **this will destroy any data on the partition**. If you accidentally select the wrong device, you're in for a lot of **pain** so make sure to get that right. GParted uses blue (#4b6983) to identify partitions as ext4.
1. In GParted, select the partition by clicking the white-rectangle-with-the-green-outline at the top bar in GParted. The green outline now has a white dashed line to indicate the partition has been selected.
1. In GParted, go the menu item 'Partition' and click 'unmount'.
1. Then, go to the menu item 'Partition' and click 'format to' and select 'ext4'.
1. At this stage nothing has been changed yet, so if you get cold feet, this is the last stage when you can abort without having made any changes.
1. If you're ready to go ahead, select menu item 'Edit' and then click on 'Apply all operations'. GParted gives you the warning about "LOSS of DATA", click 'Apply' to go ahead. It should take less than a minute.
1. Click 'Close' when GParted is done.
1. Select the new partition, right-click it. In the context menu, select 'Information'.
1. Write down the UUID number (mine is 7e89d57b-ff95-4a20-9fd2-be228f1419c8)
1. Close the dialog.
1. Close GParted.
1. Unplug the usb disk.
1. Plug it back in.

**Setting up the backup**

1. ``git clone https://github.com/jspaaks/backup2usbdisk.git``
1. ``cd`` into the new directory ``backup2usbdisk``
1. Near the top of the ``backup-home-to-usbdisk.sh`` Bash script, replace my UUID with your UUID.
1. There should be a file called ``Makefile`` which is used to copy the relevant files from ``backup2usbdisk`` to where they need to go. Run ``make install`` to install the software.

**Verification**

1. Try to run ``~/opt/backup2usbdisk/check-last-backup-date.sh``. You should see a message appear in your notification area.
1. By default, backup-home-to-usbdisk.sh is set up to do a dry run, i.e. without making any changes to your system. Run ``~/opt/backup2usbdisk/backup-home-to-usbdisk.sh``. You should see a message appear in your notification area. The first time you run, there will be many files, so even a dry run will take a few minutes.
1. Review the output from the backup script. If it all works and you're happy with the operation, remove the ``--dry-run`` option from the ``rsync`` call in ``~/opt/backup2usbdisk/backup-home-to-usbdisk.sh``
1. The ``make install`` you ran has added a Bash alias for starting the backup script. The next time you start your terminal, you can just type ``backup2usbdisk`` to start the backup.

**Recovery of eCryptFS-encrypted files**

1. see [http://www.howtogeek.com/116297](http://www.howtogeek.com/116297)
1. or [plan B](decrypt-plan-b.md).
1. You are strongly advised to verify that your encrypted data is indeed recoverable via one of these methods.


**Using your USB disk backup to migrate to a new laptop**

When moving to a new latop (with a new disk), you can use your encrypted backup to bring along the contents of your old ``home`` to your new ``home``.

1. Make sure your backup is up to date
1. Plug in the USB disk into the new system. It should get mounted automatically. Mine was mounted here: /media/daisycutter/7e89d57b-ff95-4a20-9fd2-be228f1419c8/
1. In a terminal, make sure your new system has the eCryptFS utilities: ``sudo apt-get install ecryptfs-utils``
1. Now you can mount the contents of the '.Private' directory using the ``ecryptfs-recover-private`` command as follows:
  ```bash
  # adapt the username and UUID
  sudo ecryptfs-recover-private /media/daisycutter/7e89d57b-ff95-4a20-9fd2-be228f1419c8/daisycutter-encrypted.bak/.Private/
  ```
1. It will ask you some questions and then tell you where the data is mounted. Mine was mounted at ``/tmp/ecryptfs.j6p5EzJH``.
1. You can now use ``rsync`` to copy the files from the backup into your new ``home``. I used the following command for this:
   ```bash
   # note the trailing slash
   SRC=/tmp/ecryptfs.j6p5EzJH/

   # note the trailing slash
   DEST=/home/daisycutter/

   sudo rsync --delete
              --verbose
              --recursive
              --links
              --perms
              --times
              --group
              --owner
              --devices
              --specials
              --include ".*"
              ${SRC}
              ${DEST}

   ```


