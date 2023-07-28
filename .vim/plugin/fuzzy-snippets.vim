" A Vim-orientated version of "$TOOLBOX_ROOT/bin/fuzzy-snippets".
"
" See the fzf prompt header for available actions.
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
  if !executable('fuzzy-snippets') || !executable('snippet-placeholder') || !exists('g:loaded_fzf')
    throw 'FuzzySnippets requires fzf, fzf.vim, fuzzy-snippets, and snippet-placeholder'
  elseif !exists('$SNIPPET_PATH')
    throw 'SNIPPET_PATH environment variable not set'
  endif

  let l:spec = copy(g:fzf_base_spec)

  call extend(
    \ l:spec,
    \ {
      \ 'options': [
        \ '--delimiter', '/',
        \ '--expect', 'ctrl-y',
        \ '--preview', g:fzf_preview_command,
        \ '--header', 'CTRL+Y: yank ╱ ENTER: append',
        \ '--prompt', '--8<-- ',
        \ '--with-nth', '-1',
      \ ],
      \ 'sink*': function('s:FuzzySnippetsHandler'),
      \ 'source': g:fuzzy_snippets_source_command,
    \ }
  \ )
  call fzf#run(l:spec)
endfunction

function! s:FuzzySnippetsHandler(lines) abort
  let l:output = system(
    \ 'snippet-placeholder',
    \ join(readfile(a:lines[1]), "\n")
  \)

  if v:shell_error
    echoerr l:output

    return
  endif

  if a:lines[0] ==? 'ctrl-y'
    let @" = l:output

    return
  endif

  execute "normal! a" . l:output . "\<Esc>"
endfunction

command! FS call s:FuzzySnippets()
