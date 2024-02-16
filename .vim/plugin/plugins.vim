" Disables some unnecessary plugins.
"
" For more information on the standard plugins distributed with Vim, see
" <https://github.com/vim/vim/tree/master/runtime/plugin>.
"
" See also "$TOOLBOX_ROOT/.vim/after/plugin/plugins.vim".
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

let loaded_2html_plugin = 1
let loaded_getscriptPlugin = 1
let loaded_logiPat = 1
let loaded_rrhelper = 1
let loaded_spellfile_plugin = 1
let loaded_tarPlugin = 1
let loaded_vimballPlugin = 1
let loaded_zipPlugin = 1

" Neovim 0.9.0 and later has built-in EditorConfig support.
if has('nvim-0.9.0')
  let g:loaded_EditorConfig = 1
endif
