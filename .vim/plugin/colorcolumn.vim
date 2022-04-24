" A few "colorcolumn"-related doohickeys and tweaks.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

" Prevent EditorConfig from updating the "colorcolumn" setting as it
" doesn't preserve any existing "colorcolumn" values and doesn't take
" advantage of the "-/+" feature.
let EditorConfig_max_line_indicator = 'none'

autocmd BufEnter,WinEnter * let b:dotfiles_defaultColourColumns = '72,78,+0'

" When editing Git commit messages, Vim changes the text colour of any
" text that goes over fifty characters, but it's pretty hard to make it
" out with the default colour scheme.
autocmd BufEnter,WinEnter * if &filetype == "gitcommit" | let b:dotfiles_defaultColourColumns = '50,+0' | endif
"
" Having multiple coloured columns can be a bit much sometimes,
" especially when you have multiple split windows, so the following
" shortcut allows quick toggling of the coloured columns.
nnoremap <silent> <C-K> :execute "set colorcolumn=" . (&colorcolumn == "" ? b:dotfiles_defaultColourColumns : "")<CR>
