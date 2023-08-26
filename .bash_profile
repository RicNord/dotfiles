# shellcheck shell=bash
#
# ~/.bash_profile
#
[[ -f ~/.profile ]] && . ~/.profile
[[ -f ~/.bashrc ]] && . ~/.bashrc

export GPG_TTY="$(tty)"
