" Stuff to make browsing/editing Markdown notes a little easier.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

if exists('b:loaded')
  finish
endif

let b:loaded = 1

if exists('$NOTES_ROOT')
  let s:path = expand('%:p')

  if empty(s:path) || !filereadable(s:path)
    let s:path = getcwd()
  endif

  if s:path =~ '^' . expand('$NOTES_ROOT')
    " Add support for links to other notes when using "gf" and friends.
    execute 'setlocal path+=' . s:path
    setlocal suffixesadd+=.markdown,.md
  endif
endif
