#!/bin/bash

set -xeo pipefail

# --- Setting up everything in fresh macOS install ---
# DO NOT TREAT THIS AS A REAL SCRIPT, IT IS JUST A TEMPLATE FOR OWN USE

# Install Iterm2
# https://iterm2.com/downloads/stable/latest

# Install VSCode
# https://code.visualstudio.com/docs/setup/mac

# Install Notion
# https://www.notion.so/desktop

# Install Chrome
# https://www.google.com/chrome/

# Install Rosetta 2 for Apple Silicon Macs
sudo softwareupdate --install-rosetta

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Iterm shell integration
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash

# Tune Dock auto-hide settings - make it faster
defaults write com.apple.dock autohide-delay -float 0; killall Dock
defaults write com.apple.dock autohide-time-modifier -float 0.5; killall Dock

# Disable Gatekeeper
sudo spctl --master-disable

# Install all brew packages
brew bundle install --file=~/Brewfile

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Configure oh-my-zsh
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $ZSH_CUSTOM/plugins/autoupdate
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
brew install zsh-syntax-highlighting

# Install pure prompt for zsh
npm install --global pure-prompt

# Copy TerminalStuff from external disk to Downloads
mv Downloads/TerminalStuff/config_nvim ~/.config/.nvim
mkdir ~/.ssh/
cp Downloads/TerminalStuff/Users/ibondarev/.ssh/* ~/.ssh
mv Downloads/TerminalStuff/gitconfig ~/.gitconfig
mv Downloads/TerminalStuff/terraformrc ~/.terraformrc
mv Downloads/TerminalStuff/vimrc ~/.vimrc
mv Downloads/TerminalStuff/zshrc ~/.zshrc
mv Downloads/TerminalStuff/bash_aliases ~/.bash_aliases
