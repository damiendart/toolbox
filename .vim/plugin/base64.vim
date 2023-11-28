" A couple of visual mode mappings for decoding/encoding Base64 strings.
"
" Requires "base64" and has only been tested on Ubuntu. Based on:
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

  vnoremap <silent> <leader>be :<C-U>call <SID>Base64Required()<CR>
  vnoremap <silent> <leader>bd :<C-U>call <SID>Base64Required()<CR>

  finish
endif

function! s:Base64DecodeSelection() abort
  function! s:decode(input) abort
    let l:output = system('base64 --decode --wrap=0', a:input)

    if v:shell_error
      throw 'Invalid Base64 input'
    endif

    return l:output
  endfunction

  let l:paste = &paste

  " "getreginfo" is the preferred function to use when saving and
  " restoring registers. See <https://github.com/vim/vim/issues/2345>
  " and <https://vi.stackexchange.com/a/26272> for more information.
  let l:register = has('patch-8.2.0924')
    \? getreginfo('"')
    \: ['"', getreg('"', 1, 1), getregtype('"')]

  set paste
  normal! gvy
  try
    execute 'normal! gv"_c' . s:decode(@") . "\<ESC>"
  catch
    echoerr 'Error: ' . v:exception
  finally
    normal! `[
    let &paste = l:paste

    if type(l:register) == type({})
      call setreg('"', l:register)
    else
      call call('setreg', l:register)
    endif
  endtry
endfunction

function! s:Base64EncodeSelection()
  let l:paste = &paste
  let l:register = has('patch-8.2.0924')
    \? getreginfo('"')
    \: ['"', getreg('"', 1, 1), getregtype('"')]

  try
    set paste
    normal! gv
    execute "normal! c\<C-R>=system('base64 --wrap=0', @\")\<CR>\<ESC>"
    normal! `[
  finally
    let &paste = l:paste

    if type(l:register) == type({})
      call setreg('"', l:register)
    else
      call call('setreg', l:register)
    endif
  endtry
endfunction

vnoremap <silent> <leader>be :<C-U>call <SID>Base64EncodeSelection()<CR>
vnoremap <silent> <leader>bd :<C-U>call <SID>Base64DecodeSelection()<CR>
