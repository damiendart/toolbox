" Damien Dart's "init.vim" for Neovim.
"
" See also "$TOOLBOX_ROOT/.vimrc".
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

" The following uses examples from
" <https://neovim.io/doc/user/nvim.html#nvim-from-vim>.

set runtimepath^=~/.vim
set runtimepath+=~/.vim/after

let &packpath = &runtimepath

source ~/.vimrc
