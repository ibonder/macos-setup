#!/bin/bash

set -xeo pipefail

# --- Setting up everything in fresh macOS install ---
# DO NOT TREAT THIS AS A REAL SCRIPT, IT IS JUST A TEMPLATE FOR OWN USE

# Install Chrome
# https://www.google.com/chrome/

# Install Iterm2
# https://iterm2.com/downloads/stable/latest

# Install VSCode
# https://code.visualstudio.com/docs/setup/mac

# Install Notion
# https://www.notion.so/desktop

# Install Rosetta 2 for Apple Silicon Macs
sudo softwareupdate --install-rosetta

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.zshrc

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
brew install git
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $ZSH_CUSTOM/plugins/autoupdate
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# Optional: zshrc clones zsh-defer itself on first run if it's missing, and
# falls back to eager loading if that fails. Listed here only to make the
# dependency visible; running it just saves the first shell a clone.
git clone --depth 1 https://github.com/romkatv/zsh-defer ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-defer
brew install zsh-syntax-highlighting

# Install pure prompt for zsh
brew install pure

# Copy TerminalStuff from external disk to Downloads
# Neovim only reads ~/.config/nvim — a leading dot here silently disables the
# entire config. If this repo is cloned locally, symlinking it instead of
# moving keeps edits live (see README).
mkdir -p ~/.config
mv Downloads/TerminalStuff/config_nvim ~/.config/nvim
mkdir ~/.ssh/
cp Downloads/TerminalStuff/Users/XXX/.ssh/* ~/.ssh
mv Downloads/TerminalStuff/gitconfig ~/.gitconfig
mv Downloads/TerminalStuff/terraformrc ~/.terraformrc
mv Downloads/TerminalStuff/vimrc ~/.vimrc
mv Downloads/TerminalStuff/zshrc ~/.zshrc
mv Downloads/TerminalStuff/bash_aliases ~/.bash_aliases
mv Downloads/TerminalStuff/aws_config ~/.aws/config

# LDAP/SSO credential file sourced by ~/.zshrc — fill in the two values inside,
# see the "Personal data to fill in" table in README.md
mkdir -p ~/.config/company
mv Downloads/TerminalStuff/config_company/env ~/.config/company/env
chmod 600 ~/.config/company/env
