#!/usr/bin/env bash

source ~/.dotfiles/scripts/utils.sh

if osx; then
  cecho "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  pkgs="zsh git tmux exa fzf fd bat ripgrep nvim vifm ncurses stow"
  for pkg in $pkgs; do
      cecho "Installing $pkg..."
      brew install $pkg
  done
fi

if linux; then
  pkgs="zsh git tmux cargo vifm stow"
  for pkg in $pkgs; do
      cecho "Installing $pkg..."
      sudo apt install $pkg
  done

  cargo_pkgs="exa fd-find bat ripgrep"
  for pkg in $cargo_pkgs; do
      cecho "Installing $pkg..."
      cargo install $pkg
  done
fi

if osx; then
  cecho "Setting up fzf..."
  $(brew --prefix)/opt/fzf/install
fi
if linux; then
  cecho "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
fi

cecho "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

cecho "Installing Oh My Zsh plugins: fast-syntax-highlighting, zsh-autosuggestions, zsh-vi-mode"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode

cecho "Installing tmux plugin manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

if osx; then
  cecho "Installing tmux-256color terminfo"
  $(brew --prefix ncurses)/bin/infocmp tmux-256color > /tmp/tmux-256color.info
  tic -xve tmux-256color /tmp/tmux-256color.info
  rm /tmp/tmux-256color.info
fi

if osx; then
  cecho "Installing pyenv..."
  curl https://pyenv.run | bash
fi

cecho "Restowing config files..."
source ~/.dotfiles/scripts/restow.sh

cecho "Changing login shell..."
chsh -s $(which zsh)

cecho "$(tput bold)Installation complete. Starting zsh..."
exec zsh
