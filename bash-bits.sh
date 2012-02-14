#!/bin/bash

# Functions that customise the Bash shell environment.
#
# This file was written by Damien Dart <damiendart@pobox.com>. This is free
# and unencumbered software released into the public domain. For more
# information, please refer to <http://unlicense.org>.

function setupVimAsDefaultEditor() {
  export EDITOR="$(type -P vim || type -P vi || echo "$EDITOR")"
  VISUAL="$(type -P mvim || type -P gvim || echo "$EDITOR")"
  [ -z "$DISPLAY" ] && VISUAL="$EDITOR"
  [ "$VISUAL" = "$(type -P gvim)" ] && VISUAL="$VISUAL -f"
  [ "$VISUAL" = "$(type -P mvim)" ] && VISUAL="$VISUAL -f --nomru"
  export VISUAL
}

function setupGitAwarePrompt() {
  [ -z "$PROMPT_COLOUR" ] && export PROMPT_COLOUR='\[\e[36;1m\]'
  local PROMPT='\w \$\[\e[0m\] '
  # TODO: Add support for other SCMs.
  if [ "$(type -t __git_ps1)" ]; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    PROMPT='\w$(__git_ps1 " [git:%s]" | sed -e "s/ //2") \$\[\e[0m\] '
  fi
  export PS1="${PROMPT_COLOUR}${PROMPT}"
  export SUDO_PS1='\[\e[37;1;41m\]\w \$\[\e[0m\] '
}
