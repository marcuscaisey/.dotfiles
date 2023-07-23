#!/usr/bin/env bash

set -euo pipefail

source ~/.dotfiles/scripts/utils.sh

# clone_or_pull <repository> <directory>
# Clones a repository into a directory if it doesn't exist, otherwise pulls in the latest changes.
clone_or_pull() {
  if [ -d "$2" ]; then
    git -C "$2" pull
  else
    git clone --depth 1 "$1" "$2"
  fi
}

# cecho <message>
# Displays a line of text in a different colour each time its called.
cecho() {
  echo "$(tput setaf "${ci:-1}")$1$(tput sgr0)" && ci=$(( (${ci:-1} % 6) + 1 ))
}

if osx; then
  cecho "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  pkgs="zsh git tmux exa fzf fd bat ripgrep vifm ncurses stow git-delta tree-sitter curl make cmake"
  for pkg in $pkgs; do
      cecho "Installing $pkg"
      brew install "$pkg"
  done
fi

if linux; then
  cecho "Updating list of available packages"
  sudo apt update

  pkgs="zsh git tmux exa fzf fd-find bat ripgrep vifm stow curl make cmake"
  for pkg in $pkgs; do
      cecho "Installing $pkg"
      sudo apt install -y "$pkg"
  done

  cecho "Installing rust"
  curl https://sh.rustup.rs -sSf | sh -s -- -y

  cecho "Sourcing ~/.cargo/env"
  source ~/.cargo/env

  cargo_pkgs="git-delta"
  for pkg in $cargo_pkgs; do
      cecho "Installing $pkg"
      cargo install "$pkg"
  done
fi

cecho "Setting up fzf"
if osx; then
  fzf_install="$(brew --prefix)"/opt/fzf/install
else
  fzf_install=~/.fzf/install
fi
$fzf_install --key-bindings --no-completion --no-update-rc

cecho "Installing Oh My Zsh"
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
fi

cecho "Installing Oh My Zsh plugins: fast-syntax-highlighting, zsh-autosuggestions, zsh-vi-mode"
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
clone_or_pull https://github.com/zdharma-continuum/fast-syntax-highlighting ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
clone_or_pull https://github.com/jeffreytse/zsh-vi-mode ~/.oh-my-zsh/custom/plugins/zsh-vi-mode

cecho "Installing tmux plugin manager"
clone_or_pull https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

if osx; then
  cecho "Installing tmux-256color terminfo"
  "$(brew --prefix ncurses)"/bin/infocmp tmux-256color > /tmp/tmux-256color.info
  tic -xve tmux-256color /tmp/tmux-256color.info
  rm /tmp/tmux-256color.info
fi

cecho "Installing pyenv"
curl https://pyenv.run | bash

cecho "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

cecho "Installing nvim"
mkdir -p ~/scratch
clone_or_pull https://github.com/neovim/neovim ~/scratch/neovim
make -C ~/scratch/neovim CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/opt/neovim
sudo make -C ~/scratch/neovim install

cecho "Removing .zshrc"
rm -v ~/.zshrc

cecho "Restowing config files"
~/.dotfiles/scripts/restow.sh

cecho "Changing login shell"
chsh -s "$(which zsh)"

cecho "$(tput bold)Installation complete. Starting zsh"
exec zsh
