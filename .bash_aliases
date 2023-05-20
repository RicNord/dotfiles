# shellcheck shell=bash
# .bash_aliases

alias ls='ls --color=auto'
alias ll='ls -alF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

[ -x "$(command -v thefuck)" ] && eval "$(thefuck --alias)"
