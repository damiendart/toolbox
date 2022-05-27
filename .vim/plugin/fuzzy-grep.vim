" A basic fzf-powered grep doohickey.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

function s:FuzzyGrep(abandon, query) abort
  function! s:FzfGrepHandler(abandon, lines) abort
    function! s:RgToQuickfix(line)
      let l:parts = split(a:line, ':')

      return {
        \ 'filename': parts[0],
        \ 'lnum': parts[1],
        \ 'col': parts[2],
        \ 'text': join(parts[3:], ':'),
      \ }
    endfunction

    if len(a:lines) < 2
      return
    endif

    let l:command = get(
      \ { 'ctrl-t': 'tabe', 'ctrl-v': 'vsplit', 'ctrl-x': 'split' },
      \ a:lines[0],
      \ 'e' . (a:abandon ? '!' : '')
    \ )
    let l:results = map(a:lines[1:], 's:RgToQuickfix(v:val)')

    execute l:command escape(l:results[0].filename, ' %#\')
    execute l:results[0].lnum
    execute 'normal!' l:results[0].col . '|zz'

    if len(l:results) > 1
      call setqflist(l:results)
      copen
      wincmd p
    endif
  endfunction

  if !a:abandon && getbufvar(bufname('%'), "&mod")
    echohl ErrorMsg
    echom "E37: No write since last change (add ! to override)"
    echohl None
    return
  endif

  let l:gitRoot = system('git rev-parse --show-toplevel 2>/dev/null')[:-2]
  let l:rgCommand = 'rg --hidden --glob=''!.git/objects'' --column --line-number --color=always --smart-case -- %s || true'
  let l:root = strlen(l:gitRoot) > 0 ? l:gitRoot : getcwd()

  call fzf#run(
    \ fzf#wrap(
      \ {
        \ 'dir': l:root,
        \ 'options': '--ansi --bind=ctrl-a:select-all,ctrl-d:deselect-all,ctrl-z:abort'
          \ . ' --bind "change:reload:sleep 0.05;' . printf(l:rgCommand, '{q}') . '"'
          \ . ' --disabled --delimiter=":" --expect=ctrl-t,ctrl-v,ctrl-x --multi'
          \ . ' --preview="(bat --color=always --style=plain {1} --highlight-line {2} || cat {1}) 2>/dev/null"'
          \ . ' --preview-window=''+{2}/3'' --prompt="(' . pathshorten(l:root) . ') > "'
          \ . ' --query=''' . shellescape(a:query) . '''',
        \ 'sink*': function('s:FzfGrepHandler', [a:abandon]),
        \ 'source': printf(l:rgCommand, shellescape(a:query)),
      \ }
    \ )
  \ )
endfunction

command! -nargs=* -complete=dir -bang FG call s:FuzzyGrep(<bang>0, <q-args>)
