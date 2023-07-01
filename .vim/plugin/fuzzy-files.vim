" A simple fzf-powered file browser and selector.
"
" The following provides similar functionality to the ":FZF" command
" provided by fzf.vim, but with a few tweaks:
"
" - FuzzyFiles is Git-aware: if no directory is specified and the
"   current working directory is within a Git repository, FuzzyFiles
"   will automatically search from the repository root directory.
" - Using the bang modifier forces the editing of files even when there
"   are are changes to the current buffer. (The ":FZF" command uses the
"   bang modifier to start fzf in fullscreen mode instead.)
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
        \ '--expect', 'ctrl-t,ctrl-v,ctrl-x',
        \ '--header', 'CTRL+T: tabe ╱ CTRL+V: vsplit ╱ CTRL+X: split ╱ ENTER: edit',
        \ '--multi',
        \ '--preview', g:fzf_preview_command,
        \ '--prompt', pathshorten(l:spec.dir) . (((has('win32') || has('win64')) && !&shellslash) ? '\' : '/'),
        \ '--query', l:query,
      \ ],
      \ 'sink*': function('s:FuzzyFilesHandler', [a:abandon]),
      \ 'source': g:fuzzy_files_source_command,
    \ },
  \ )
  call fzf#run(l:spec)
endfunction

function! s:FuzzyFilesHandler(abandon, lines) abort
  if len(a:lines) < 1
    return
  endif

  let l:command = get(
    \ { 'ctrl-t': 'tabe', 'ctrl-v': 'vsplit', 'ctrl-x': 'split' },
    \ a:lines[0],
    \ 'e' . (a:abandon ? '!' : '')
  \ )

  try
    for line in a:lines[1:]
      execute l:command fnameescape(line)
    endfor
  " Improve the appearance of some commonly-encountered errors.
  catch /E37/
    echohl ErrorMsg
    echom join(split(v:exception, ':')[1:], ':')
    echohl None
    return
  endtry
endfunction

command! -nargs=* -complete=dir -bang FF call s:FuzzyFiles(<bang>0, <f-args>)
