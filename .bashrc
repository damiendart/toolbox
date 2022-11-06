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
HISTFILESIZE=100000
HISTSIZE=100000
HISTTIMEFORMAT='%s '
PROMPT_COMMAND="${PROMPT_COMMAND};history -a"

shopt -s cmdhist histappend

shellrc__source_one "bash-completion" <<BASH_COMPLETION
/usr/share/bash-completion/bash_completion
/etc/bash_completion
BASH_COMPLETION

shellrc__source_one "fzf-completion" <<FZF_COMPLETION
${TOOLBOX_ROOT}/.vim/pack/plugins/start/fzf/shell/completion.bash
/usr/local/opt/fzf/shell/completion.bash
FZF_COMPLETION

shellrc__source_one "fzf-key-bindings" <<FZF_KEY_BINDINGS
${TOOLBOX_ROOT}/.vim/pack/plugins/start/fzf/shell/key-bindings.bash
/usr/local/opt/fzf/shell/key-bindings.bash
FZF_KEY_BINDINGS

shellrc__source_one "ripgrep-completion" <<RIPGREP_COMPLETION
/usr/share/bash-completion/completions/rg
RIPGREP_COMPLETION

shellrc__source_one "task-completion" <<TASK_COMPLETION
/etc/bash_completion.d/task
TASK_COMPLETION

if [[ -f ~/.machine.bashrc ]]; then
  # shellcheck disable=SC1090
  source ~/.machine.bashrc
fi

unset shellrc__source_one
