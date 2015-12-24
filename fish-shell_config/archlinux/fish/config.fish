set KERN_VERSION (uname -r)
set fish_greeting "Welcome back, $USER !
Using kernel: $KERN_VERSION
Fish version: $FISH_VERSION
"
set -x PATH $PATH
set -x EDITOR "vim"
set -x GCCFLAGS "-O3 -pipe -Wall"
set -x MAKEFLAGS "-j3"

