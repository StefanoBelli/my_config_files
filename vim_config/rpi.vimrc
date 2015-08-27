"Simple Vim configuration for Raspberry pi
"StefanoBelli <stefanozzz123>
set nocompatible

"Do not backup files after saving
set nobackup
set noswapfile

"Autoindent lines after a block starts
set autoindent

"Set syntax highlighting on for programming languages
syntax on

"Set the search highlighting
set hlsearch
set showcmd 

"Detect programming languages and automatically set indentation
filetype plugin indent on

"Default tabbing
set tabstop=2

"Keep 10 command history
set history=10

set number

