#
# ~/.bashrc
#

# Eğer interaktif değilse hiçbir şey yapma
[[ $- != *i* ]] && return

# Temel sistem ayarları
export LANG=en_US.UTF-8

# Android Development
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"

# Java Development
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
export PATH="$PATH:$JAVA_HOME/bin"
export EDITOR=code
export VISUAL=code
export BROWSER=google-chrome-stable
export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"

# Renkli çıktı için alias'lar
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'

# Python virtual environment kolay aktivasyon
alias venv='python -m venv venv'
alias activate='source venv/bin/activate'
export PYTHONDONTWRITEBYTECODE=1  # Python __pycache__ oluşturmasını engelle

# Sistem kısayolları
alias ports='netstat -tulanp'
alias weather='curl wttr.in'
alias ip='curl ifconfig.me'
alias clean='sudo pacman -Sc && yay -Sc' # Arch Linux özel komutları
alias pacsize='expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqen | sort) <(pacman -Qqg base base-devel | sort)) | sort -n'
alias pacorphan='sudo pacman -Qtdq'
alias pacclean='sudo pacman -Rns $(pacman -Qtdq)'
alias paclast='expac --timefmt="%Y-%m-%d %T" "%l\t%n" | sort | tail -n 20'
alias paclog='tail -f /var/log/pacman.log'
alias yaysave='yay -Ps'
alias yayclean='yay -Sc && yay -Yc'
alias update='sudo pacman -Syu && yay -Syu' # Sistem güncelleme
alias mem='free -h | grep "Mem:"'
alias cpu='top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk "{print 100 - \$1"%"}"'
alias diskspace='df -h /'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -pv'
alias free='free -h'
alias df='df -h'
alias du='du -h'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Git kısayolları
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias glo='git log --oneline --graph --decorate'

# Daha iyi tab tamamlama
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'

# Geçmiş ayarları
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:ll:cd:pwd:exit:clear"
shopt -s histappend
PROMPT_COMMAND="history -a; history -n"

# Otomatik CD
shopt -s autocd
shopt -s cdspell
shopt -s dirspell

# Git prompt yükleme
if [ -f "/usr/share/git/git-prompt.sh" ]; then
    source "/usr/share/git/git-prompt.sh"
elif [ -f "/etc/bash_completion.d/git-prompt" ]; then
    source "/etc/bash_completion.d/git-prompt"
fi

# Renk tanımlamaları
RESET='\[\033[0m\]'
BLACK='\[\033[0;30m\]'
RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
YELLOW='\[\033[0;33m\]'
BLUE='\[\033[0;34m\]'
PURPLE='\[\033[0;35m\]'
CYAN='\[\033[0;36m\]'
WHITE='\[\033[0;37m\]'
BOLD_BLACK='\[\033[1;30m\]'
BOLD_RED='\[\033[1;31m\]'
BOLD_GREEN='\[\033[1;32m\]'
BOLD_YELLOW='\[\033[1;33m\]'
BOLD_BLUE='\[\033[1;34m\]'
BOLD_PURPLE='\[\033[1;35m\]'
BOLD_CYAN='\[\033[1;36m\]'
BOLD_WHITE='\[\033[1;37m\]'

# Git durumu için fonksiyonlar
function git_color {
    local git_status="$(git status 2> /dev/null)"
    if [[ $git_status =~ "nothing to commit" ]]; then
        echo -e $BOLD_GREEN
    elif [[ $git_status =~ "Changes not staged" || $git_status =~ "Changes to be committed" ]]; then
        echo -e $BOLD_YELLOW
    else
        echo -e $BOLD_RED
    fi
}

# Sistem yükü kontrolü
function load_color {
    local LOAD=$(uptime | awk '{print $8+0}')
    if [ $LOAD -gt 2 ]; then
        echo -e $BOLD_RED
    elif [ $LOAD -gt 1 ]; then
        echo -e $BOLD_YELLOW
    else
        echo -e $BOLD_GREEN
    fi
}

# Modern Unicode sembolleri
ARROW="➜"
BRANCH=""
LIGHTNING="⚡"
GEAR="⚙"

# Özel PS1 prompt
PS1="\n${BOLD_BLUE}┌─[${BOLD_CYAN}\u${BOLD_BLUE}@${BOLD_CYAN}\h${BOLD_BLUE}]─[${BOLD_YELLOW}\w${BOLD_BLUE}]"
PS1+="\$(git branch &>/dev/null;\
if [ \$? -eq 0 ]; then \
    echo \"${BOLD_BLUE}─[${BOLD_PURPLE}\$(__git_ps1 '%s')${BOLD_BLUE}]\";\
fi)"
PS1+="\n${BOLD_BLUE}└─${BOLD_GREEN}${ARROW} ${RESET}"

# Özel fonksiyonlar

# Sistem durumunu göster
function sysinfo() {
    echo "CPU Kullanımı:"
    top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4"%"}'
    echo -e "\nMemory Kullanımı:"
    free -h | grep "Mem:"
    echo -e "\nDisk Kullanımı:"
    df -h / | tail -n1
}

# Ağ durumunu kontrol et
function netcheck() {
    echo "Ping Google DNS:"
    ping -c 1 8.8.8.8 | grep "time="
    echo -e "\nAktif Bağlantılar:"
    ss -tuln | grep "LISTEN"
}
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

function extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2) tar xjf $1    ;;
            *.tar.gz)  tar xzf $1    ;;
            *.bz2)     bunzip2 $1    ;;
            *.rar)     unrar x $1    ;;
            *.gz)      gunzip $1     ;;
            *.tar)     tar xf $1     ;;
            *.tbz2)    tar xjf $1    ;;
            *.tgz)     tar xzf $1    ;;
            *.zip)     unzip $1      ;;
            *.Z)       uncompress $1 ;;
            *.7z)      7z x $1       ;;
            *)         echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function cleanup() {
    echo "Cleaning up system..."
    sudo pacman -Sc --noconfirm
    yay -Sc --noconfirm
    sudo rm -rf ~/.cache/*
    sudo journalctl --vacuum-size=50M
    echo "Cleanup completed!"
}

# Komut tamamlama ayarları
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Mise setup
eval "$(~/.local/bin/mise activate bash)"
