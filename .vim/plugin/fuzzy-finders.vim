" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

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
      catch /E684/
      catch /E11/
        echohl ErrorMsg
        echom join(split(v:exception, ':')[1:2], ':')
        echohl None
        return
      finally
        call delete(l:self.filename)
      endtry
    endif

    redraw!
  endfunction

  execute 'botright' 20 'new'

  call term_start(
    \ [
      \ &shell,
      \ &shellcmdflag,
      \ "TERM=xterm-color256 " . a:command . '>' . l:callback.filename
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
endfunction

function! s:FuzzySnippets() abort
  function! Handler(input) closure
    if a:input[0] ==? 'f1'
      execute "h :FS"

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
      execute "normal! a" . l:output . "\<Esc>"
    finally
      let &paste = l:paste
    endtry
  endfunction

  call s:Fuzzy("fuzzy-snippets --vim", funcref("Handler"))
endfunction

autocmd FileType fuzzyfinder let b:laststatus = &laststatus
  \| set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set showmode ruler
  \| let &laststatus = b:laststatus
  \| autocmd WinLeave <buffer> close!

command! FS call s:FuzzySnippets()
