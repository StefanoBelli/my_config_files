*KERNELINFO.md*

# My Linux kernel configuration
This kernel config is specifically written for MY hardware, don't use on your.
============

```
make menuconfig
make -jX
make modules_install
make headers_install
cp arch/x86_64/boot/bzImage /boot/vmlinuz-x.y.z
*bootloader update*
```


 - 64 bit kernel config
 - LZO compression
 - No ramdisk support
 - default Governor: performance
 - default Input/Output: deadline
 - Buffer Overflow Vulnerability Detector: regular
 - 32-bit executable files support enabled
 - SELinux enabled (default), support for AppArmor enabled
 - .config.gz in /proc filesystem access enabled
 - Minimum debug level
 - Virtualization support (Modularized for Intel, no support for AMD) 
 - Ext4, Ext3, Ext2 support modularized, no support for btrfs, xfs, jfs, 
more...
 - Probably more...

(enabled:core)

- *SONIX JPEG Camera support modularized*
- *UVC support modularized*
- *Wireless Card: Atheros ath9k, wext driver enabled*
- *Ethernet Card: Atheros atl1e, fast ethernet, AR816x/AR817x, enabled*
- *HD Audio: (ALSA: jack plugging detecting, Realtek HD Audio enabled*
- *CPU: Generic x86_64*
- *TUN/TAP device should not be enabled! (VPN connections such as OpenVPN will not work without /dev/net/tun support!)*
- *more*

