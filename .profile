#!/bin/sh
#
# Damien Dart's cross-shell configuration file for login shells.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is
# free and unencumbered software released into the public domain. For
# more information, please refer to the accompanying "UNLICENCE file.

# shellcheck disable=SC2034
IPS="\n"

export EDITOR='vim'
export NPM_CONFIG_PREFIX="$HOME/.npm"
# shellcheck disable=SC2155
export TOOLBOX_ROOT="$(dirname "$(readlink "$HOME/.profile")")"
export VIRTUALENVWRAPPER_PYTHON='/usr/bin/python3'

while read -r ITEM; do
  if [ -d "$ITEM" ]; then
    # The following is a POSIX-compatible method of preventing duplicate
    # entries in the PATH environmental variable; it is based on a
    # snippet from <https://unix.stackexchange.com/a/32054>.
    case ":$PATH:" in
      *:$ITEM:*) echo "[!] \"$ITEM\" already exists in PATH" 1>&2 ;;
      *) export PATH="$PATH:$ITEM" ;;
    esac
  fi
done <<PATHS
$HOME/.cargo/bin
$HOME/.local/bin
$HOME/Library/Python/3.7/bin
$NPM_CONFIG_PREFIX/bin
$TOOLBOX_ROOT/bin
PATHS
