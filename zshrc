source ~/.dotfiles/utils.sh

################################################################################
#                                  oh my zsh
################################################################################
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
  alias-finder
  colored-man-pages
  fast-syntax-highlighting
  git
  per-directory-history
  please
  tmux
  zsh-autosuggestions
)

if linux; then
  plugins=(kubectl kube-ps1 $plugins)
fi

source $ZSH/oh-my-zsh.sh


################################################################################
#                                  git prompt
################################################################################
git_branch_format="%{$fg_bold[yellow]%}"
export ZSH_THEME_GIT_PROMPT_PREFIX="$git_branch_format("
export ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
export ZSH_THEME_GIT_PROMPT_CLEAN="$git_branch_format) "

export PROMPT='%{$fg_bold[blue]%}%c%{$reset_color%} $(git_prompt_info)'


################################################################################
#                                   kube-ps1
################################################################################
if linux; then
  export KUBE_PS1_SYMBOL_ENABLE=false
  export PROMPT='%B$(kube_ps1)'" $PROMPT"
fi


################################################################################
#                                   aliases
################################################################################
# exa
alias ls="exa"
alias lsl="ls -l"
alias lsa="ls -a"
alias lsal="ls -al"
alias lsla=lsal
alias l="ls -algh"

alias rmr="rm -r"

alias py=python

alias vim=nvim

# git
alias oops="gau && gcn!"
alias conflicts='vim $(git diff --name-only --diff-filter=U)'
alias gcfd="git clean -fd"

alias d="cd ~/.dotfiles"

if linux; then
  alias c="cd ~/core3/src"
  alias t="cd ~/toolchain"
  alias s="cd ~/scratch"

  alias black="PYTHONNOUSERSITE=1 black"

  alias bob='kubectl exec bob -c bob -it -- psql'
fi


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
export FZF_CTRL_T_OPTS="--preview 'if [ ! -d {} ]; then bat --color=always {}; else echo Directory: {}; fi'"


################################################################################
#                                     bat
################################################################################
export BAT_THEME="Dracula"
export BAT_STYLE="numbers"


################################################################################
#                                     node
################################################################################
if linux; then
  export PATH="/opt/tm/tools/nodejs/12.16.1/usr/bin:$PATH"
fi


################################################################################
#                                    python
################################################################################
if linux; then
  export PATH="/opt/tm/tools/python/3.9.6/usr/bin:$PATH"
fi


################################################################################
#                                    pyenv
################################################################################
if osx; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi


################################################################################
#                                    golang
################################################################################
if linux; then
  export GOPATH="$HOME/core3:$HOME/go:$HOME/core3/src/plz-out/go"
  export PATH="$HOME/core3/bin:$PATH"
fi

if osx; then
  export PATH="$HOME/go/bin:$PATH"
fi


################################################################################
#                                    cargo
################################################################################
export PATH="$HOME/.cargo/bin:$PATH"


################################################################################
#                                     plz
################################################################################
if linux; then
  alias sef="plz sef"
fi


################################################################################
#                                     env
################################################################################
export EDITOR=nvim


################################################################################
#                                   kubectl
################################################################################
if linux; then
  export KUBECONFIG=$HOME/.kube/config
  for file in $HOME/.kube/configs/*.yaml; do
    export KUBECONFIG=$KUBECONFIG:$file
  done
fi


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
