# Damien's Unix Shell prompt. Supports Bash and ZSH.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is free
# and unencumbered software released into the public domain. For more
# information, please refer to the accompanying "UNLICENCE" file.

# This function is inspired by http://blog.sanctum.geek.nz/bash-prompts/>.
function __getVCSInfomation()
{
  # TODO: Add support for other VCSes.
  if git branch &>/dev/null; then
    if [[ "$(type -t __git_ps1)" ]]; then
      echo ' '$(__git_ps1 "[git:%s]" | sed -e "s/ //")
    else
      GIT_HEAD="$(git symbolic-ref HEAD 2>/dev/null)"
      CURRENT_BRANCH="${GIT_HEAD##*/}"
      [[ -n "$(git status 2>/dev/null | \
          grep -F 'working directory clean')" ]] || REPOSITORY_STATUS="!"
      printf ' [git:%s]' "${CURRENT_BRANCH:-unknown}${REPOSITORY_STATUS}"
    fi
  elif hg branch &>/dev/null; then
    CURRENT_BRANCH="$(hg branch 2>/dev/null)"
    [[ -n "$(hg status 2>/dev/null)" ]] && local REPOSITORY_STATUS="!"
    printf ' [hg:%s]' "${CURRENT_BRANCH:-unknown}${REPOSITORY_STATUS}"
  else
    return 1
  fi
}

# Setting the "PROMPT_COLOUR" and "PROMPT_ROOT_COLOUR" environmental variables
# beforehand will override the default colours provided in this function.
function setUpFancyPrompt()
{
  [[ -z "$PROMPT_COLOUR" ]] && PROMPT_COLOUR=$(tput setaf 6; tput bold)
  [[ -z "$PROMPT_ROOT_COLOUR" ]] && \
      PROMPT_ROOT_COLOUR=$(tput setab 1; tput setaf 7; tput bold)
  [[ $EUID -eq 0 ]] && PROMPT_COLOUR=$PROMPT_ROOT_COLOUR
  if [ "$(type -t __git_ps1)" ]; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
  fi
  export PS1='\['${PROMPT_COLOUR}'\]\w$(__getVCSInfomation) \$\['$(tput sgr0)'\] '
  export PROMPT='%{'${PROMPT_COLOUR}'%}%~$(__getVCSInfomation) %#%{'$(tput sgr0)'%} '
}
