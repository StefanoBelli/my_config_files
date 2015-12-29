set KERN_VERSION (uname -r)
set fish_greeting "Welcome back, $USER !
Using kernel: $KERN_VERSION
Fish version: $FISH_VERSION
"
set -x PATH /home/stefanozzz123/.bin $PATH
set -x EDITOR "vim"
set -x GCCFLAGS "-O3 -pipe -Wall"
set -x MAKEFLAGS "-j3"

alias pissh "ssh 192.168.2.100 -p 22 -l "
alias piscan "ssh 192.168.2.100 -p 22 -l root scan "
alias pienablecups "ssh 192.168.2.100 -p 22 -l root cupsd "
