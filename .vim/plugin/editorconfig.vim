" EditorConfig-related settings and tweaks.
"
" This file was written by Damien Dart, <damiendart@pobox.com>. This is
" free and unencumbered software released into the public domain. For
" more information, please refer to the accompanying "UNLICENCE" file.

" Avoid loading EditorConfig functionality for terminal buffers to
" prevent cursor funkiness when closing floating windows running fzf and
" other terminal-based tools. For more information, please see
" <https://github.com/editorconfig/editorconfig-vim/issues/235#issuecomment-2005165360>.
let g:EditorConfig_exclude_patterns = ['^.*!\w*sh$']
