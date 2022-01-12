#!/bin/bash

###############################################################################
# Set variables                                                               #
###############################################################################

BIN=~/Clean-macOS/bin                # shell scripts
CONFIG=~/Clean-macOS/config          # configuration files directory
SETUP=~/Clean-macOS                  # root folder of Clean-macOS

###############################################################################
# Configure                                                                   #
###############################################################################

# Entering as Root
printf "Enter root password...\n"
sudo -v

# Keep alive Root
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Visual Studio Code plugins [1/2]
printf "⚙️ Put Visual Studio Code in quarantine to install plugins...\n"
xattr -dr com.apple.quarantine /Applications/Visual\ Studio\ Code.app
printf "📦 Install Visual Studio Code plugins...\n"
open -a "Visual Studio Code"
code --install-extension github.copilot
code --install-extension svelte.svelte-vscode
code --install-extension eseom.nunjucks-template
code --install-extension ritwickdey.liveserver
code --install-extension adamhartford.vscode-base64

# Update Visual Studio Code settings [2/2]
printf "⚙️ Update Visual Studio Code settings...\n"
sudo rm -rf ~/Library/Application\ Support/Code/User/settings.json > /dev/null 2>&1
cp $CONFIG/settings.json ~/Library/Application\ Support/Code/User/settings.json

# Update Git settings [1/1]
printf "⚙️ Update Git settings...\n"
sudo rm -rf ~/.gitconfig > /dev/null 2>&1
sudo rm -rf ~/.gitignore > /dev/null 2>&1
cp $CONFIG/.gitignore ~/.gitignore
cp $CONFIG/.gitconfig ~/.gitconfig

# Configure macOS Finder
printf "⚙️ Configure Finder...\n"
# defaults write -g AppleShowAllExtensions -bool true
# defaults write com.apple.finder AppleShowAllFiles true
defaults write com.apple.finder QLEnableTextSelection -bool true
defaults write com.apple.finder FXPreferredViewStyle clmv
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
chflags nohidden ~/Library
# /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Configure macOS Screen Capture
printf "⚙️ Save screenshots in PNG format...\n"
mkdir ~/Pictures/Screenshots
defaults write com.apple.screencapture location -string "~/Pictures/Screenshots"
defaults write com.apple.screencapture type -string "png"

# Configure macOS Safari
printf "⚙️ Configure Safari...\n"
# defaults write com.apple.Safari UniversalSearchEnabled -bool false
# defaults write com.apple.Safari SuppressSearchSuggestions -bool true
# defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults write com.apple.Safari ShowFavoritesBar -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true

# Configure macOS TextEdit
printf "⚙️ Configure TextEdit...\n"
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Configure macOS Trackpad
printf "⚙️ Configure Trackpad...\n"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadHandResting -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadHorizScroll -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadMomentumScroll -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadScroll -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
# defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Configure macOS
printf "⚙️ Various configuration...\n"
defaults write com.apple.gamed Disabled -bool true
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write com.apple.dock orientation -string left
defaults write com.apple.dock mineffect -string suck
# sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Create Projects directory
printf "⚙️ Create Projects directory...\n"
mkdir ${HOME}/Tomfoolery/
chmod 777 ${HOME}/Tomfoolery/

# Check if Python3 is installed via Homebrew
#if brew ls --versions python3 > /dev/null; then
#  brew uninstall --ignore-dependencies python3
#else
#  echo "Python3 is not installed! Install it from https://www.python.org"
#fi

# Cleanup
printf "⚙️ Cleanup and final touches...\n"
brew -v update && brew -v upgrade && brew cask upgrade && mas upgrade && brew -v cleanup --prune=2 && brew doctor

# Exit script
exit
