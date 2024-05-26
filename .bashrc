#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '

export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"

# Load the git prompt script
if [ -f "/usr/share/git/git-prompt.sh" ]; then
    . "/usr/share/git/git-prompt.sh"
elif [ -f "/etc/bash_completion.d/git-prompt" ]; then
    . "/etc/bash_completion.d/git-prompt"
fi

# Define modern colors
NORMAL='\[\033[00m\]'
BLUE='\[\033[01;34m\]'
GREEN='\[\033[01;32m\]'
CYAN='\[\033[01;36m\]'
RED='\[\033[01;31m\]'
YELLOW='\[\033[01;33m\]'

# Update PS1 with a modern look using Unicode symbols
PS1="\n${BLUE}┌─[${CYAN}\u${BLUE}@${CYAN}\h${BLUE}]─[${YELLOW}\w${BLUE}]${NORMAL}"
PS1+="\n${BLUE}└─${GREEN}\$(__git_ps1 '(%s)')${NORMAL}➜ ${NORMAL}"

