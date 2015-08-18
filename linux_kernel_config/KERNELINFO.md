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

```
make mrproper #cleans all useless files
cp ../my_config_files/linux_kernel_config/config .config
make menuconfig #do your changes
make -jX # where X is the number of CPUs to use (Suggested: 2)
make modules_install # installs modules in /lib/modules, need to be root
make headers_install #installs kernel headers
cp arch/x86_64/boot/bzImage /boot/vmlinuz-kernel #copies the compressed kernel image in /boot, renaming it as vmlinux-kernel
*bootloader update* #after that you need to update your bootloader [GRUB, LILO, SYSLINUX, etc...]
```


 - 64 bit kernel config
 - LZO compression (Less compression but faster decompression)
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

