# Damien Dart's fish shell configuration file.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is
# free and unencumbered software released into the public domain. For
# more information, please refer to the accompanying "UNLICENCE file.

if status is-interactive
  function fish_prompt
    if test $status -eq 0; or test $status -eq 148
      echo ':; '
    else
      set_color --bold red
      echo -n ':; '
      set_color normal
    end
  end

  function scrub_command
    echo
    set -l COMMAND (commandline | string collect)
    history delete --case-sensitive -- $COMMAND
    commandline ""
    commandline --function repaint
  end

  alias egrep='egrep --color=auto'
  alias f-grep='fuzzy-grep'
  alias f-pods='fuzzy-pods'
  alias f-snippets='fuzzy-snippets'
  alias fgrep='fgrep --color=auto'
  alias grep='grep --color=auto'
  alias ls='ls --color=auto'
  alias tree='tree -C'

  bind \cg accept-autosuggestion scrub_command

  set fish_greeting
end
