" A simple fzf-powered interactive grep/ripgrep doohickey.
"
" For more information, see "$TOOLBOX_ROOT/.vim/doc/toolbox.txt" (or
" search for "toolbox-fuzzy" using Vim's help functionality if the help
" tags file for "toolbox.txt" has been generated).
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

if exists('g:loaded_fuzzy_grep')
  finish
endif

let g:fuzzy_grep_source_command = 'rg --color=always --column --hidden --line-number --smart-case %s -- %s || true'
let g:loaded_fuzzy_grep = 1

function! s:FuzzyGrep(abandon, options, prompt_embellishment, ...) abort
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
        \ '--ansi',
        \ '--bind', 'ctrl-a:select-all,ctrl-d:deselect-all,ctrl-z:abort',
        \ '--bind', 'change:reload:sleep 0.05;' . printf(g:fuzzy_grep_source_command, a:options, '{q}'),
        \ '--border-label', 'Press F1 for help',
        \ '--border-label-pos', '-3:bottom',
        \ '--disabled',
        \ '--delimiter', ':',
        \ '--expect', 'ctrl-t,ctrl-v,ctrl-x,f1',
        \ '--info=inline-right',
        \ '--multi',
        \ '--preview', g:fzf_preview_line_command,
        \ '--preview-window', '+{2}/3',
        \ '--prompt', '(' . pathshorten(l:spec.dir) . ')' . a:prompt_embellishment . ' ',
        \ '--query', l:query,
      \ ],
      \ 'sink*': function('s:FuzzyGrepHandler', [a:abandon]),
      \ 'source': printf(g:fuzzy_grep_source_command, a:options, shellescape(l:query)),
    \ }
  \ )

  try
    call fzf#run(l:spec)
  " Improve the appearance of some commonly-encountered errors.
  catch /E11/
    echohl ErrorMsg
    echom join(split(v:exception, ':')[1:2], ':')
    echohl None
    return
  endtry
endfunction

function! s:FuzzyGrepHandler(abandon, lines) abort
  if len(a:lines) < 2
    return
  endif

  if a:lines[0] ==? 'f1'
    execute "h :FG"
    return
  endif

  let l:command = get(
    \ { 'ctrl-t': 'tabe', 'ctrl-v': 'vsplit', 'ctrl-x': 'split' },
    \ a:lines[0],
    \ 'e' . (a:abandon ? '!' : '')
  \ )

  let l:results = map(a:lines[1:], 's:ToQuickfix(v:val)')

  try
    execute l:command fnameescape(l:results[0].filename)
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

function! s:FuzzyGrepSelection(visualmode, command)
  " "getreginfo" is the preferred function to use when saving and
  " restoring registers. See <https://github.com/vim/vim/issues/2345>
  " and <https://vi.stackexchange.com/a/26272> for more information.
  let l:register = has('patch-8.2.0924')
    \? getreginfo('"')
    \: ['"', getreg('"', 1, 1), getregtype('"')]

  try
    if a:visualmode == 'v'
      normal! gvy
    else
      call setreg('"', expand('<cword>'))
    endif

    " Prevent special characters expansion (see "cmdline-special" in
    " Vim's documentation) as it's more of an annoyance when using
    " a selection as the initial query.
    execute ":" . a:command fnameescape(join(getreg('"', 1, 1), ""))
  catch /^Vim:Interrupt$/
  finally
    if type(l:register) == type({})
      call setreg('"', l:register)
    else
      call call('setreg', l:register)
    endif
  endtry
endfunction

command! -nargs=* -complete=dir -bang FG call s:FuzzyGrep(<bang>0, '--glob="!.git/"', '', <f-args>)
command! -nargs=* -complete=dir -bang FGA call s:FuzzyGrep(<bang>0, '--no-ignore', '*', <f-args>)

nnoremap <silent> <leader>fa :<C-U>call <SID>FuzzyGrepSelection('n', 'FGA')<CR>
vnoremap <silent> <leader>fa :<C-U>call <SID>FuzzyGrepSelection('v', 'FGA')<CR>
nnoremap <silent> <leader>fg :<C-U>call <SID>FuzzyGrepSelection('n', 'FG')<CR>
vnoremap <silent> <leader>fg :<C-U>call <SID>FuzzyGrepSelection('v', 'FG')<CR>
