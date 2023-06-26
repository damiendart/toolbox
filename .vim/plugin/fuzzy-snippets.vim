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

let g:fuzzy_snippets_source_command = 'fuzzy-snippets --list'
let g:loaded_fuzzy_snippets = 1

function! s:FuzzySnippets() abort
  if !executable('fuzzy-snippets') || !exists('g:loaded_fzf')
    throw 'FuzzySnippets requires fzf, fzf.vim, and fuzzy-snippets'
  elseif !exists('$SNIPPET_PATH')
    throw 'SNIPPET_PATH environment variable not set'
  endif

  let l:spec = copy(g:fzf_base_spec)

  call extend(
    \ l:spec,
    \ {
      \ 'options': [
        \ '--delimiter', '/',
        \ '--preview', g:fzf_preview_command,
        \ '--prompt', '--8<-- ',
        \ '--with-nth', '-1',
      \ ],
      \ 'sink': 'r',
      \ 'source': g:fuzzy_snippets_source_command,
    \ }
  \ )
  call fzf#run(l:spec)
endfunction

command! FS call s:FuzzySnippets()
