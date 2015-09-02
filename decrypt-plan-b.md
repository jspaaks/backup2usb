1. Boot (any) system using a live CD/USBdrive with Linux. I used Fedora 22 for recovery, while the native system had been Lubuntu 14.10
1. Plug in the USB disk
1. Make sure the USB disk is mounted. Use a terminal to ``cd`` into where the disk is mounted. There should be two hidden directories: ``.ecryptfs`` and ``.Private.`` The latter contains the encrypted files, the former contains some metadata.
1. Now ``cd`` into ``.ecryptfs`` and do a ``ls -la`` to show the hidden files. There should be a file ``wrapped-passphrase``. We are going to unwrap it (you need your normal system login password for that).
1. Next we're going to need some ecryptfs related utilities, which are not always installed by default. Install with ``sudo apt-get install ecryptfs-utils``
1. (still in ``.ecryptfs`` directory), run: ``ecryptfs-unwrap-passphrase ./wrapped-passphrase`` Somewhat confusingly, that command will ask for a
 'Passphrase', this is your normal system login password. It returns the _ecryptfs unwrapped passphrase_ (a long alphanumeric sequence, usually 32 characters in length).
1. Add the _ecryptfs unwrapped passphrase_ using ``sudo ecryptfs-add-passphrase --fnek`` (<fill in _ecryptfs unwrapped passphrase_>). It should now give you 2 so-called _authorization token signatures_: basically two numbers. Mine were about half the size of the _ecryptfs unwrapped passphrase_, not sure if that means something.
1. Let's mount the ``.Private`` directory in a directory of our choice, e.g. ``/home/liveuser/decrypted`` using: ``mkdir -p /home/liveuser/decrypted`` followed by ``sudo mount -t ecryptfs <mountpoint-of-the-usbdisk>/.Private /home/liveuser/decrypted``
1. It will then ask you a couple of questions. Here's what I used:
   1. (keytype): passphrase (fill in the _ecryptfs unwrapped passphrase_)
   1. (cipher): aes
   1. (key bytes): 16
   1. (plaintext passthrough): n
   1. (filename encryption): y
   1. (FNEK signature): fill in the second authorization token signatures from one of the previous steps, and ignore the warning about sig-cache.txt.
   1. (proceed with the mount): yes
   1. (append signature to sig-cache.txt): yes
1. now open a file browser (might need root but probably not), navigate to ``/home/liveuser/decrypted/``, your files should be there.
