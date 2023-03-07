" A simple fzf-powered interactive grep/ripgrep doohickey.
"
" The ":FG" command will respect any ignore files (e.g. ".gitignore") in
" the root directory, while the ":FGA" command will search every file.
"
" The following provides similar functionality to the ":Rg" command
" from <https://github.com/junegunn/fzf.vim>, but with a few tweaks:
"
" - Changing the query string will rerun ripgrep instead of filtering
"   the initial input.
" - FuzzyGrep is Git-aware: if the current working directory is within a
"   Git repository, FuzzyGrep will automatically run ripgrep from the
"   repository root directory.
" - Using the bang modifier forces the editing of files even when there
"   are are changes to the current buffer. (The ":Rg" command uses the
"   bang modifier to start fzf in fullscreen mode instead.)
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

if exists('g:loaded_fuzzy_grep')
  finish
endif

let g:fuzzy_grep_source_command = 'rg --color=always --column --hidden --line-number --smart-case %s -- %s || true'
let g:loaded_fuzzy_grep = 1

function! s:FuzzyGrep(abandon, options, ...) abort
  if !executable('fzf') || !executable('rg') || !executable('git') || !exists('g:loaded_fzf')
    throw 'FuzzyGrep requires fzf, fzf.vim, Git, and ripgrep'
  endif

  let l:arguments = copy(a:000)
  let l:gitRoot = system('git rev-parse --show-toplevel 2>/dev/null')[:-2]
  let l:query = len(l:arguments) > 0 ? join(l:arguments, ' ') : ''
  let l:spec = copy(g:fzf_base_spec)

  call extend(l:spec, { 'dir': strlen(l:gitRoot) > 1 ? l:gitRoot : getcwd() })
  call extend(
    \ l:spec,
    \ {
      \ 'options': [
        \ '--ansi', '--bind',
        \ 'ctrl-a:select-all,ctrl-d:deselect-all,ctrl-z:abort','--bind',
        \ 'change:reload:sleep 0.05;' . printf(g:fuzzy_grep_source_command, a:options, '{q}'),
        \ '--disabled', '--delimiter', ':', '--expect',
        \ 'ctrl-t,ctrl-v,ctrl-x', '--header',
        \ 'CTRL+T: tabe ╱ CTRL+V: vsplit ╱ CTRL+X: split ╱ ENTER: edit',
        \ '--multi', '--preview', g:fzf_preview_line_command,
        \'--preview-window', '+{2}/3', '--prompt',
        \'(' . pathshorten(l:spec.dir) . ') > ', '--query', l:query,
      \ ],
      \ 'sink*': function('s:FuzzyGrepHandler', [a:abandon]),
      \ 'source': printf(g:fuzzy_grep_source_command, a:options, shellescape(l:query)),
    \ }
  \ )
  call fzf#run(l:spec)
endfunction

function! s:FuzzyGrepHandler(abandon, lines) abort
  if len(a:lines) < 2
    return
  endif

  let l:command = get(
    \ { 'ctrl-t': 'tabe', 'ctrl-v': 'vsplit', 'ctrl-x': 'split' },
    \ a:lines[0],
    \ 'e' . (a:abandon ? '!' : '')
  \ )

  let l:results = map(a:lines[1:], 's:ToQuickfix(v:val)')

  try
    execute l:command escape(l:results[0].filename, ' %#\')
  " Improve the appearance of some commonly-encountered errors.
  catch /E37/
    echohl ErrorMsg
    echom join(split(v:exception, ':')[1:], ':')
    echohl None
    return
  endtry

  execute l:results[0].lnum
  execute 'normal!' l:results[0].col . '|zz'

  if len(l:results) > 1
    call setqflist(l:results)
    copen
    wincmd p
  endif
endfunction

function! s:ToQuickfix(line)
  let l:parts = split(a:line, ':')

  return {
    \ 'filename': parts[0],
    \ 'lnum': parts[1],
    \ 'col': parts[2],
    \ 'text': join(parts[3:], ':'),
  \ }
endfunction

command! -nargs=* -complete=dir -bang FG call s:FuzzyGrep(<bang>0, '--glob="!.git/"', <f-args>)
command! -nargs=* -complete=dir -bang FGA call s:FuzzyGrep(<bang>0, '--no-ignore', <f-args>)
