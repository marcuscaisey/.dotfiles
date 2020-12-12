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
  gitfast
  gitignore
  per-directory-history
  zsh-autosuggestions
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

export PROMPT='%{$fg_bold[blue]%}%c%{$reset_color%} $(git_prompt_info)'


################################################################################
#                                   aliases
################################################################################
alias lsl="ls -l"
alias lsa="ls -a"
alias lsal="ls -al"
alias lsla=lsal
alias l="ls -algh"

alias rmr="rm -r"


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
