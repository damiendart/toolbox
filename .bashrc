# Damien's Bash Shell configuration file.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is free
# and unencumbered software released into the public domain. For more
# information, please refer to the accompanying "UNLICENCE" file.

function fancyPrompt()
{
  [ -z "$PROMPT_COLOUR" ] && export PROMPT_COLOUR='\[\e[36;1m\]'
  local PROMPT='\w \$\[\e[0m\] '
  # The "__git_ps1" function is defined in "bash-completion.bash", which is
  # included with the Git source code distribution.
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

[ -d "/usr/local/bin" ] && PATH="$PATH:/usr/local/bin"
[ -d "$HOME/bin" ] && export PATH="$PATH:$HOME/bin"
[ -d "$HOME/flex_sdk_4.1/bin" ] && export PATH="$PATH:$HOME/flex_sdk_4.1/bin"
[ -d "$HOME/Shed/toolbox" ] && export PATH="$PATH:$HOME/Shed/toolbox"
[ -f "/etc/bashrc" ] && . "/etc/bashrc"
[ -f "$HOME/bin/git-completion.bash" ] && . "$HOME/bin/git-completion.bash"

export EDITOR="$(type -P vim || type -P vi || echo "$EDITOR")"
VISUAL="$(type -P mvim || type -P gvim || echo "$EDITOR")"
[ -z "$DISPLAY" ] && VISUAL="$EDITOR"
# See <http://vimdoc.sourceforge.net/htmldoc/gui_x11.html#gui-fork>.
[ "$VISUAL" = "$(type -P gvim)" ] && VISUAL="$VISUAL -f"
[ "$VISUAL" = "$(type -P mvim)" ] && VISUAL="$VISUAL -f --nomru"
export VISUAL

if [ ! -z "$PS1" ]; then
  # See <http://blog.sanctum.geek.nz/better-bash-history/>.
  export HISTCONTROL=ignoreboth
  export HISTIGNORE="clear:exit:history:ls"
  export HISTSIZE=1000000
  export HISTTIMEFORMAT="%F %T "
  export PROMPT_COMMAND="fancyPrompt; history -a; history -n"
  set -o vi
  shopt -s cmdhist histappend
  unset HISTFILESIZE
fi
