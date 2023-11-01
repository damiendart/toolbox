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

" The following WikiLinks syntax highlighting gubbins is based on
" <https://www.vim.org/scripts/script.php?script_id=3156>, with tweaks
" to support both the "[[standard-wikilink|standard style]]" and
" the "[[bare-wikilink]]" style.
if exists('b:enable_wikilinks_syntax')
  syntax region markdownWikiLink start=+\[\[+ end=+\]\]+
    \ contains=markdownWikiLinkSeparator,markdownWikiLinkUrl,markdownWikiLinkText

  syntax match markdownWikiLinkSeparator !|! contained nextgroup=markdownWikiLinkText
  syntax match markdownWikiLinkText !\(\w\|[ -/#.]\)\+! contained
  syntax match markdownWikiLinkUrl !\[\[\zs\_[^\]|]\+\ze|\?! contained nextgroup=markdownWikiLinkSeparator

  highlight def link markdownWikiLinkUrl Identifier
  highlight def link markdownWikiLinkText htmlLink
endif

if exists('b:enable_tags_highlighting')
  " Note: if updating the following regular expressions, the regular
  " expression used to match tags in <https://github.com/damiendart/nt>
  " may also require updating.
  syntax match tag ![ ']#[a-zA-Z/:-]\+!hs=s+1
  syntax match tag !^#[a-zA-Z/:-]\+!
  highlight link tag Statement
endif
