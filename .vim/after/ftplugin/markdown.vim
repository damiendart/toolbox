" Stuff to make browsing/editing Markdown notes a little easier.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

if exists('b:loaded') || !exists('$NOTES_ROOT')
  finish
endif

function! CompleteTags(findStart, base) abort
  if a:findStart
    let l:currentLine = getline('.')
    let l:start = col('.') - 1

    while l:start > 0 && l:currentLine[l:start - 1] =~ '[a-zA-Z0-9_\-\:]'
      let l:start -= 1
    endwhile

    return l:start
  endif

  let l:results = []
  let l:tags = split(system('notes tags'))

  for l:tag in l:tags
      if l:tag =~ '^' . a:base
          call add(l:results, l:tag)
      endif
  endfor

  return results
endfun

let b:loaded = 1

let s:notesRoot = fnamemodify($NOTES_ROOT, ':p')
let s:path = empty(expand('%:p')) ? getcwd() : expand('%:p')

if s:path =~ '^' . s:notesRoot
  " Add support for links to other notes when using "gf" and friends.
  execute 'setlocal path+=' . fnameescape(s:notesRoot)

  setlocal completefunc=CompleteTags
  setlocal suffixesadd+=.markdown,.md

  let b:enable_wikilinks_syntax = 1
endif
