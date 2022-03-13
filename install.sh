#!/usr/bin/env bash

source ~/.dotfiles/utils.sh

if osx; then
  cecho "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  pkgs="zsh git tmux exa fzf fd bat ripgrep nvim ranger"
  for pkg in $pkgs; do
      cecho "Installing $pkg..."
      brew install $pkg
  done
fi

if linux; then
  pkgs="zsh git tmux cargo ranger"
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

cecho "Installing Oh My Zsh plugins: fast-syntax-highlighting, zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

cecho "Installing tmux plugin manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cecho "Installing tmux-256color terminfo"
curl -LO http://invisible-island.net/datafiles/current/terminfo.src.gz
gunzip terminfo.src.gz
tic -xe tmux-256color terminfo.src
rm terminfo.src

if osx; then
  cecho "Installing pyenv..."
  curl https://pyenv.run | bash
fi

cecho "Symlinking to new dotfiles..."
ln -isv ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -isv ~/.dotfiles/zshrc ~/.zshrc
mkdir -pv ~/.config/nvim && ln -isv ~/.dotfiles/nvim/* ~/.config/nvim
if linux; then
    mkdir -pv ~/.config/k9s && ln -isv ~/.dotfiles/k9s-skin.yml ~/.config/k9s/skin.yml
fi
if osx; then
  mkdir -pv ~/Library/Application\ Support/ptpython && ln -isv ~/.dotfiles/ptpython-config.py ~/Library/Application\ Support/ptpython/config.py
fi

cecho "Changing login shell..."
chsh -s $(which zsh)

cecho "$(tput bold)Installation complete. Starting zsh..."
exec zsh