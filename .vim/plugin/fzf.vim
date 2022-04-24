" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

function! s:FzfFiles(abandon, dir) abort
  function! s:FzfFilesHandler(abandon, lines) abort
    if len(a:lines) < 1
      return
    endif

    let l:command = get(
      \ { 'ctrl-t': 'tabe', 'ctrl-v': 'vsplit', 'ctrl-x': 'split' },
      \ a:lines[0],
      \ 'e' . (a:abandon ? '!' : '')
    \ )

    for line in a:lines[1:]
      execute l:command line
    endfor
  endfunction

  if !a:abandon && getbufvar(bufname('%'), "&mod")
    echohl ErrorMsg
    echom "E37: No write since last change (add ! to override)"
    echohl None
    return
  endif

  if (strlen(a:dir) > 0)
    let l:root = fnamemodify(a:dir, ':p')[:-2]
  else
    let l:gitRoot = system('git rev-parse --show-toplevel 2>/dev/null')[:-2]
    let l:root = strlen(l:gitRoot) > 0 ? l:gitRoot : getcwd()
  endif

  let l:prompt = pathshorten(l:root)
  let l:prompt .= ((has('win32') || has('win64')) && !&shellslash) ? '\' : '/'

  call fzf#run(
    \ fzf#wrap(
      \ {
        \ 'dir': l:root,
        \ 'options': '--bind=ctrl-a:select-all,ctrl-d:deselect-all,ctrl-z:abort'
          \ . ' --expect=ctrl-t,ctrl-v,ctrl-x --multi'
          \ . ' --preview "(bat --color=always --style=plain {} || cat {}) 2>/dev/null" '
          \ . ' --prompt="' . l:prompt . '"',
        \ 'sink*': function('s:FzfFilesHandler', [a:abandon]),
        \ 'source': 'rg --files --hidden --glob="!.git/objects"',
      \ }
    \ )
  \ )
endfunction

function s:FzfGrep(abandon, query) abort
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

command! -nargs=? -complete=dir -bang FF call s:FzfFiles(<bang>0, <q-args>)
command! -nargs=* -complete=dir -bang FG call s:FzfGrep(<bang>0, <q-args>)
command! -nargs=? -complete=dir -bang FZF call s:FzfFiles(<bang>0, <q-args>)

" Slightly improve the appearance of the the fuzzy finder by hiding
" some Vim things while active. Based on the snippet from
" <https://github.com/junegunn/fzf/blob/master/README-VIM.md#hide-statusline>
autocmd! FileType fzf
autocmd FileType fzf let b:laststatus = &laststatus
  \| set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set showmode ruler
  \| let &laststatus = b:laststatus
