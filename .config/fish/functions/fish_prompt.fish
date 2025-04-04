# This file was written by Damien Dart, <damiendart@pobox.com>. This is
# free and unencumbered software released into the public domain. For
# more information, please refer to the accompanying "UNLICENCE file.

# For more information on this interactive shell prompt, see the
# "shellrc__prompt_command" function in "$TOOLBOX_ROOT/.shellrc".
function fish_prompt
  if test $status -eq 0; or test $status -eq 148
    echo ':; '
  else
    set_color --bold red
    echo -n ':; '
    set_color normal
  end
end
