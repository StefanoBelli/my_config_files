set KERN_VERSION (uname -r)
set fish_greeting "Welcome back, $USER !
Using kernel: $KERN_VERSION
Fish version: $FISH_VERSION
"
set -x LANG "it_IT.UTF-8"
set -x PATH /home/stefanozzz123/.bin $PATH
set -x EDITOR "emacs -nw"
set -x GCCFLAGS "-O3 -pipe -Wall"
set -x MAKEFLAGS "-j3"

alias pissh "ssh 192.168.2.100 -p 22 -l "
alias piscan "ssh 192.168.2.100 -p 22 -l root scan "
alias pienablecups "ssh 192.168.2.100 -p 22 -l root cupsd "
alias tmuxnew "tmux new-session -c $HOME -n Main:fish -s "
alias wanip "curl ipecho.net/plain"
alias kbd "cat ~/.i3/config | grep "
alias cemacs "emacs -nw "
alias automount "udiskie-mount "
alias autoumount "udiskie-umount "
alias rangerhere "ranger ."

#startx when login
if status --is-login and test -e /etc/systemd/system/display-manager.service  
   # do nothing
else
   if test -z "$DISPLAY" -a $XDG_VTNR -eq 1
      exec startx -- -keeptty
   end
end

    
