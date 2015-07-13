"Simple Vim configuration for Raspberry pi
"StefanoBelli <stefanozzz123>

"Do not backup files after saving
set nobackup

"Autoindent lines after a block starts
set autoindent

"Set syntax highlighting on for programming languages
syntax on

"Set the search highlighting
set hlsearch
set showcmd 

"No compatibility with Vi settings (The original Vi)
set nocompatible 

"Detect programming languages and automatically set indentation
filetype plugin indent on

"Default tabbing
set tabstop=5

"Keep 10 command history
set history=10

