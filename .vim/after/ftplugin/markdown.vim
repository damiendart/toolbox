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

    " If updating the following regular expression, the tag-matching
    " regular expressions in "$HOME/.vim/after/syntax/markdown.vim" and
    " <https://github.com/damiendart/nt> may also require updating.
    while l:start > 0 && l:currentLine[l:start - 1] =~ '[a-zA-Z0-9/:_-]'
      let l:start -= 1
    endwhile

    return l:start
  endif

  let l:results = []
  let l:tags = split(system('nt tags'))

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
  " The double-escaping is required so that directory paths containing
  " spaces are handled correctly (for more information, search for
  " "option-backslash" in Vim's help).
  execute 'setlocal path+=' . fnameescape(fnameescape(s:notesRoot))

  setlocal completefunc=CompleteTags
  setlocal linebreak
  setlocal suffixesadd+=.markdown,.md

  if has('patch-8.2.3198')
    setlocal breakindent
    setlocal briopt+=list:-1
    " The following formatting regular expressions are based on those at
    " <https://vimways.org/2018/formatting-lists-with-vim/>, with
    " additions and tweaks to support blockquotes, GitHub Flavoured
    " Markdown task list items, and quoted lists.
    setlocal formatlistpat=^>\\s\\+
    setlocal formatlistpat+=\\\|^\\s*[\\[({]\\?\\([0-9]\\+\\\|[a-zA-Z]\\+\\)[\\]:.)}]\\s\\+
    setlocal formatlistpat+=\\\|^>\\s*[\\[({]\\?\\([0-9]\\+\\\|[a-zA-Z]\\+\\)[\\]:.)}]\\s\\+
    setlocal formatlistpat+=\\\|^\\s*[-–+o*]\\s\\[[\ -x]\\]\\s\\+
    setlocal formatlistpat+=\\\|^>\\s*[-–+o*]\\s\\[[\ -x]\\]\\s\\+
    setlocal formatlistpat+=\\\|^\\s*[-–+o*]\\s\\+
    setlocal formatlistpat+=\\\|^>\\s*[-–+o*]\\s\\+
  endif

  let b:enable_wikilinks_syntax = 1
  let b:enable_tags_highlighting = 1
endif
