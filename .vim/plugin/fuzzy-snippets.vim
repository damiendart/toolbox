" A basic fzf-powered snippet doohickey.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

function s:FuzzySnippets() abort
  call fzf#run(
    \ fzf#wrap(
      \ {
        \ 'dir': '$SNIPPET_LIBRARY_ROOT',
        \ 'options': '--bind=ctrl-z:abort'
          \ . ' --preview "(bat --color=always --style=plain {} || cat {}) 2>/dev/null" '
          \ . ' --prompt="--8<-- > "',
        \ 'sink': '0r',
        \ 'source': 'rg --files --hidden --glob="!.git/"',
      \ }
    \ )
  \ )
endfunction

command! FS call s:FuzzySnippets()
