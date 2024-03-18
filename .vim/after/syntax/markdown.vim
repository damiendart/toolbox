" A few Markdown syntax highlighting tweaks.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

" Backport a change to how indented code blocks are detected. For more
" information, see <https://github.com/tpope/vim-markdown/commit/feadbc81e27f277187c29957ec6114f1e95f2162>.
if !has('patch-9.0.0772')
  syntax clear markdownCodeBlock
  syntax region markdownCodeBlock start="^\n\( \{4,}\|\t\)" end="^\ze \{,3}\S.*$" keepend
endif

" The following wikilink syntax highlighting gubbins is based on
" <https://www.vim.org/scripts/script.php?script_id=3156>, with tweaks
" to support both the "[[standard-wikilink|standard style]]" and
" the "[[bare-wikilink]]" style.
if exists('b:enable_wikilinks_syntax')
  syntax region markdownWikilink start=+\[\[+ end=+\]\]+
    \ contains=markdownWikilinkSeparator,markdownWikilinkUrl,markdownWikilinkText
    \ keepend
    \ oneline

  syntax match markdownWikilinkSeparator !|! contained nextgroup=markdownWikilinkText
  syntax match markdownWikilinkText !\(\w\|[ -/#.]\)\+! contained
  syntax match markdownWikilinkURL !\[\[\zs\_[^\]|]\+\ze|\?! contained nextgroup=markdownWikilinkSeparator

  highlight def link markdownWikilinkURL Identifier
  highlight def link markdownWikilinkText htmlLink
endif

if exists('b:enable_tags_highlighting')
  syntax match markdownHashtag ~^#[0-9/:_-]*\a\%(\w\|[/:-]\)*\ze\%(\_s\|["')]\)~
  syntax match markdownHashtag ~^#[0-9/:_-]*\a\%(\w\|[/:-]\)\{-}\ze:\+\%(\_s\|["')]\)~
  syntax match markdownHashtag ~\%(\s\|["'(]\)#[0-9/:_-]*\a\%(\w\|[/:-]\)*\ze\%(\_s\|["')]\)~hs=s+1
  syntax match markdownHashtag ~\%(\s\|["'(]\)#[0-9/:_-]*\a\%(\w\|[/:-]\)\{-}\ze:\+\%(\_s\|["')]\)~hs=s+1

  highlight link markdownHashtag Statement
endif
