" A simple fzf-powered file browser and selector.
"
" The following provides similar functionality to the ":FZF" command
" provided by fzf.vim, but with a few tweaks:
"
" - Using the bang modifier forces the editing of files even when there
"   are are changes to the current buffer. (The ":FZF" command uses the
"   bang modifier to start fzf in fullscreen mode.)
" - FuzzyFiles is Git-aware: if no directory is specified and the
"   current working directory is within a Git repository, FuzzyFiles
"   will automatically search from the repository root directory.
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
  let l:spec = copy(g:fzf_base_spec)

  if len(l:arguments) > 0 && isdirectory(expand(l:arguments[-1]))
    call extend(l:spec, { 'dir': fnamemodify(remove(l:arguments, -1), ':p')[:-2] })
  else
    let l:gitRoot = system('git rev-parse --show-toplevel 2>/dev/null')[:-2]

    call extend(l:spec, { 'dir': strlen(l:gitRoot) > 1 ? l:gitRoot : getcwd() })
  endif

  call extend(
    \ l:spec,
    \ {
      \ 'options': [
        \ '--bind', 'ctrl-a:select-all,ctrl-d:deselect-all,ctrl-z:abort',
        \ '--expect', 'ctrl-t,ctrl-v,ctrl-x', '--multi',
        \ '--preview', g:fzf_preview_command, '--prompt',
        \ pathshorten(l:spec.dir) . (((has('win32') || has('win64')) && !&shellslash) ? '\' : '/')
      \ ],
      \ 'sink*': function('s:FuzzyFilesHandler', [a:abandon]),
      \ 'source': g:fuzzy_files_source_command,
    \ },
  \ )
  call extend(l:spec.options, l:arguments)
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

  " Handling the no-write-since-last-change error ourselves produces
  " a slightly better looking error message (otherwise you get a small
  " stack-track-looking thing).
  if l:command == 'e' && getbufvar(bufname('%'), '&mod')
    echohl ErrorMsg
    echom "E37: No write since last change (add ! to override)"
    echohl None
    return
  endif

  for line in a:lines[1:]
    execute l:command line
  endfor
endfunction

command! -nargs=* -complete=dir -bang FF call s:FuzzyFiles(<bang>0, <f-args>)
