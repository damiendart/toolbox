# A simple "save every command entered into Bash" doohickey.
#
# To use, source this file in your session initialisation method of
# choice. This script is based on the one found at
# <https://www.tonyscelfo.com/2009/04/27/save-all-of-your-bash-history.html>.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is
# free and unencumbered software released into the public domain. For
# more information, please refer to the accompanying "UNLICENCE" file.

export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%F %T "
export SBH_OUTPUT_FILE=${SBH_OUTPUT_FILE:-~/.superbashhistory}
export PROMPT_COMMAND="${PROMPT_COMMAND:-:};super_bash_history"

super_bash_history()
{
  [[ $(history 1) =~ ^\ *[0-9]+\ +([0-9-]+\ [0-9:]+)\ +(.*)$ ]]
  if [ "${BASH_REMATCH[1]}" != "$SUPER_BASH_HISTORY_LAST_COMMAND" ]
  then
    echo -e "${HOSTNAME}\t${BASH_REMATCH[1]}\t${BASH_REMATCH[2]}" \ >> $SBH_OUTPUT_FILE
    export SUPER_BASH_HISTORY_LAST_COMMAND="${BASH_REMATCH[1]}"
  fi
}
