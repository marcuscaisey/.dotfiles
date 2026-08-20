################################################################################
#                                     ZSH                                      #
################################################################################
# Use Emacs key bindings.
bindkey -A emacs main

# CTRL+x CTRL+e to edit the command line in $EDITOR.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M emacs '^x^e' edit-command-line

# Automatically escape URLs.
autoload -Uz url-quote-magic bracketed-paste-magic
zle -N self-insert url-quote-magic
zle -N bracketed-paste bracketed-paste-magic

# Disable highlighting pasted text.
zle_highlight+=(paste:none)

# Remove duplicates from $PATH, $path, $FPATH, and $fpath.
typeset -U PATH path FPATH fpath

# Don't jump over | with ESC-f, ESC-b, ^W, etc
WORDCHARS="|$WORDCHARS"

# Delete backwards until = with ^W
WORDCHARS=${WORDCHARS/=/}

# Changing Directories
setopt auto_pushd # Make cd push the old directory onto the directory stack.
setopt pushd_ignore_dups # Don't push duplicates onto the directory stack.

# Completion
zstyle ':completion:*' completer _complete _approximate # Fall back to approximate completion.
zstyle ':completion:*' menu select # Use menu selection.
zstyle ':completion:*' use-cache yes # Cache completions.
zstyle ':completion:*' group-name '' # Group matches by type
zstyle ':completion:*:descriptions' format '%B%d%b' # Describe what is being completed above matches
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
update_git_prompt() {
    local dir=$PWD git_dir head ref
    while [[ $dir != / ]]; do
        if [[ -f $dir/.git/HEAD ]]; then
            git_dir=$dir/.git
            break
        elif [[ -f $dir/.git ]]; then
            # Worktrees/submodules have a .git file rather than directory
            local line
            IFS= read -r line <$dir/.git
            git_dir=${line#git_dir: }
            [[ $git_dir != /* ]] && git_dir=$dir/$git_dir
            break
        fi
        dir=${dir:h}
    done
    if [[ -z $git_dir ]]; then
        git_prompt=''
        return
    fi
    IFS= read -r head <$git_dir/HEAD
    if [[ $head == 'ref: refs/heads/'* ]]; then
        ref=${head#ref: refs/heads/}
    else
        # Detached HEAD
        ref=${head[1,7]}
    fi
    git_prompt=" %B(%F{216}${ref}%f)%b"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd update_git_prompt

PROMPT='%B%F{blue}%1~%b%f${git_prompt} '


################################################################################
#                                   Aliases                                    #
################################################################################
if whence eza >/dev/null; then
    alias ls=eza
fi
alias oops='git add --update && git commit --no-edit --amend'
alias yank="perl -pe 'chomp if eof' | tmux load-buffer -w -"
alias d='cd ~/.dotfiles'
alias s='cd ~/scratch'
alias g='cd $(git rev-parse --show-toplevel)'


################################################################################
#                                   General                                    #
################################################################################
# Use Neovim as man pager.
if whence nvim >/dev/null; then
    export MANPAGER='nvim +Man!'
fi

# Use Neovim as default editor.
if whence nvim >/dev/null; then
    export EDITOR=nvim
fi

# Ghostty sets this itself which conflicts with brew shellenv setting it below.
# Unset it here and then add ghostty's path to it after we've set up homebrew.
unset MANPATH


################################################################################
#                                   Homebrew                                   #
################################################################################
brew=/opt/homebrew/bin/brew
brew_shellenv=~/.cache/brew_shellenv.zsh
if [[ -x $brew ]]; then
    if [[ ! -f $brew_shellenv || $brew -nt $brew_shellenv ]]; then
        mkdir -p ${brew_shellenv:h}
        $brew shellenv >$brew_shellenv
    fi
    source $brew_shellenv
fi

export TERMINFO_DIRS=$HOMEBREW_PREFIX/opt/ncurses/share/terminfo:


################################################################################
#                                   ghostty                                    #
################################################################################
if ghostty=$(whence ghostty 2>/dev/null); then
    export MANPATH=$MANPATH:${ghostty:h:h}/Resources/man
fi


################################################################################
#                               zsh-completions                                #
################################################################################
if [[ -d ~/.local/share/zsh/plugins/zsh-completions ]]; then
    fpath=(~/.local/share/zsh/plugins/zsh-completions/src $fpath)
fi


################################################################################
#                                   compsys                                    #
################################################################################
# Initialise completion system.
# Anything that modifies fpath must be done before this.
# Anything that requires compdef must be done after this.

# Taken from https://github.com/zimfw/completion/blob/master/init.zsh
# Slightly faster than compinit at checking whether ~/.zcompdump needs to be
# regenerated
() {
    builtin emulate -L zsh -o EXTENDED_GLOB
    # Check if dumpfile is up-to-date by comparing the full path and
    # last modification time of all the completion functions in fpath.
    local zdumpfile=~/.zcompdump zold_dat LC_ALL=C
    local -a zmtimes
    local -i zdump_dat=1
    local -r zcomps=(${^fpath}/^([^_]*|*~|*.zwc)(N))
    if (( ${#zcomps} )); then
        zmodload -F zsh/stat b:zstat && zstat -A zmtimes +mtime ${zcomps} || return 1
    fi
    local -r znew_dat=${ZSH_VERSION}$'\0'${(pj:\0:)zcomps}$'\0'${(pj:\0:)zmtimes}
    if [[ -e ${zdumpfile}.dat ]]; then
        zmodload -F zsh/system b:sysread && sysread -s ${#znew_dat} zold_dat <${zdumpfile}.dat || return 1
        [[ ${zold_dat} == ${znew_dat} ]] && zdump_dat=0
    fi
    if (( zdump_dat )); then
        command rm -f \
            "$zdumpfile" \
            "${zdumpfile}.dat" \
            "${zdumpfile}.zwc" \
            "${zdumpfile}.zwc.old" || return 1
    fi

    # Load and initialize the completion system
    autoload -Uz compinit && compinit -C -d ${zdumpfile} && [[ -e ${zdumpfile} ]] || return 1

    if [[ ! ${zdumpfile}.dat -nt ${zdumpfile} ]]; then
        >! ${zdumpfile}.dat <<<${znew_dat}
    fi
    # Compile the completion dumpfile; significant speedup
    [[ ! ${zdumpfile}.zwc -nt ${zdumpfile} ]] && zcompile ${zdumpfile}
}


################################################################################
#                                     Cargo                                    #
################################################################################
if [[ -d ~/.cargo ]]; then
    source ~/.cargo/env
fi


################################################################################
#                                     fzf                                      #
################################################################################
if fzf=$(whence fzf 2>/dev/null); then
    fzf_zsh=~/.cache/fzf.zsh
    if [[ ! -f $fzf_zsh || $fzf -nt $fzf_zsh ]]; then
        mkdir -p ${fzf_zsh:h}
        $fzf --zsh >$fzf_zsh
    fi
    source $fzf_zsh
    # Use fd for find instead of default find
    FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git'
    # Use ~~ for completion trigger instead of **
    FZF_COMPLETION_TRIGGER='~~'
    # Use fd instead of the default find
    _fzf_compgen_path() {
        fd --hidden --exclude .git --strip-cwd-prefix .
    }
    # Use fd to generate the list for directory completion
    _fzf_compgen_dir() {
        fd --type d --hidden --exclude .git --strip-cwd-prefix .
    }
    # Use ctrl + t to fuzzy search all files/directories (excluding .git) with preview in current directory
    FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
    FZF_CTRL_T_OPTS="--preview 'if [ ! -d {} ]; then bat --color always --wrap never --pager never {}; else exa --classify --all --tree --level=2 --color always {}; fi'"
    # Nord theme
    FZF_DEFAULT_OPTS=" \
        --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1 \
        --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1 \
        --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac \
        --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b"
fi


################################################################################
#                                     Git                                      #
################################################################################
if [[ -f $HOMEBREW_PREFIX/share/zsh/site-functions/_git ]]; then
    # The completions installed with homebrew git are not very good
    rm $HOMEBREW_PREFIX/share/zsh/site-functions/_git
fi


################################################################################
#                                      Go                                      #
################################################################################
export PATH="$HOME/go/bin:$PATH"


################################################################################
#                                     nvm                                      #
################################################################################
NVM_DIR=~/.nvm
if [[ -d $NVM_DIR ]]; then
    source $NVM_DIR/bash_completion
    default_version_path=$NVM_DIR/alias/default
    if [[ -f $default_version_path ]]; then
        export PATH="$NVM_DIR/versions/node/$(<$default_version_path)/bin:$PATH"
    fi
    function nvm() {
        unfunction nvm
        source $NVM_DIR/nvm.sh
        $0 $@
    }
fi


################################################################################
#                                     Nord                                     #
################################################################################
export LS_COLORS='no=00:rs=0:fi=00:di=01;34:ln=36:mh=04;36:pi=04;01;36:so=04;33:do=04;01;36:bd=01;33:cd=33:or=31:mi=01;37;41:ex=01;36:su=01;04;37:sg=01;04;37:ca=01;37:tw=01;37;44:ow=01;04;34:st=04;37;44:*.7z=01;32:*.ace=01;32:*.alz=01;32:*.arc=01;32:*.arj=01;32:*.bz=01;32:*.bz2=01;32:*.cab=01;32:*.cpio=01;32:*.deb=01;32:*.dz=01;32:*.ear=01;32:*.gz=01;32:*.jar=01;32:*.lha=01;32:*.lrz=01;32:*.lz=01;32:*.lz4=01;32:*.lzh=01;32:*.lzma=01;32:*.lzo=01;32:*.rar=01;32:*.rpm=01;32:*.rz=01;32:*.sar=01;32:*.t7z=01;32:*.tar=01;32:*.taz=01;32:*.tbz=01;32:*.tbz2=01;32:*.tgz=01;32:*.tlz=01;32:*.txz=01;32:*.tz=01;32:*.tzo=01;32:*.tzst=01;32:*.war=01;32:*.xz=01;32:*.z=01;32:*.Z=01;32:*.zip=01;32:*.zoo=01;32:*.zst=01;32:*.aac=32:*.au=32:*.flac=32:*.m4a=32:*.mid=32:*.midi=32:*.mka=32:*.mp3=32:*.mpa=32:*.mpeg=32:*.mpg=32:*.ogg=32:*.opus=32:*.ra=32:*.wav=32:*.3des=01;35:*.aes=01;35:*.gpg=01;35:*.pgp=01;35:*.doc=32:*.docx=32:*.dot=32:*.odg=32:*.odp=32:*.ods=32:*.odt=32:*.otg=32:*.otp=32:*.ots=32:*.ott=32:*.pdf=32:*.ppt=32:*.pptx=32:*.xls=32:*.xlsx=32:*.app=01;36:*.bat=01;36:*.btm=01;36:*.cmd=01;36:*.com=01;36:*.exe=01;36:*.reg=01;36:*~=02;37:*.bak=02;37:*.BAK=02;37:*.log=02;37:*.log=02;37:*.old=02;37:*.OLD=02;37:*.orig=02;37:*.ORIG=02;37:*.swo=02;37:*.swp=02;37:*.bmp=32:*.cgm=32:*.dl=32:*.dvi=32:*.emf=32:*.eps=32:*.gif=32:*.jpeg=32:*.jpg=32:*.JPG=32:*.mng=32:*.pbm=32:*.pcx=32:*.pgm=32:*.png=32:*.PNG=32:*.ppm=32:*.pps=32:*.ppsx=32:*.ps=32:*.svg=32:*.svgz=32:*.tga=32:*.tif=32:*.tiff=32:*.xbm=32:*.xcf=32:*.xpm=32:*.xwd=32:*.xwd=32:*.yuv=32:*.anx=32:*.asf=32:*.avi=32:*.axv=32:*.flc=32:*.fli=32:*.flv=32:*.gl=32:*.m2v=32:*.m4v=32:*.mkv=32:*.mov=32:*.MOV=32:*.mp4=32:*.mpeg=32:*.mpg=32:*.nuv=32:*.ogm=32:*.ogv=32:*.ogx=32:*.qt=32:*.rm=32:*.rmvb=32:*.swf=32:*.vob=32:*.webm=32:*.wmv=32:';


################################################################################
#                                     pipx                                     #
################################################################################
export PATH=$PATH:~/.local/bin


################################################################################
#                                  Playground                                  #
################################################################################
if ! whence pg >/dev/null; then
    function pg() {
        ( cd ~/scratch/playground && go build -o build/pg ./cmd/pg && ./build/pg "$@" )
    }
    source <(pg -completion-script zsh)
fi


################################################################################
#                                    Please                                    #
################################################################################
export PATH="$HOME/.please/bin:$PATH"
plz_zsh=~/.cache/plz.zsh
if plz=$(whence plz 2>/dev/null); then
    if [[ ! -f $plz_zsh || $plz -nt $plz_zsh ]]; then
        mkdir -p ${plz_zsh:h}
        $plz --completion_script >$plz_zsh
    fi
    source $plz_zsh
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
if [[ -d ~/.local/share/zsh/plugins/zsh-autosuggestions ]]; then
    source ~/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    # Disable suggestions for large buffers.
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    # Disable automatic widget re-binding on each precmd.
    ZSH_AUTOSUGGEST_MANUAL_REBIND=true

    # Speed up pasting by disabling autosuggestions.
    # https://github.com/zsh-users/zsh-autosuggestions/issues/238
    pasteinit() {
        OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
        zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
    }
    pastefinish() {
        zle -N self-insert $OLD_SELF_INSERT
    }
    zstyle :bracketed-paste-magic paste-init pasteinit
    zstyle :bracketed-paste-magic paste-finish pastefinish
fi


################################################################################
#                                 local zshrc                                  #
################################################################################
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi


################################################################################
#                           zsh-syntax-highlighting                            #
################################################################################
if [[ -d ~/.local/share/zsh/plugins/zsh-syntax-highlighting ]]; then
    source ~/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
