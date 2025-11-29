#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
export PATH="$PATH:/usr/local/bin"
export PATH="$HOME/.local/bin:$PATH"

# opencode
export PATH=/home/detect/.opencode/bin:$PATH
