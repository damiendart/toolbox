" Damien Dart's ".vimrc".
"
" This file should only contain simple configuration gubbins; anything
" more complex gets shipped to self-contained files in
" "$HOME/.vim/plugin" (use "gf" to edit or view these files):
"
" - "$HOME/.vim/plugin/colorcolumn.vim"
" - "$HOME/.vim/plugin/fuzzy-files.vim"
" - "$HOME/.vim/plugin/fuzzy-grep.vim"
" - "$HOME/.vim/plugin/fuzzy-snippets.vim"
" - "$HOME/.vim/plugin/fzf.vim"
" - "$HOME/.vim/plugin/plugins.vim"
"
" For more information about this approach, please see
" <https://vimways.org/2018/from-vimrc-to-vim/>.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

set encoding=utf-8
scriptencoding utf-8

set backspace=indent,eol,start
set display=truncate
set history=200
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
  set grepformat=%f:%l:%c:%m
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
endif

" Improves Vim-in-tmux colour-related funkiness (for more information,
" see <https://unix.stackexchange.com/q/348771>). This doesn't work all
" the time; Vim will still sometimes set the wrong value for the
" "background" option during Git rebasing.
if exists('$TMUX')
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
