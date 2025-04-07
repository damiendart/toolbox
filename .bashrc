#!/bin/bash
#
# Damien Dart's Bash configuration file for interactive shells.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is
# free and unencumbered software released into the public domain. For
# more information, please refer to the accompanying "UNLICENCE file.

# shellcheck disable=SC1090
source "$HOME/.shellrc"

# shellcheck disable=SC1091
source "$HOME/.bash_aliases"

HISTCONTROL=ignoreboth

# Increase the default Bash command history size (usually around 500
# lines) to something a little more reasonable, while keeping the hit to
# Bash's startup time to a minimum. For more information, see
# <http://mywiki.wooledge.org/BashFAQ/088>.
HISTFILESIZE=20000
HISTSIZE=20000

HISTTIMEFORMAT='%s '
PROMPT_COMMAND="${PROMPT_COMMAND};history -a"

shopt -s cmdhist histappend

shellrc__source_one "bash-completion" <<BASH_COMPLETION
/usr/share/bash-completion/bash_completion
/etc/bash_completion
BASH_COMPLETION

if [[ -f ~/.machine.bashrc ]]; then
  # shellcheck disable=SC1090
  source ~/.machine.bashrc
fi

unset shellrc__source_one
