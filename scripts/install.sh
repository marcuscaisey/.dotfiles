#!/usr/bin/env bash

set -euo pipefail

# osx
# Returns if we're running on osx
osx() {
  [ "$(uname)" = "Darwin" ]
}

# linux
# Returns if we're running on linux
linux() {
  [ "$(uname)" = "Linux" ]
}

# clone_or_pull <repository> <directory>
# Clones a repository into a directory if it doesn't exist, otherwise pulls in the latest changes.
clone_or_pull() {
  if [ ! -d "$2" ]; then
    git clone --depth 1 "$1" "$2"
  else
    git -C "$2" pull
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

  cecho "Updating list of available packages"
  brew update

  pkgs="zsh git tmux eza fzf fd bat ripgrep vifm ncurses stow git-delta curl make cmake gettext gcc kubectl"
  cecho "Installing $pkgs"
  brew install $pkgs
fi

if linux; then
  cecho "Updating list of available packages"
  sudo apt update

  pkgs="zsh git tmux eza fd-find bat ripgrep vifm stow curl make cmake gettext g++"
  cecho "Installing $pkgs"
  sudo apt install -y $pkgs

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

if linux; then
  cecho "Linking fd to fdfind"
  sudo ln -sfv "$(which fdfind)" /usr/local/bin/fd

  cecho "Linking bat to batcat"
  sudo ln -sfv "$(which batcat)" /usr/local/bin/bat
fi

if linux; then
  cecho "Installing fzf"
  clone_or_pull https://github.com/junegunn/fzf.git ~/.fzf
  fzf_install=~/.fzf/install
else
  fzf_install="$(brew --prefix)/opt/fzf/install"
fi

cecho "Setting up fzf"
$fzf_install --key-bindings --no-completion --no-update-rc

cecho "Installing ZSH plugins: fast-syntax-highlighting, zsh-autosuggestions, zsh-completions"
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions ~/.zsh-plugins/zsh-autosuggestions
clone_or_pull https://github.com/zdharma-continuum/fast-syntax-highlighting ~/.zsh-plugins/fast-syntax-highlighting
clone_or_pull https://github.com/zsh-users/zsh-completions.git ~/.zsh-plugins/zsh-completions

cecho "Installing tmux plugin manager"
clone_or_pull https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

if osx; then
  cecho "Installing tmux-256color terminfo"
  "$(brew --prefix ncurses)"/bin/infocmp tmux-256color > /tmp/tmux-256color.info
  tic -xve tmux-256color /tmp/tmux-256color.info
  rm /tmp/tmux-256color.info
fi

cecho "Installing pyenv"
if [ ! -d ~/.pyenv ]; then
  curl https://pyenv.run | bash
else
  ~/.pyenv/bin/pyenv update
fi

cecho "Installing nvim"
mkdir -p ~/scratch
clone_or_pull https://github.com/neovim/neovim ~/scratch/neovim
make -C ~/scratch/neovim CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/opt/neovim
sudo make -C ~/scratch/neovim install
sudo ln -sfv /opt/neovim/bin/nvim /usr/local/bin/nvim

cecho "Moving .zshrc -> .zshrc.old"
mv -iv ~/.zshrc ~/.zshrc.old

cecho "Restowing config files"
~/.dotfiles/scripts/restow.sh

cecho "Updating bat theme cache"
bat cache --build

cecho "Installation complete. Starting zsh"
exec zsh
