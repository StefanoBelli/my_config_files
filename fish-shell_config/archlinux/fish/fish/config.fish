set KERN_VERSION (uname -r)
set fish_greeting "Welcome back, $USER !
Using kernel: $KERN_VERSION
Fish version: $FISH_VERSION
"
set -x LANG "it_IT.UTF-8"
set -x PATH /usr/lib/qt/bin /usr/lib/qt4/bin \
            /home/stefanoz/.bin \
			/usr/bin /sbin /bin /usr/local/bin /usr/lib/go/bin $PATH
set -x EDITOR "vim"
set -x MAKEFLAGS "-j10"
set -x CC /usr/bin/gcc
set -x CXX /usr/bin/g++
set -x CFLAGS "-O2 -m64 -pipe -march=skylake -mtune=skylake"
set -x CXXFLAGS "$CFLAGS"
set -x MCPATH $HOME/.jar/minecraft.jar

alias pissh "ssh 192.168.2.100 -p 6895 -l "
alias piscan "ssh 192.168.2.100 -p 6895 -l root scan "
alias pienablecups "ssh 192.168.2.100 -p 6895 -l root cupsd "
alias tmuxnew "tmux new-session -c $HOME -n Main:fish -s "
alias wanip "curl ipecho.net/plain"
alias kbd "cat ~/.i3/config | grep "
alias cemacs "emacs -nw "
alias automount "udiskie-mount "
alias autoumount "udiskie-umount "
alias rangerhere "ranger ."
alias lah "ls -lah "
alias lh "ls -lh "
alias firefox "/usr/bin/firefox "
alias pimntste "sshfs stefanozzz123@192.168.2.100:/home/stefanozzz123 ~/mntsshfs "

#startx when login
#if status --is-login and test -e /etc/systemd/system/display-manager.service  
#   # do nothing
#else
#   if test -z "$DISPLAY" -a $XDG_VTNR -eq 1
#      exec startx -- -keeptty
#   end
#end

    

