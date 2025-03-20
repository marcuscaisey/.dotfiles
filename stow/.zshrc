################################################################################
#                                     PATH
################################################################################
# Remove duplicates from $PATH
typeset -U PATH


################################################################################
#                                  oh my zsh
################################################################################
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

zstyle ':omz:*' aliases no # Skip all aliases, in lib files and enabled plugins

plugins=(
  brew
  fast-syntax-highlighting
  git
  golang
  kube-ps1
  kubectl
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh


################################################################################
#                             zsh autosuggestions
################################################################################
bindkey '^y' autosuggest-accept


################################################################################
#                                    prompt
################################################################################
export PROMPT="%B%F{blue}%c%b%f"


################################################################################
#                                  git prompt
################################################################################
export ZSH_THEME_GIT_PROMPT_PREFIX="%B(%F{216}"
export ZSH_THEME_GIT_PROMPT_SUFFIX="%f)%b "

export PROMPT="$PROMPT"' $(git_prompt_info)'


################################################################################
#                                   kube-ps1
################################################################################
if kubectl config current-context >/dev/null 2>&1; then
  export KUBE_PS1_SYMBOL_ENABLE=false
  export PROMPT='%B$(kube_ps1)%b'" $PROMPT"
fi


################################################################################
#                                   aliases
################################################################################
alias ls="eza"

alias oops="git add --update && git commit --no-edit --amend"

alias yank="perl -pe 'chomp if eof' | tmux load-buffer -w -"

alias d="cd ~/.dotfiles"
alias s="cd ~/scratch"


################################################################################
#                                     fzf
################################################################################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use fd for find instead of default find
export FZF_DEFAULT_COMMAND="fd --follow --type f --exclude .git --strip-cwd-prefix"

# Use ~~ for completion trigger instead of **
export FZF_COMPLETION_TRIGGER='~~'

# Use fd instead of the default find
_fzf_compgen_path() {
    fd --hidden --follow --exclude .git --strip-cwd-prefix .
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude .git --strip-cwd-prefix .
}

# Use ctrl + t to fuzzy search all files/directories (excluding .git) with preview in current directory
export FZF_CTRL_T_COMMAND='fd --follow --strip-cwd-prefix'
export FZF_CTRL_T_OPTS="--preview 'if [ ! -d {} ]; then bat --color always --wrap never --pager never {}; else exa --classify --all --tree --level=2 --color always {}; fi'"

# Catppuccin theme
# Allow selecting / deselecting of all options
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#000000,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
-m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"


################################################################################
#                                    pyenv
################################################################################
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


################################################################################
#                                     pipx
################################################################################
export PATH="$PATH:$HOME/.local/bin"


################################################################################
#                                    golang
################################################################################
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"


################################################################################
#                                    cargo
################################################################################
export PATH="$HOME/.cargo/bin:$PATH"


################################################################################
#                                     plz
################################################################################
_plz_complete_zsh() {
    local args=("${words[@]:1:$CURRENT}")
    local IFS=$'\n'
    local completions=($(GO_FLAGS_COMPLETION=1 ${words[1]} -p -v 0 --noupdate "${args[@]}"))
    for completion in $completions; do
        compadd -S '' $completion
    done
}

compdef _plz_complete_zsh plz


################################################################################
#                                     env
################################################################################
export EDITOR=nvim


################################################################################
#                                   kubectl
################################################################################
export KUBECONFIG="$HOME"/.kube/config
if [ -d "$HOME/.kube/configs" ]; then
  for file in "$HOME"/.kube/configs/*.yaml; do
    export KUBECONFIG="$KUBECONFIG:$file"
  done
fi
export PATH="$HOME/.krew/bin:$PATH"
