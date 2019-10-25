#############
# oh my zsh #
#############
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="dracula"

plugins=(
  colored-man-pages
  docker
  fast-syntax-highlighting
  git
  helm
  kubectl
  osx
  per-directory-history
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh


########
# path #
########
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
if [ $(uname) = "Darwin" ]; then
    export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
    export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
fi
export PATH="$HOME/.scripts:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"


###########
# aliases #
###########
alias ls="exa"
alias lsl="ls -l"
alias lsa="ls -a"
alias lsal="ls -al"
alias lsla=lsal
alias l="ls -algh"

alias rmr="rm -r"

# cd to last open directory when quitting ranger
alias ranger="source ranger"

# on linux, fd is called fdfind
# if [ $(uname) = "Linux" ]; then alias fd="fdfind"; fi

alias bi="brew install"
alias biy="brew install -y"
alias bud="brew update"
alias bug="brew upgrade"
alias bugy="brew upgrade -y"

alias ai="sudo apt install"
alias aiy="sudo apt install -y"
alias aud="sudo apt update"
alias aug="sudo apt upgrade"
alias augy="sudo apt upgrade -y"

alias py=python
alias bpy=bpython
alias pi="pip install"
alias pf="pip freeze"

alias tf=terraform


#############
# functions #
#############
# mkc dir
#     Create directory 'dir' and cd into it.
mkc() { mkdir -p $1 && cd $1; }

# hbt fname exc
#     Create an executable file 'fname' and add a hashbang to 'exc'.
hbt() { which $2 | sed -E 's/(.+)/#!\1\n/' > $1 && chmod +x $1; }

# cd dir
#     cd to 'dir' and then ls.
cl() { cd $1 && ls; }


#######
# fzf #
#######
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use fd for find instead of default find
# if [ $(uname) = "Linux" ]; then fdbin=fdfind; else fdbin=fd; fi
fdbin=fd
export FZF_DEFAULT_COMMAND="$fdbin --follow --type f --exclude .git"

# Use ~~ for completion trigger instead of **
export FZF_COMPLETION_TRIGGER='~~'

# Use fd instead of the default find
_fzf_compgen_path() {
    fd --hidden --follow --exclude .git . $1
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude .git . $1
}

# Use ctrl + t to fuzzy search all files/directories (excluding .git) with preview in current directory
export FZF_CTRL_T_COMMAND='fd --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'if [ ! -d {} ]; then bat --color=always --style=numbers {}; else echo Directory: {}; fi'"


#########
# pyenv #
#########
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


#############
# key binds #
#############
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
bindkey '^ ' autosuggest-accept
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
