This repository contains the files necessary to semi-automatically do backups. Currently the user's entire /home is backed up (without encryption). The backup process is based on the UUID of the partition on the external USB drive that was supplied to NLeSC employees. A crontab job is used to notify the user when it's time to back up again.

Tested on 
* Lubuntu 14.10
* Fedora ?


Below are the steps to set it up.

**Install notification software**

1. The backup scripts use ``notify-send`` from the ``libnotify-bin`` package to send notifications to the desktop. You need to install ``libnotify-bin`` with ``sudo apt-get install libnotify-bin``

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
1. There should be a make file, ``Makefile`` which is used to copy the relevant files from ``backup2usbdisk`` to where they need to go. Run ``make install`` to install the software.

**Verification**

1. try to run ~/opt/backup2usbdisk/check-last-backup-date.sh. You should see a message appear in your notification area.



