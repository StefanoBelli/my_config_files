set KERN_VERSION (uname -r)
set fish_greeting "Welcome back, $USER !
Using kernel: $KERN_VERSION
Fish version: $FISH_VERSION
"

set normal (set_color normal)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)

set -x LANG "en_US.UTF-8"
set -x EDITOR "vim"
set -x MAKEFLAGS "-j5"
set -x CC /usr/bin/gcc
set -x CXX /usr/bin/g++
set -x CFLAGS "-O2 -pipe -march=native -mtune=native"
set -x CXXFLAGS "$CFLAGS"

#set -x PATH /usr/lib/qt/bin /usr/lib/qt4/bin \
#            /home/stefanoz/.bin \
#			/usr/bin /sbin /bin /usr/local/bin /usr/lib/go/bin $PATH

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
alias editfishconf "$EDITOR ~/.config/fish/config.fish"

set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red
set __fish_git_prompt_char_dirtystate '-d-'
set __fish_git_prompt_char_stagedstate '-s!->'
set __fish_git_prompt_char_untrackedfiles '-/u/-'
set __fish_git_prompt_char_stashstate '--st--'
set __fish_git_prompt_char_upstream_ahead '--ups+..'
set __fish_git_prompt_char_upstream_behind '--ups-..'

#startx when login
#if status --is-login and test -e /etc/systemd/system/display-manager.service  
#   # do nothing
#else
#   if test -z "$DISPLAY" -a $XDG_VTNR -eq 1
#      exec startx -- -keeptty
#   end
#end
