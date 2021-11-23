" Damien Dart's ".vimrc".
"
" A generally unremarkable Vim configuration file: it imports the
" default settings, tweaks a few visual-related settings, includes a few
" plugins using "vim-plug", and adds a few extra bits of information to
" the stock statusline.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

scriptencoding utf-8
set encoding=utf-8

function! s:FzfFiles(abandon, command) abort
  let l:root = system('git rev-parse --show-toplevel 2>/dev/null')[:-2]

  if !a:abandon && getbufvar(bufname('%'), "&mod")
    echohl ErrorMsg
    echom "E37: No write since last change (add ! to override)"
    echohl None
    return
  endif

  return fzf#run(fzf#wrap(
    \ {
      \ 'dir': l:root,
      \ 'options': '--preview "cat {}" ' .
          \ (strlen(l:root) > 0 ? '--prompt="Project > "' : '--prompt="CD > "'),
      \ 'sink': a:abandon ? a:command . '!' : a:command,
      \ 'source': 'rg --files --hidden',
    \ })
  \ )
endfunction

function! GetCustomStatuslineFlags() abort
  let l:branch = filereadable(expand('%:p')) ? gitbranch#name() : ''
  let l:editorconfig = exists("b:editorconfig_applied") && b:editorconfig_applied
  let l:output = ''
  let l:ranger = $RANGER_LEVEL

  if l:editorconfig || strlen(l:branch) > 0 || strlen(l:ranger)
    let l:output = ' ['
    let l:output .= l:editorconfig ? 'editorconfig:✔' : ''
    let l:output .= l:editorconfig && (strlen(l:branch) > 0 || strlen(l:ranger)) ? ',' : ''
    let l:output .= strlen(l:branch) > 0 ? 'git:' . l:branch : ''
    let l:output .= strlen(l:ranger) && (l:editorconfig || strlen(l:branch) > 0) ? ',' : ''
    let l:output .= strlen(l:ranger) > 0 ? 'ranger:✔' : ''
    let l:output .= ']'
  endif

  return l:output
endfunction

" Improves Vim-in-tmux colour-related funkiness (for more information,
" see <https://unix.stackexchange.com/q/348771>). This doesn't work all
" the time; Vim will still sometimes set the wrong value for the
" "background" option during Git rebasing.
if exists('$TMUX')
  let &t_RB = "\ePtmux;\e\e]11;?\007\e\\"
endif

source $VIMRUNTIME/defaults.vim

set colorcolumn=72,78
set laststatus=2
set number
set t_vb=
set visualbell

if has('mouse')
  set mouse=a
endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/vim-plug/')
Plug 'editorconfig/editorconfig-vim'
Plug 'itchyny/vim-gitbranch'
Plug 'junegunn/fzf'
call plug#end()

" This emulates the standard statusline based on the example from
" ":h statusline", and adds a few extra flags (see the implementation of
" "GetCustomStatuslineFlags" above).
set statusline=%<%f%{GetCustomStatuslineFlags()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P

command! -bang GB call s:FzfFiles(<bang>0, 'e')
command! -bang GV call s:FzfFiles(<bang>0, 'vsplit')

if filereadable($HOME . '/.machine.vimrc')
  source ~/.machine.vimrc
endif
