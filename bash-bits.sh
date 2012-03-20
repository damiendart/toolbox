#!/bin/bash

# Functions that customise the Bash shell environment.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is free
# and unencumbered software released into the public domain. For more
# information, please refer to the accompanying "UNLICENCE" file.

function setupVimAsDefaultEditor()
{
  export EDITOR="$(type -P vim || type -P vi || echo "$EDITOR")"
  VISUAL="$(type -P mvim || type -P gvim || echo "$EDITOR")"
  [ -z "$DISPLAY" ] && VISUAL="$EDITOR"
  # See <http://vimdoc.sourceforge.net/htmldoc/gui_x11.html#gui-fork>.
  [ "$VISUAL" = "$(type -P gvim)" ] && VISUAL="$VISUAL -f"
  [ "$VISUAL" = "$(type -P mvim)" ] && VISUAL="$VISUAL -f --nomru"
  export VISUAL
}

# The following function uses functions defined in "bash-completion.bash",
# which is included with the Git source code distribution.
# TODO: Add support for other SCMs and shells.
function setupGitAwarePrompt()
{
  [ -z "$PROMPT_COLOUR" ] && export PROMPT_COLOUR='\[\e[36;1m\]'
  local PROMPT='\w \$\[\e[0m\] '
  if [ "$(type -t __git_ps1)" ]; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    PROMPT='\w$(__git_ps1 " [git:%s]" | sed -e "s/ //2") \$\[\e[0m\] '
  fi
  export PS1="${PROMPT_COLOUR}${PROMPT}"
  # Fall back to a bare-bones prompt when using "sudo" to run commands as
  # another user, as the bits and pieces required to display repository
  # information in the prompt might not be available to the assumed user.
  export SUDO_PS1='\[\e[37;1;41m\]\w \$\[\e[0m\] '
}

# See <http://blog.sanctum.geek.nz/better-bash-history/>.
# TODO: Add support for other shells.
function betterBashHistory()
{
  export HISTCONTROL=ignoreboth
  export HISTIGNORE="clear:exit:history:ls"
  export HISTSIZE=1000000
  export HISTTIMEFORMAT="%F %T "
  export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
  shopt -s cmdhist histappend
  unset HISTFILESIZE
}
