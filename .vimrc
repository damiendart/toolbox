" Damien Dart's ".vimrc".
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

set laststatus=2
set nocompatible
set number
set ruler
set wildmenu

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/vim-plug/')
  Plug 'editorconfig/editorconfig-vim'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
call plug#end()

nmap <Leader>f :GFiles<CR>
nmap <Leader>F :Files<CR>
