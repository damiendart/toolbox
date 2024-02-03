" A simple fzf-powered file browser and selector.
"
" - By default, the search will start from the current working
"   directory. If the current working directory is within a Git
"   repository, the search will instead start from the repository root.
" - Ignore files (e.g. ".gitignore") in the search root directory are
"   respected.
" - The bang modifier works in a similar fashion to when using it with
"   the ":edit" command: it forces the editing of files even when there
"   are are changes to the current buffer.
" - See the fzf prompt header for available actions.
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
        \ '--expect', 'ctrl-t,ctrl-v,ctrl-x,ctrl-y',
        \ '--header', 'CTRL+T: tabe ╱ CTRL+V: vsplit ╱ CTRL+X: split ╱ CTRL+Y: yank filenames ╱ ENTER: edit',
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

  let l:command = get(
    \ { 'ctrl-t': 'tabe', 'ctrl-v': 'vsplit', 'ctrl-x': 'split', 'ctrl-y': 'yank-filenames' },
    \ a:lines[0],
    \ 'e' . (a:abandon ? '!' : '')
  \ )

  try
    if l:command ==? 'yank-filenames'
      let @" = join(a:lines[1:], "\n")
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
  endtry
endfunction

command! -nargs=* -complete=dir -bang FF call s:FuzzyFiles(<bang>0, <f-args>)
