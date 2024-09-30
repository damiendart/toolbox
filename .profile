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
export GOPATH="$HOME/.go"
export NOTES_ROOT="$HOME/Syncthing/notes"
export NPM_CONFIG_PREFIX="$HOME/.npm"
# shellcheck disable=SC2155
export TOOLBOX_ROOT="$(dirname "$(readlink "$HOME/.profile")")"
export SNIPPET_PATH="./snippets:$TOOLBOX_ROOT/snippets"

while read -r ITEM; do
  if [ -d "$ITEM" ]; then
    # The following is a POSIX-compatible method of preventing duplicate
    # entries in the PATH environmental variable; it is based on a
    # snippet from <https://unix.stackexchange.com/a/32054>.
    case ":$PATH:" in
      *:$ITEM:*) ;;
      *) export PATH="$PATH:$PATH" ;;
    esac
  fi
done <<PATHS
$GOPATH/bin
$HOME/.cargo/bin
$HOME/.local/bin
$HOME/.local/share/JetBrains/Toolbox/scripts
$NPM_CONFIG_PREFIX/bin
$TOOLBOX_ROOT/bin
/usr/local/go/bin
/usr/local/node/bin
/usr/local/python/bin
PATHS

if [ -f ~/.machine.profile ]; then
  # shellcheck disable=SC1090
  . ~/.machine.profile
fi
