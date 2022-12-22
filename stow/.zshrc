source ~/.dotfiles/scripts/utils.sh


################################################################################
#                                 zsh-vi-mode
################################################################################
function zvm_config() {
  ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
}
function zvm_after_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  bindkey -M viins '^ ' autosuggest-accept
  bindkey -M viins '^g' per-directory-history-toggle-history
}
function zvm_after_lazy_keybindings() {
  bindkey -M vicmd 'gh' vi-first-non-blank
  bindkey -M vicmd 'gl' vi-end-of-line
  bindkey -M menuselect 'h' vi-backward-char
  bindkey -M menuselect 'k' vi-up-line-or-history
  bindkey -M menuselect 'l' vi-forward-char
  bindkey -M menuselect 'j' vi-down-line-or-history
}


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
  # please
  zsh-vi-mode
  tmux
  zsh-autosuggestions
)

if linux; then
  plugins=(kubectl kube-ps1 $plugins)
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

if osx; then
  plugins=(docker $plugins)
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
alias vimo='nvim -c "e #<1"'

# git
alias oops="gau && gcn!"
alias conflicts='vim -q <(git diff --name-only --diff-filter=U | sed -e "s@^@$(git rev-parse --show-toplevel)/@" -e "s/$/:1:conflicts/" | xargs realpath --relative-to $(pwd)) +copen'
alias gcfd="git clean -fd"
alias grbm='git fetch origin master:master && git rebase -i --onto master $(git rev-parse --abbrev-ref --symbolic-full-name @{u}) && git branch --set-upstream-to=master'

alias d="cd ~/.dotfiles"
alias s="cd ~/scratch"

# tmux
# start a new session with the same name as the current git branch
tgb() {
    tmux new-session -s $(git rev-parse --abbrev-ref HEAD)
}


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
    fd --hidden --follow --exclude .git . $1
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude .git . $1
}

# Use ctrl + t to fuzzy search all files/directories (excluding .git) with preview in current directory
export FZF_CTRL_T_COMMAND='fd --follow --strip-cwd-prefix'
export FZF_CTRL_T_OPTS="--preview 'if [ ! -d {} ]; then bat --color=always {}; else echo Directory: {}; fi'"


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
  # don't want pip installed stuff to get in the way of toolchain stuff
  export PATH="$PATH:$HOME/.local/bin"
fi


################################################################################
#                                     java
################################################################################
if linux; then
    export JAVA_HOME="/opt/tm/tools/openjdk/11.0.4/usr/lib/jvm/openjdk"
    export PATH="$JAVA_HOME/bin:$PATH"
fi


################################################################################
#                                    pyenv
################################################################################
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


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
#                                     yarn
################################################################################
export PATH="$HOME/.yarn/bin:$PATH"


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
if linux; then
  export KUBECONFIG=$HOME/.kube/config
  for file in $HOME/.kube/configs/*.yaml; do
    export KUBECONFIG=$KUBECONFIG:$file
  done
fi


################################################################################
#                                    stern
################################################################################
function stern-jq {
    stern -o raw "$@" | jq -rR '. as $raw | try (fromjson) catch ("\u001b[31m" + $raw + "\u001b[0m")'
}


################################################################################
#                                     nvm
################################################################################
if osx; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi
