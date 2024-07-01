" A simple fzf-powered file browser and selector.
"
" For more information, see "$TOOLBOX_ROOT/.vim/doc/toolbox.txt" (or
" search for "toolbox-fuzzy" using Vim's help functionality if the help
" tags file for "toolbox.txt" has been generated).
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

if exists('g:loaded_fuzzy_files')
  finish
endif

let g:fuzzy_files_source_command = 'rg --files --hidden --glob="!.git/"'
let g:loaded_fuzzy_files = 1

function! s:FuzzyFiles(abandon, ...) abort
  if !executable('fzf') || !executable('rg') || !executable('git') || !exists('g:loaded_fzf')
    throw 'FuzzyFiles requires fzf, fzf.vim, Git, and ripgrep'
  endif

  let l:arguments = copy(a:000)
  let l:query = ''
  let l:spec = copy(g:fzf_base_spec)

  if len(l:arguments) > 0 && isdirectory(expand(l:arguments[-1]))
    call extend(l:spec, { 'dir': fnamemodify(remove(l:arguments, -1), ':p')[:-2] })
  else
    let l:gitRoot = system('git rev-parse --show-toplevel 2>/dev/null')[:-2]
    let l:query = len(l:arguments) > 0 ? join(l:arguments, ' ') : ''

    call extend(l:spec, { 'dir': strlen(l:gitRoot) > 1 ? l:gitRoot : getcwd() })
  endif

  call extend(
    \ l:spec,
    \ {
      \ 'options': [
        \ '--bind', 'ctrl-a:select-all,ctrl-d:deselect-all,ctrl-z:abort',
        \ '--border-label', 'Press F1 for help',
        \ '--border-label-pos', '-3:bottom',
        \ '--expect', 'ctrl-t,ctrl-v,ctrl-x,ctrl-y,f1',
        \ '--info=inline-right',
        \ '--multi',
        \ '--preview', g:fzf_preview_command,
        \ '--prompt', pathshorten(l:spec.dir) . (((has('win32') || has('win64')) && !&shellslash) ? '\' : '/'),
        \ '--query', l:query,
        \ '--scheme', 'path',
      \ ],
      \ 'sink*': function('s:FuzzyFilesHandler', [a:abandon]),
      \ 'source': g:fuzzy_files_source_command,
    \ },
  \ )

  try
    call fzf#run(l:spec)
  " Improve the appearance of some commonly-encountered errors.
  catch /E11/
    echohl ErrorMsg
    echom join(split(v:exception, ':')[1:2], ':')
    echohl None
    return
  endtry
endfunction

function! s:FuzzyFilesHandler(abandon, lines) abort
  if len(a:lines) < 1
    return
  endif

  if a:lines[0] ==? 'f1'
    execute "h :FF"
    return
  endif

  let l:command = get(
    \ { 'ctrl-t': 'tabe', 'ctrl-v': 'vsplit', 'ctrl-x': 'split', 'ctrl-y': 'yank-filenames' },
    \ a:lines[0],
    \ 'e' . (a:abandon ? '!' : '')
  \ )

  try
    if l:command ==? 'yank-filenames'
      call setreg('"', join(a:lines[1:], "\n"))
    else
      for line in a:lines[1:]
        execute l:command fnameescape(line)
      endfor
    endif
  " Improve the appearance of some commonly-encountered errors.
  catch /E37/
    echohl ErrorMsg
    echom join(split(v:exception, ':')[1:], ':')
    echohl None
    return
  catch /^Vim:Interrupt$/
  endtry
endfunction

command! -nargs=* -complete=dir -bang FF call s:FuzzyFiles(<bang>0, <f-args>)
