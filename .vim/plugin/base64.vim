" Doohickeys for decoding and encoding Base64 strings.
"
" Requires "base64" and has only been tested on Ubuntu. Inspired by:
"
" - <https://github.com/equal-l2/vim-base64>,
" - <https://github.com/christianrondeau/vim-base64>, and
" - <https://stackoverflow.com/q/7845671>.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

if exists('g:loaded_base64')
  finish
endif

let g:loaded_base64 = 1

if !executable('base64')
  function! s:Base64Required()
    throw 'Base64-related gubbins requires base64'
  endfunction

  nnoremap <silent> <leader>be :<C-U>call <SID>Base64Required()<CR>
  vnoremap <silent> <leader>be :<C-U>call <SID>Base64Required()<CR>
  nnoremap <silent> <leader>bd :<C-U>call <SID>Base64Required()<CR>
  vnoremap <silent> <leader>bd :<C-U>call <SID>Base64Required()<CR>

  finish
endif

function! s:Base64DecodeSelection(visualmode) abort
  function! s:decode(input) abort
    let l:output = system('base64 --decode --ignore-garbage --wrap=0', a:input)

    if v:shell_error
      throw 'Invalid Base64 input'
    endif

    return substitute(l:output, '\n$', '', 'g')
  endfunction

  let l:iskeyword = &iskeyword
  let l:paste = &paste

  " "getreginfo" is the preferred function to use when saving and
  " restoring registers. See <https://github.com/vim/vim/issues/2345>
  " and <https://vi.stackexchange.com/a/26272> for more information.
  let l:register = has('patch-8.2.0924')
    \? getreginfo('"')
    \: ['"', getreg('"', 1, 1), getregtype('"')]

  set paste

  try
    if a:visualmode == 'v'
      normal! gvy
      let l:decoded = s:decode(@")
      execute "silent normal! gv\"=l:decoded\<CR>p`>\<ESC>"
    else
      set iskeyword+=+,/,=
      let l:decoded = s:decode(expand('<cword>'))
      execute "silent normal! viw\"=l:decoded\<CR>phe\<ESC>"
    endif
  catch
    " Prevent a previous command from clearing the error message; search
    " for "echo-redraw" in Vim's help for more information.
    redraw

    echohl ErrorMsg
    echom v:exception
    echohl None
  finally
    let &iskeyword = l:iskeyword
    let &paste = l:paste

    if type(l:register) == type({})
      call setreg('"', l:register)
    else
      call call('setreg', l:register)
    endif
  endtry
endfunction

function! s:Base64EncodeSelection(visualmode)
  function! s:encode(input) abort
    let l:output = system('base64 --wrap=0', a:input)

    if v:shell_error
      throw 'Invalid input'
    endif

    return substitute(l:output, '\n$', '', 'g')
  endfunction

  let l:paste = &paste
  let l:register = has('patch-8.2.0924')
    \? getreginfo('"')
    \: ['"', getreg('"', 1, 1), getregtype('"')]

  try
    set paste

    if a:visualmode == 'v'
      execute "silent normal! gvygv\"=\<SID>encode(@\")\<CR>p`>\<ESC>"
    else
      execute "silent normal! viw\"=\<SID>encode(@\")\<CR>phe\<ESC>"
    endif
  finally
    let &paste = l:paste

    if type(l:register) == type({})
      call setreg('"', l:register)
    else
      call call('setreg', l:register)
    endif
  endtry
endfunction

nnoremap <silent> <leader>be :<C-U>call <SID>Base64EncodeSelection('n')<CR>
vnoremap <silent> <leader>be :<C-U>call <SID>Base64EncodeSelection('v')<CR>
nnoremap <silent> <leader>bd :<C-U>call <SID>Base64DecodeSelection('n')<CR>
vnoremap <silent> <leader>bd :<C-U>call <SID>Base64DecodeSelection('v')<CR>
