*I3INFo.md*

#This is my i3 DE configuraton#
===============

    *Find*
    
    - I3Status : *i3status/i3status.conf*
    - I3Config : *i3/config*

    *Use*

    - I3Status : ```# cp i3status.conf /etc/i3status.conf```
    - I3Config : ```$ cp config $HOME/.i3/config```


    *I3Status will search for following PID*

    - DHCP : dhcpcd*.pid (/var/run)
    - VPN  : ovpn.pid (/var/run) [OpenVPN --writepid /var/run/ovpn.conf)
    - SSHD : sshd.pid (/var/run)
    - HTTPD: httpd.pid (/var/run/httpd)
    - FTPD : ftpd.pid (/var/run)

    *I3Status "checks"*
    - Wireless / Ethernet
    - Filesystem ( / )
    - CPU w/ temp
    - Volume 
    - PIDs 
    - BATTERY (/sys/class/power_supply/BAT1 = replace 1 with yours, read config)
    - TIME 
    All mixed with great text symbols :P
    
    *Main colors for I3*
    
    - Blue
    - Yellow

    *Uses TextSymbols*
    
    *Pre-setted keybindings*

    - Firefox
    - PopcornTime 
    - Thunar
    - GIMP
    - Spotify 
    - Sublime Text, Codeblocks, Eclipse, Android Studio
    - Mousepad
    - VLC 
    - Guvcview
    - GParted (gksu)
    - Grub-Customizer (gksu)
    - Power-off and reboot keybindings
    - Screenshots (scrot)
    - VirtualBox

    *Wallpapers with feh*
    *GIMP Auto-floating mode*

    *EDIT kblayout variable to your country code: (predef: it) such as - en, fr, de, es*

    *No startup application*

    *For beginners: read both config, I added some comments that may help you to make changes :)*

