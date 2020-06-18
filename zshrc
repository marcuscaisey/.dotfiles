################################################################################
#                                  oh my zsh
################################################################################
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
  alias-finder
  colored-man-pages
  django
  docker
  docker-compose
  fast-syntax-highlighting
  git
  gitignore
  osx
  per-directory-history
  sublime
  tmux
  zsh-autosuggestions
  zsh-nvm
)

source $ZSH/oh-my-zsh.sh


################################################################################
#                                    prompt
################################################################################
git_branch_format="%{$fg_bold[yellow]%}"
export ZSH_THEME_GIT_PROMPT_PREFIX="$git_branch_format("
export ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
export ZSH_THEME_GIT_PROMPT_DIRTY="$git_branch_format) %{$fg[yellow]%}✗"
export ZSH_THEME_GIT_PROMPT_CLEAN="$git_branch_format) %{$fg[green]%}✔"

export PROMPT='%{$fg_bold[magenta]%}[$USER@%m] %{$fg_bold[blue]%}%c%{$reset_color%} $(git_prompt_info)'


################################################################################
#                                     path
################################################################################
export GOPATH=$HOME/go

export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
if [ $(uname) = "Darwin" ]; then
    export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
    export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
fi
export PATH="$HOME/.scripts:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"


################################################################################
#                                   aliases
################################################################################
alias ls="exa"
alias lsl="ls -l"
alias lsa="ls -a"
alias lsal="ls -al"
alias lsla=lsal
alias l="ls -algh"

alias rmr="rm -r"

# cd to last open directory when quitting ranger
alias ranger="source ranger"

alias py=python


################################################################################
#                                     fzf
################################################################################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use fd for find instead of default find
export FZF_DEFAULT_COMMAND="fd --follow --type f --exclude .git"

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
export FZF_CTRL_T_OPTS="--preview 'if [ ! -d {} ]; then bat --theme=ansi-dark --color=always --style=numbers {}; else echo Directory: {}; fi'"


################################################################################
#                                    pyenv
################################################################################
# export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


################################################################################
#                                  key binds
################################################################################
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
bindkey '^ ' autosuggest-accept
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
