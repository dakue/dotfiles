#!/bin/bash

# tmux tpm
if [ ! -d "$HOME/.tmux/plugins/tpm" ]
then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# vim plug
if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]
then
  curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
mkdir -p ~/.config/nvim
ln -s $(pwd)/config/nvim/init.vim $HOME/.config/nvim/init.vim
nvim --headless +PlugInstall +UpdateRemotePlugins +qall

pacman -Q nodejs npm > /dev/null
if [ $? -eq 1 ]
then
  sudo pacman -Sy --noconfirm nodejs npm
fi
ln -s $(pwd)/.npmrc $HOME/.npmrc
mkdir -p $HOME/.local/npm

npm list -g bash-language-server yaml-language-server > /dev/null
if [ $? -eq 1 ]
then
  npm install -g bash-language-server yaml-language-server
fi

pacman -Q chromium xss-lock i3lock xclip neovim python-pynvim python-pip ansible > /dev/null
if [ $? -eq 1 ]
then
  sudo pacman -Sy --noconfirm chromium xss-lock i3lock xclip neovim python-pynvim python-pip ansible
fi
