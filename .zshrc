#!/bin/zsh
# shellcheck shell=bash
#
# Damien Dart's ZSH configuration file for interactive shells.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is
# free and unencumbered software released into the public domain. For
# more information, please refer to the accompanying "UNLICENCE" file.

# shellcheck disable=SC1090
source ~/.shellrc

# Use Emacs-style key bindings; as much as Vim has ruined text entry for
# me I just can't get used to it on the command-line.
bindkey -e

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE="100000"
export SAVEHIST="$HISTSIZE"

if [ -n "$RANGER_LEVEL" ]; then
  export PS1="[ranger] $PS1"
fi

setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY

shellrc__source_one "fzf-completion" <<FZF_COMPLETION
/usr/local/opt/fzf/shell/completion.zsh
/usr/local/etc/fzf-completion.zsh
FZF_COMPLETION

shellrc__source_one "fzf-key-bindings" <<FZF_KEY_BINDINGS
/usr/local/opt/fzf/shell/key-bindings.zsh
/usr/local/etc/fzf-key-bindings.zsh
FZF_KEY_BINDINGS

unfunction shellrc__source_one
