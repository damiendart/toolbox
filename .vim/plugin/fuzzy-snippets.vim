" A Vim-orientated version of "$TOOLBOX_ROOT/bin/fuzzy-snippets".
"
" Selecting a snippet inserts it below the cursor.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

if exists('g:loaded_fuzzy_snippets')
  finish
endif

let g:fuzzy_snippets_source_command = 'rg --files --ignore-file="fuzzy-snippets.ignore" --sort=path'
let g:loaded_fuzzy_snippets = 1

function! s:FuzzySnippets() abort
  if !executable('fzf') || !executable('rg') || !exists('g:loaded_fzf')
    throw 'FuzzySnippets requires fzf, fzf.vim, and ripgrep'
  elseif !exists('$SNIPPET_LIBRARY_ROOT')
    throw 'SNIPPET_LIBRARY_ROOT environment variable not set'
  endif

  let l:spec = copy(g:fzf_base_spec)

  call extend(
    \ l:spec,
    \ {
      \ 'dir': '$SNIPPET_LIBRARY_ROOT',
      \ 'options': ['--preview', g:fzf_preview_command, '--prompt', '--8<-- '],
      \ 'sink': 'r',
      \ 'source': g:fuzzy_snippets_source_command,
    \ }
  \ )
  call fzf#run(l:spec)
endfunction

command! FS call s:FuzzySnippets()
