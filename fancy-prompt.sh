# Damien's fancy Unix Shell prompt.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is free
# and unencumbered software released into the public domain. For more
# information, please refer to the accompanying "UNLICENCE" file.

# TODO: Add support for other SCMs and shells.
# TODO: Add a bit of documentation.
function fancyPrompt()
{
  [ -z "$BASH_PROMPT_COLOUR" ] && export BASH_PROMPT_COLOUR='\[\e[36;1m\]'
  local BASH_PROMPT='\w \$\[\e[0m\] '
  local ZSH_PROMPT='%~ %# '
  # The "__git_ps1" function is defined in "bash-completion.bash", which is
  # included with the Git source code distribution.
  if [ "$(type -t __git_ps1)" ]; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    BASH_PROMPT='\w$(__git_ps1 " [git:%s]" | sed -e "s/ //2") \$\[\e[0m\] '
  fi
  export PS1="${BASH_PROMPT_COLOUR}${BASH_PROMPT}"
  #TODO: Add colours and Git respository information to ZSH prompt.
  export PROMPT="${ZSH_PROMPT}"
  # Fall back to a bare-bones prompt when using "sudo" to run commands as
  # another user, as the bits and pieces required to display repository
  # information in the prompt might not be available to the assumed user.
  export SUDO_PS1='\[\e[37;1;41m\]\w \$\[\e[0m\] '
}
