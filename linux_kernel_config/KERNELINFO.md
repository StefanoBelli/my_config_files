*KERNELINFO.md*

# My Linux kernel configuration

This kernel config is specifically written for MY hardware, don't use on your.

However you can try to make your own changes.

============

First of all, decompress config.gz

- un-gzip config.gz

```
gzip -d config.gz
```

 - 64 bit kernel config
 - LZ4 compression (fast decompress algorithm)
 - No ramdisk support (Bootup improvements) 
 - default Governor: performance
 - default Input/Output: deadline
 - Buffer Overflow Vulnerability Detector: regular
 - 32-bit executable files support enabled
 - AppArmor enabled as default MAC (Mandatory Access Control), SELinux !!DISABLED!!
 - .config.gz in /proc filesystem access enabled
 - Minimum debug level
 - Virtualization support (Modularized for Intel, no support for AMD) 
 - Ext3, Ext2 support modularized 
 - Btrfs, XFS, Ext4 Filesystems enabled (kernel core) 
 - Enabled other btrfs+xfs features (such as Quota for XFS)
 - UVC driver now works
 - cdc-acm integrated into kernel core features (/dev/ttyACM[n]), due to Arduino
 - Probably more...

(enabled:core)

- *SONIX JPEG Camera support modularized*
- *UVC support modularized*
- *Wireless Card: Atheros ath9k, wext driver enabled*
- *Ethernet Card: Atheros atl1e, fast ethernet, AR816x/AR817x, enabled*
- *HD Audio: (ALSA: jack plugging detecting, Realtek HD Audio enabled*
- *CPU: Generic x86_64*
- *more*
- *FUSE Filesystem*
- *CIFS Filesystem*

Other things... :)
Tested with Linux 4.1.6

"linux-config" may not work (kernel panic) 
"desktop-linux-config" is based on Arch configuration, but I personalized it
