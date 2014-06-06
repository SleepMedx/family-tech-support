#!/bin/bash
# http://lifehacker.com/how-to-make-your-own-bulk-app-installer-for-os-x-1586252163

# Install homebrew and update
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew update
brew tap caskroom/cask
brew install caskroom/cask/brew-cask

# Install better browsers
brew cask install google-chrome
brew cask install firefox

# Backup and syncing
brew cask install crashplan
brew cask install dropbox

# Password and bookmark managements
brew cask install lastpass-universal

# OS improvements
brew cask install totalfinder
brew cask install totalterminal

# QuickLook Enhancements
brew cask install qlcolorcode
brew cask install qlimagesize
brew cask install qlmarkdown
brew cask install qlprettypatch
brew cask install qlrest
brew cask install qlstephen
brew cask install quicklook-csv
brew cask install quicklook-json
brew cask install quicklook-pfm
