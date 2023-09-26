" General fzf-related settings and tweaks.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

" The following popup-window-functionality check is based on code from
" <https://github.com/junegunn/fzf/blob/master/plugin/fzf.vim>.
let s:popup_support = has('nvim') ? has('nvim-0.4') : has('popupwin') && has('patch-8.2.191')

let g:fzf_base_spec = s:popup_support
  \? { 'window': { 'width': 0.9, 'height': 0.6 } }
  \: { 'down': '~40%' }

let g:fzf_preview_command = 'cat {} 2>/dev/null'
let g:fzf_preview_line_command = '(nl -ba {1} | grep --color=always -E "$(printf "|^\s*%s\s.*" {2})") 2>/dev/null'

autocmd! FileType fzf

if (s:popup_support && has('nvim'))
  " In Neovim, close the popup window running fzf once it loses focus,
  " otherwise you're left with a window that cannot be refocused (and
  " has to be closed by other means). This isn't required for Vim as
  " popup windows running a terminal cannot lose focus (for more
  " information, see "popup-terminal" under Vim help).
  autocmd FileType fzf autocmd WinLeave <buffer> close!
else
  " Hide unneccesary Vim chrome when displaying fzf in a non-floating
  " window to make it look a little tidier. This is based on
  " <https://github.com/junegunn/fzf/blob/master/README-VIM.md#hide-statusline>.
  autocmd FileType fzf let b:laststatus = &laststatus
    \| set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set showmode ruler
    \| let &laststatus = b:laststatus
    \| autocmd WinLeave <buffer> close!
endif
