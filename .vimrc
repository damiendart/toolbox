" Damien Dart's ".vimrc".
"
" An unremarkable Vim configuration file: it imports the default
" settings, adds a few nice-to-have plugins using vim-plug, and tweaks
" the stock statusline to add a few extra pieces of information.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

scriptencoding utf-8
set encoding=utf-8

function! s:CheckForEditorConfigInvocation() abort
  if !filereadable(expand('%:p'))
      \ || (exists("b:EditorConfig_disable") && b:EditorConfig_disable)
    return
  endif

  let l:path = expand('%:p')

  " This check that follows is a bit basic (for example, it doesn't
  " account for cases where a ".editorconfig" exists but none of the
  " rules match) but it's generally good enough. A more robust version
  " of this check is being considered for the "editorconfig-vim" plugin:
  " <https://github.com/editorconfig/editorconfig-vim/issues/141>.
  while l:path != '/'
    if filereadable(l:path . '/.editorconfig')
      let b:EditorConfig_invoked = 1
      break
    endif

    let l:path = fnamemodify(l:path, ':h')
  endwhile
endfunction

function! s:CustomFZFGitTrackedFiles(fullscreen) abort
  let l:root = split(system('git rev-parse --show-toplevel'), '\n')[0]

  if v:shell_error || l:root
    echohl WarningMsg
    echom "Cannot locate Git repository!"
    echohl None
    return
  endif

  return fzf#run(fzf#wrap(
    \ {
      \ 'options': '--preview "cat {}"',
      \ 'source': 'git ls-files | uniq',
      \ 'root': l:root,
      \ 'sink': 'e'
    \ },
    \ a:fullscreen)
  \ )
endfunction

function! GetCustomStatuslineFlags() abort
  let l:branch = filereadable(expand('%:p')) ? gitbranch#name() : ''
  let l:editorconfig = exists("b:EditorConfig_invoked") && b:EditorConfig_invoked
  let l:output = ''

  if strlen(l:branch) > 0 || l:editorconfig
    let l:output = ' ['
    let l:output .= strlen(l:branch) > 0 ? 'git:' . l:branch : ''
    let l:output .= strlen(l:branch) > 0 && l:editorconfig ? ',' : ''
    let l:output .= l:editorconfig ? 'editorconfig:✔' : ''
    let l:output .= ']'
  endif

  return l:output
endfunction

source $VIMRUNTIME/defaults.vim

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

" This statusline emulates the standard status line
" (based on the example from ":h statusline") and adds a few extra
" flags (see the implementation of "GetCustomStatuslineFlags" above).
set statusline=%<%f%{GetCustomStatuslineFlags()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P

autocmd BufNewFile,BufReadPost,BufFilePost * call s:CheckForEditorConfigInvocation()

command! -bang GB call s:CustomFZFGitTrackedFiles(<bang>0)
