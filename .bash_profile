#!/bin/bash
#
# Damien Dart's Bash configuration file for login shells.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is
# free and unencumbered software released into the public domain. For
# more information, please refer to the accompanying "UNLICENCE" file.

# shellcheck disable=SC1090
source ~/.profile
# shellcheck disable=SC1090
source ~/.bashrc

if [[ -f ~/.machine.bash_profile ]]; then
  # shellcheck disable=SC1090
  source ~/.machine.bash_profile
fi
