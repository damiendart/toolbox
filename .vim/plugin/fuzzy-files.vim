" A basic fzf-powered file picker.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

function! s:FuzzyFiles(abandon, dir) abort
  if !a:abandon && getbufvar(bufname('%'), "&mod")
    echohl ErrorMsg
    echom "E37: No write since last change (add ! to override)"
    echohl None
    return
  endif

  if (strlen(a:dir) > 0)
    let l:root = fnamemodify(a:dir, ':p')[:-2]
  else
    let l:gitRoot = system('git rev-parse --show-toplevel 2>/dev/null')[:-2]
    let l:root = strlen(l:gitRoot) > 0 ? l:gitRoot : getcwd()
  endif

  let l:prompt = pathshorten(l:root)
  let l:prompt .= ((has('win32') || has('win64')) && !&shellslash) ? '\' : '/'

  call fzf#run(
    \ fzf#wrap(
      \ {
        \ 'dir': l:root,
        \ 'options': '--bind=ctrl-a:select-all,ctrl-d:deselect-all,ctrl-z:abort'
          \ . ' --expect=ctrl-t,ctrl-v,ctrl-x --multi'
          \ . ' --preview "(bat --color=always --style=plain {} || cat {}) 2>/dev/null" '
          \ . ' --prompt="' . l:prompt . '"',
        \ 'sink*': function('s:FuzzyFilesHandler', [a:abandon]),
        \ 'source': 'rg --files --hidden --glob="!.git/objects"',
      \ }
    \ )
  \ )
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

  for line in a:lines[1:]
    execute l:command line
  endfor
endfunction

command! -nargs=? -complete=dir -bang FF call s:FuzzyFiles(<bang>0, <q-args>)
command! -nargs=? -complete=dir -bang FZF call s:FuzzyFiles(<bang>0, <q-args>)
