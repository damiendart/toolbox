#!/bin/bash
#
# Damien Dart's Bash configuration file for interactive shells.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is
# free and unencumbered software released into the public domain. For
# more information, please refer to the accompanying "UNLICENCE file.

if [[ -f '/etc/skel/.bashrc' ]]; then
  # shellcheck disable=SC1091
  source /etc/skel/.bashrc
elif [[ -f '/etc/bashrc' ]]; then
  # shellcheck disable=SC1091
  source /etc/bashrc
fi

# shellcheck disable=SC1090
source "$HOME/.shellrc"

export HISTCONTROL=ignoreboth
export HISTFILESIZE=100000
export HISTSIZE="$HISTFILESIZE"
export HISTTIMEFORMAT='%s '
export PROMPT_COMMAND="$PROMPT_COMMAND;history -a"

shopt -s cmdhist

shellrc__source_one "fzf-completion" <<FZF_COMPLETION
/usr/local/opt/fzf/shell/completion.bash
/usr/local/etc/fzf-completion.bash
FZF_COMPLETION

shellrc__source_one "fzf-key-bindings" <<FZF_KEY_BINDINGS
/usr/local/opt/fzf/shell/key-bindings.bash
/usr/local/etc/fzf-key-bindings.bash
FZF_KEY_BINDINGS

if [[ -f ~/.machine.bashrc ]]; then
  # shellcheck disable=SC1090
  source ~/.machine.bashrc
fi

unset shellrc__source_one
