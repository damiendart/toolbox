" Damien Dart's ".vimrc".
"
" This file should only contain simple configuration stuff; anything
" more complex should get shipped off to self-contained files in
" "$TOOLBOX_ROOT/.vim/" (use "gf" to edit or view these files):
"
" - "$TOOLBOX_ROOT/.vim/after/plugin/plugins.vim"
" - "$TOOLBOX_ROOT/.vim/after/syntax/markdown.vim"
" - "$TOOLBOX_ROOT/.vim/ftplugin/markdown.vim"
" - "$TOOLBOX_ROOT/.vim/plugin/additional-file-info.vim"
" - "$TOOLBOX_ROOT/.vim/plugin/base64.vim"
" - "$TOOLBOX_ROOT/.vim/plugin/colorcolumn.vim"
" - "$TOOLBOX_ROOT/.vim/plugin/editorconfig.vim"
" - "$TOOLBOX_ROOT/.vim/plugin/fuzzy-files.vim"
" - "$TOOLBOX_ROOT/.vim/plugin/fuzzy-grep.vim"
" - "$TOOLBOX_ROOT/.vim/plugin/fuzzy-snippets.vim"
" - "$TOOLBOX_ROOT/.vim/plugin/fzf.vim"
" - "$TOOLBOX_ROOT/.vim/plugin/plugins.vim"
"
" (For more information about this organisation approach, please see
" <https://vimways.org/2018/from-vimrc-to-vim/>.)
"
" A cheat-sheet for some of the more frequently-used custom
" functionality is available at "$TOOLBOX_ROOT/.vim/doc/toolbox.txt" (or
" search for "toolbox" using Vim's help functionality if the help tags
" file for "toolbox.txt" has been generated).
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

set encoding=utf-8
scriptencoding utf-8

set backspace=indent,eol,start
set display=truncate
set history=200
set laststatus=1
set lazyredraw
set nrformats-=octal
set scrolloff=5
set showcmd
set splitbelow
set splitright
set t_vb=
set ttimeout
set ttimeoutlen=100
set visualbell
set wildmenu

if executable('rg')
  set grepformat+=%f:%l:%c:%m
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
endif

" Fixes some Vim-in-tmux colour-related funkiness caused by the
" "background" option being incorrectly set. For more information, see
" <https://github.com/vim/vim/issues/7867#issuecomment-781794423> and
" <https://unix.stackexchange.com/q/348771>.
if exists('$TMUX') && !exists('$VIM_TERMINAL')
  let &t_RB = "\ePtmux;\e\e]11;?\007\e\\"
endif

if has('autocmd')
  filetype plugin indent on
endif

if has('mouse')
  set mouse=a
endif

if has('reltime')
  set incsearch
endif

if has('syntax')
  syntax enable
endif

packadd! matchit

if filereadable($HOME . '/.machine.vimrc')
  source ~/.machine.vimrc
endif
