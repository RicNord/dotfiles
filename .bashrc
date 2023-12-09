# shellcheck shell=bash
# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source aliases
if [ -f "$HOME"/.bash_aliases ]; then
    source "$HOME"/.bash_aliases
fi

# Source ansible managed enviorment
if [ -f "$HOME"/.bash_ansible ]; then
    source "$HOME"/.bash_ansible
fi

# Source functions
if [ -f "$HOME"/.bash_func ]; then
    source "$HOME"/.bash_func
fi

# Set PS1 prompt
export PS1="\[\033[38;5;3m\]\u\[$(tput sgr0)\]@\h:[\[$(tput sgr0)\]\[\033[38;5;208m\]\W\[$(tput sgr0)\]]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')\\$ \[$(tput sgr0)\]"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Verify history before running
shopt -s histverify

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Set nvim as editor
export EDITOR=nvim

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# GPG_TTY
GPG_TTY=$(tty)
export GPG_TTY
