set KERN_VERSION (uname -r)
set fish_greeting "Welcome back, $USER !
Using kernel: $KERN_VERSION
Fish version: $FISH_VERSION
"

#Environment Variables
set -x LANG "en_US.UTF-8"
set -x PATH /usr/lib/qt/bin /usr/lib/qt4/bin \
            /home/stefanoz/.bin \
			/usr/bin /sbin /bin /usr/local/bin /usr/lib/go/bin $PATH
set -x EDITOR "/usr/bin/vim"
set -x MAKEFLAGS "-j10"
set -x CC /usr/bin/gcc
set -x CXX /usr/bin/g++
set -x CFLAGS "-O2 -m64 -pipe -march=skylake -mtune=skylake"
set -x CXXFLAGS "$CFLAGS"
set -x MCPATH $HOME/.jar/minecraft.jar

## Show git status if there is git local repo
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showinvalidstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showstagedstate 'yes'

set __fish_git_prompt_color_branch green
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

set __fish_git_prompt_char_dirtystate '!'
set __fish_git_prompt_char_stagedstate '↑'
set __fish_git_prompt_char_upstream_ahead '→'
set __fish_git_prompt_char_upstream_behind '←'
set __fish_git_prompt_char_upstream_equal '='
set __fish_git_prompt_char_invalidstate '‼'

# useful aliases
alias pissh "ssh 192.168.2.100 -p 6895 -l "
alias piscan "ssh 192.168.2.100 -p 6895 -l root scan "
alias pienablecups "ssh 192.168.2.100 -p 6895 -l root cupsd "
alias tmuxnew "tmux new-session -c $HOME -n Main:fish -s "
alias wanip "curl ipecho.net/plain"
#alias kbd "cat ~/.i3/config | grep "
alias cemacs "emacs -nw "
alias automount "udiskie-mount "
alias autoumount "udiskie-umount "
alias rangerhere "ranger ."
alias lah "ls -lah "
alias lh "ls -lh "
#alias firefox "/usr/bin/firefox "
alias pimntste "sshfs stefanozzz123@192.168.2.100:/home/stefanozzz123 ~/mntsshfs "

#startx when login
#if status --is-login and test -e /etc/systemd/system/display-manager.service  
#   # do nothing
#else
#   if test -z "$DISPLAY" -a $XDG_VTNR -eq 1
#      exec startx -- -keeptty
#   end
#end

    

