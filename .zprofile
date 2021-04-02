#!/bin/zsh
# shellcheck shell=bash
#
# Damien Dart's ZSH configuration file for login shells.
#
# This file was written by Damien Dart, <damiendart@pobox.com>. This is
# free and unencumbered software released into the public domain. For
# more information, please refer to the accompanying "UNLICENCE" file.

# shellcheck disable=SC1090
source ~/.profile

if [[ -f ~/.machine.zprofile ]]; then
	# shellcheck disable=SC1090
  source ~/.machine.zprofile
fi
