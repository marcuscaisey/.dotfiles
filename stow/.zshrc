################################################################################
#                                     ZSH                                      #
################################################################################
# Use Emacs key bindings.
bindkey -A emacs main

# Remove duplicates from $PATH and $path.
typeset -U PATH path

# Changing Directories
setopt auto_cd # Change to directory without typing cd.
setopt auto_pushd # Make cd push the old directory onto the directory stack.
setopt pushd_ignore_dups # Don't push duplicates onto the directory stack.
setopt pushd_minus # Exchange meaning of +n and -n.

# Completion
zstyle ':completion:*' completer _complete _approximate # Fall back to approximate completion.
zstyle ':completion:*' menu select # Use menu selection.
zstyle ':completion:*' use-cache yes # Cache completions.
setopt always_to_end # Move cursor to the end of a completed word.
setopt complete_in_word # Allow completion within a word.
setopt list_packed # Try to make completion list occupy less lines.

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000 # Keep 1000 lines of history in memory.
SAVEHIST=10000 # Save 1000 lines of history.
setopt hist_ignore_all_dups # Don't enter duplicates into the history list.
setopt hist_reduce_blanks # Remove superfluous blanks from history list.
setopt hist_save_no_dups # Don't save duplicates in history file.
setopt share_history # Share history between all sessions.

# Input/Output
setopt no_flow_control # Disable output flow control (^s/^q).
setopt interactive_comments # Allow comments in interactive shells.

# Prompting
setopt prompt_subst # Allow command substitution in prompts.


################################################################################
#                                    Prompt                                    #
################################################################################
autoload -Uz add-zsh-hook

# Populate git status in vcs_info_msg_0_.
autoload -Uz vcs_info
vcs_info_format=' %B(%F{216}%b%f)%%b'
zstyle ':vcs_info:*' formats $vcs_info_format
zstyle ':vcs_info:*' actionformats $vcs_info_format
zstyle ':vcs_info:*' enable git # Disable all backends apart from git.
zstyle ':vcs_info:*' max-exports 1 # Only set one vcs_info_msg_*_ variable.
add-zsh-hook precmd vcs_info

# Populate duration of last command in _cmd_duration.
local _date_cmd=date
local _mac_has_gdate=false
if [[ $(uname) == "Darwin" ]] && whence gdate >/dev/null; then
  _mac_has_gdate=true
  # MacOS (BSD) date doesn't support %N so use GNU date instead.
  _date_cmd=gdate
fi
if [[ $(uname) == "Linux" || $_mac_has_gdate == true ]]; then
  function _now_millis() {
    $_date_cmd +%s%3N
  }
else
  # Fall back to slower perl if appropriate date command is not available.
  function _now_millis() {
    perl -MTime::HiRes=time -e 'printf("%d", time * 1000)'
  }
fi
function _record_cmd_start() {
  _cmd_start_millis=$(_now_millis)
}
function _set_cmd_duration() {
  if [[ -v _cmd_start_millis ]]; then
    local duration_millis=$(( $(_now_millis) - $_cmd_start_millis ))
    unset _cmd_start_millis
    local formatted_duration
    if (( duration_millis < 1000 )); then
      formatted_duration="${duration_millis}ms"
    else
      printf -v formatted_duration '%.1fs' 'duration_millis / 1000.0'
    fi
    _cmd_duration="%F{8}${formatted_duration}%f"
  fi
}
add-zsh-hook preexec _record_cmd_start
add-zsh-hook precmd _set_cmd_duration

PROMPT='%B%F{blue}%1~%b%f${vcs_info_msg_0_} '
RPROMPT='${_cmd_duration}'


################################################################################
#                                   Aliases                                    #
################################################################################
if whence eza >/dev/null; then
  alias ls=eza
fi
alias oops='git add --update && git commit --no-edit --amend'
alias yank='perl -pe 'chomp if eof' | tmux load-buffer -w -'
alias d='cd ~/.dotfiles'
alias s='cd ~/scratch'


################################################################################
#                                   General                                    #
################################################################################
# Ignore case when searching man pages.
export MANPAGER='less -i'

# Use nvim as default editor.
export EDITOR=nvim


################################################################################
#                                   Homebrew                                   #
################################################################################
if [[ -d /opt/homebrew/bin ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi


################################################################################
#                               zsh-completions                                #
################################################################################
if [[ -d ~/.zsh-plugins/zsh-completions ]]; then
  fpath=(~/.zsh-plugins/zsh-completions/src $fpath)
fi


################################################################################
#                                   compsys                                    #
################################################################################
autoload -Uz compinit
# Initialise completion system.
# Anything that modifies fpath must be done before this.
# Anything that requires compdef must be done after this.
compinit


################################################################################
#                                     Cargo                                    #
################################################################################
if [[ -d ~/.cargo ]]; then
  source ~/.cargo/env
fi


################################################################################
#                           fast-syntax-highlighting                           #
################################################################################
if [[ -d ~/.zsh-plugins/fast-syntax-highlighting ]]; then
  source ~/.zsh-plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi


################################################################################
#                                     fzf                                      #
################################################################################
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh

  # Use fd for find instead of default find
  FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

  # Use ~~ for completion trigger instead of **
  FZF_COMPLETION_TRIGGER='~~'

  # Use fd instead of the default find
  _fzf_compgen_path() {
      fd --hidden --follow --exclude .git --strip-cwd-prefix .
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
      fd --type d --hidden --follow --exclude .git --strip-cwd-prefix .
  }

  # Use ctrl + t to fuzzy search all files/directories (excluding .git) with preview in current directory
  FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
  FZF_CTRL_T_OPTS="--preview 'if [ ! -d {} ]; then bat --color always --wrap never --pager never {}; else exa --classify --all --tree --level=2 --color always {}; fi'"

  # Catppuccin theme
  FZF_DEFAULT_OPTS=" \
  --color=bg+:#313244,bg:#000000,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --color=border:#313244,label:#cdd6f4"
fi


################################################################################
#                                      Go                                      #
################################################################################
export PATH=~/go/bin:$PATH


################################################################################
#                                     pipx                                     #
################################################################################
export PATH=$PATH:~/.local/bin


################################################################################
#                                    Please                                    #
################################################################################
if whence plz >/dev/null; then
  source <(plz --completion_script 2>/dev/null)
fi


################################################################################
#                                    pyenv                                     #
################################################################################
PYENV_ROOT=~/.pyenv
if [[ -d $PYENV_ROOT ]]; then
  export PYENV_ROOT
  export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
  source $PYENV_ROOT/completions/pyenv.zsh
  # Lazy load to avoid slowing down shell startup.
  function pyenv() {
    unfunction pyenv
    eval "$(pyenv init - zsh)"
    pyenv $@
  }
fi


################################################################################
#                             zsh-autosuggestions                              #
################################################################################
if [[ -d ~/.zsh-plugins/zsh-autosuggestions ]]; then
  source ~/.zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  # Disable suggestions for large buffers.
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  # Disable automatic widget re-binding on each precmd.
  ZSH_AUTOSUGGEST_MANUAL_REBIND=true
fi


################################################################################
#                                 local zshrc                                  #
################################################################################
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi
