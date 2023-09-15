# shellcheck shell=bash
# .bash_aliases

alias ls='ls --color=auto'
alias ll='ls -alF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias nivm='nvim'
alias nimv='nvim'
alias nbim='nvim'

[ -x "$(command -v thefuck)" ] && eval "$(thefuck --alias)"
