#!/bin/bash

###############################################################################
# Set variables                                                               #
###############################################################################

BIN=~/cleanMacOS/bin                # shell scripts
CONFIG=~/cleanMacOS/config          # configuration files directory
SETUP=~/cleanMacOS                  # root folder of cleanMacOS

###############################################################################
# Install                                                                     #
###############################################################################

# Entering as Root
printf "Enter root password...\n"
sudo -v

# Keep alive Root
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Brew
printf "⚙️ Check Brew...\n"
if test ! $(which brew); then
  # Install Homebrew
    printf "📦 Installing XCode CL tools...\n"
    xcode-select --install
    printf "📦 Installing Homebrew...\n"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  # Change permissions
    brew -v
    sudo chown -R $USER /usr/local/Cellar
  # Install MAS
    printf "📦 Installing MAS...\n"
    brew install mas
  # Check Brews
    brew doctor && brew update && brew upgrade
  # Install Homebrew apps
    printf "📦 Installing Apps...\n"
    brew bundle --file=$SETUP/Brewfile
  # Cleanup
    printf "⚙️ Cleanup and final touches...\n"
    brew -v update && brew -v upgrade && brew cask upgrade && mas upgrade && brew -v cleanup --prune=5 && brew doctor
else
    printf "📦 Homebrew is already installed...\n"
    exit

fi

# Exit script
exit
