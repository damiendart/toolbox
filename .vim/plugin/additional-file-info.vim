" A compliment to ":file" that prints additional file information.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

function! PrintAdditionalFileInformation() abort
  let l:items = ['"' . @% . '" ']

  if exists("b:editorconfig_applied") && b:editorconfig_applied
    call add(items, '[editorconfig]')
  endif

  if strlen(system('git -C ' . shellescape(expand('%:p:h')) .  ' rev-parse --show-toplevel 2>/dev/null')) > 1
    call add(items, '[git:' . trim(system('git -C ' . shellescape(expand('%:p:h')) .  ' rev-parse --abbrev-ref HEAD')) . ']')
  endif

  echom join(l:items, '')
  return
endfunction

command! F call PrintAdditionalFileInformation()
