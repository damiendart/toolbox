" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

if exists('g:loaded_fuzzy_finders')
  finish
endif

let g:loaded_fuzzy_finders = 1

function! s:Fuzzy(command, select_cb) abort
  let l:callback = {
    \ 'select_cb': a:select_cb,
    \ 'filename': tempname(),
    \ 'window_id': win_getid(),
    \ 'winrestcmd': winrestcmd(),
  \ }

  function l:callback.exit_cb(...) abort
    call win_gotoid(l:self.window_id)
    execute l:self.winrestcmd

    if filereadable(l:self.filename)
      try
        call l:self.select_cb(readfile(l:self.filename))
      catch /^Vim:Interrupt$/
      " Improve the appearance of some commonly-encountered errors.
      catch /E11/
        echohl ErrorMsg
        echom join(split(v:exception, ':')[1:2], ':')
        echohl None
        return
      catch /E37/
        echohl ErrorMsg
        echom join(split(v:exception, ':')[1:], ':')
        echohl None
        return
      catch /E684/
      finally
        call delete(l:self.filename)
      endtry
    endif

    redraw!
  endfunction

  if exists('+splitkeep')
    let l:splitkeep = &splitkeep
    set splitkeep=screen
  endif

  try
    execute 'botright' 20 'new'

    call term_start(
      \ [
        \ &shell,
        \ &shellcmdflag,
        \ 'TERM=xterm-color256 ' . a:command . '>' . l:callback.filename
      \ ],
      \ {
        \ 'curwin': 1,
        \ 'cwd': getcwd(),
        \ 'exit_cb': l:callback.exit_cb,
        \ 'term_kill': 'term',
      \ }
    \ )

    setlocal nospell bufhidden=wipe nobuflisted nonumber
    setfiletype fuzzyfinder
    startinsert
  finally
    if exists('+splitkeep')
      let &splitkeep = l:splitkeep
    endif
  endtry
endfunction

function! s:FuzzyGrep(abandon, ...) abort
  function! Handler(abandon, input) closure
    if len(a:input) == 1 && a:input[0] ==? 'f1'
      execute 'h :FG'
      return
    endif

    if len(a:input) < 2
      return
    endif

    let l:command = get(
      \ { 'ctrl-t': 'tabe', 'ctrl-v': 'vsplit', 'ctrl-x': 'split' },
      \ a:input[0],
      \ 'e' . (a:abandon ? '!' : '')
    \ )

    let l:results = map(a:input[1:], 's:ToQuickfix(v:val)')

    execute l:command fnameescape(l:results[0].filename)
    execute l:results[0].lnum
    execute 'normal!' l:results[0].col . '|zz'

    if len(l:results) > 1
      call setqflist(l:results)
      copen
      wincmd p
    endif
  endfunction

  let l:arguments = copy(a:000)
  let l:query = len(l:arguments) > 0 ? join(l:arguments, ' ') : ''

  call s:Fuzzy('fuzzy-grep --vim -- ' . shellescape(l:query), funcref('Handler', [a:abandon]))
endfunction

function! s:FuzzyGrepSelection(visualmode)
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
    execute ":FG" fnameescape(join(getreg('"', 1, 1), ""))
  finally
    if type(l:register) == type({})
      call setreg('"', l:register)
    else
      call call('setreg', l:register)
    endif
  endtry
endfunction

function! s:FuzzySnippets(...) abort
  function! Handler(input) closure
    if a:input[0] ==? 'f1'
      execute 'h :FS'

      return
    endif

    let l:output = join(a:input[1:], "\n")

    if len(l:output) == 0
      return
    endif

    if a:input[0] ==? 'ctrl-y'
      call setreg('"', l:output)

      return
    endif

    try
      let l:paste = &paste

      set paste
      execute 'normal! a' . l:output . "\<Esc>"
    finally
      let &paste = l:paste
    endtry
  endfunction

  let l:arguments = copy(a:000)
  let l:query = len(l:arguments) > 0 ? join(l:arguments, ' ') : ''

  call s:Fuzzy('fuzzy-snippets --vim -- ' . shellescape(l:query), funcref('Handler'))
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

autocmd FileType fuzzyfinder let b:laststatus = &laststatus
  \| set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set showmode ruler
  \| let &laststatus = b:laststatus
  \| autocmd WinLeave <buffer> close!

command! -bang -nargs=* FG call s:FuzzyGrep(<bang>0, <f-args>)
command! -nargs=* FS call s:FuzzySnippets(<f-args>)

nnoremap <silent> <leader>fg :<C-U>call <SID>FuzzyGrepSelection('n')<CR>
vnoremap <silent> <leader>fg :<C-U>call <SID>FuzzyGrepSelection('v')<CR>
