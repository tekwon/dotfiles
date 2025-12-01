#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias la="ls -la --color=auto"

PS1='[\u@\h \W]\$ '
export PATH="$PATH:/usr/local/bin"
export PATH="$HOME/.local/bin:$PATH"

# opencode
export PATH=/home/detect/.opencode/bin:$PATH

# NVIDIA Wayland fixes for Firefox
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export MOZ_ENABLE_WAYLAND=1
export MOZ_DISABLE_RDD_SANDBOX=1
