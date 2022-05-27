" General fzf-related settings and tweaks.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

" Hide unneccesary Vim chrome from the window displaying fzf. Based on a
" snippet from <https://github.com/junegunn/fzf/blob/master/README-VIM.md#hide-statusline>
autocmd! FileType fzf
autocmd FileType fzf let b:laststatus = &laststatus
  \| set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set showmode ruler
  \| let &laststatus = b:laststatus
