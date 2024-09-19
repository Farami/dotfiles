#!/bin/zsh

# Install xCode cli tools
echo "Installing commandline tools..."
xcode-select --install

# Homebrew
## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

## Taps
echo "Tapping Brew..."
brew tap homebrew/cask-fonts
brew tap FelixKratz/formulae
brew tap koekeishiya/formulae

## Formulae
echo "Installing Brew Formulae..."
### Essentials
brew install wget
brew install jq
brew install fzf
brew install ripgrep
brew install mas
brew install gh
brew install ifstat
brew install switchaudio-osx
brew install make

brew install skhd
brew install sketchybar
brew install borders
brew install yabai
brew install bclm

### Development
brew install openjdk
brew install openjdk@17
brew install maven

### Terminal
brew install warp
brew install tmux # not really needed anymore with warp
brew install neovim
brew install fish
brew install zoxide

### Nice to have
brew install btop
brew install lazygit
brew install dooit

### Custom HEAD only forks
brew install fnnn --head # nnn fork (changed colors, keymappings)

## Casks
echo "Installing Brew Casks..."
### Terminals & Browsers
brew install --cask microsoft-edge
brew install --cask powershell

### Development
brew install --cask azure-data-studio
brew install --cask cursor
brew install --cask eurkey
brew install --cask git-credential-manager
brew install --cask git-credential-manager-core
brew install --cask temurin
brew install --cask openmtp

### Office
brew install --cask discord
brew install --cask 1password
brew install --cask 1password-cli
brew install --cask skim
brew install --cask vlc
brew install --cask microsoft-office
brew install --cask microsoft-teams
brew install --cask obsidian
brew install --cask fantastical

### Nice to have
brew install --cask raycast
brew install --cask spotify
brew install --cask setapp

### Fonts
brew install --cask sf-symbols
brew install --cask font-hack-nerd-font
brew install --cask font-symbols-only-nerd-font
brew install --cask font-jetbrains-mono
brew install --cask font-fira-code

# Mac App Store Apps
echo "Installing Mac App Store Apps..."
mas install 1451685025 #Wireguard
mas install 497799835  #xCode

# macOS Settings
echo "Changing macOS defaults..."
defaults write com.apple.spaces spans-displays -bool false # Disable spanning spaces across displays
defaults write com.apple.dock autohide -bool true # Enable auto-hide for Dock
defaults write com.apple.dock "mru-spaces" -bool false # Disable rearranging spaces based on recent use
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false # Disable window animations
defaults write com.apple.LaunchServices LSQuarantine -bool false # Disable Launch Services quarantine
defaults write NSGlobalDomain KeyRepeat -int 1 # Set key repeat rate to fastest
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false # Disable automatic spelling correction
defaults write NSGlobalDomain AppleShowAllExtensions -bool true # Show all file extensions in Finder
defaults write NSGlobalDomain _HIHideMenuBar -bool true # Enable auto-hide for the menu bar
defaults write com.apple.finder DisableAllAnimations -bool true # Disable all Finder animations
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false # Hide external hard drives on desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false # Hide internal hard drives on desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false # Hide mounted servers on desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false # Hide removable media on desktop
defaults write com.apple.Finder AppleShowAllFiles -bool true # Show all hidden files in Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # Set Finder search scope to current folder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false # Disable extension change warnings in Finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true # Show POSIX path in Finder window title
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # Set Finder view style to list view
defaults write com.apple.finder ShowStatusBar -bool false # Hide Finder status bar
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES # Disable Time Machine backup prompts for new disks
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false # Disable auto-opening of safe downloads in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true # Enable Develop menu in Safari
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true # Enable WebKit developer extras in Safari
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true # Enable WebKit2 developer extras in Safari
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true # Enable WebKit developer extras globally
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false # Do not include names in Mail address pasteboard
defaults write -g NSWindowShouldDragOnGesture YES # Enable window dragging with gestures


# Copying and checking out configuration files
echo "Planting Configuration Files..."
[ ! -d "$HOME/.config/dotfiles" ] && git clone --bare https://github.com/Farami/dotfiles.git $HOME/.config/dotfiles
git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME/.config checkout master

# Installing Fonts
git clone git@github.com:shaunsingh/SFMono-Nerd-Font-Ligaturized.git /tmp/SFMono_Nerd_Font
mv /tmp/SFMono_Nerd_Font/* $HOME/Library/Fonts
rm -rf /tmp/SFMono_Nerd_Font/

curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

source $HOME/.config/fish/config.fish

# Start Services
echo "Starting Services (grant permissions)..."
brew services start skhd
brew services start fyabai
brew services start sketchybar

csrutil status
echo "(optional) Disable SIP for advanced yabai features."
echo "(optional) Add sudoer manually:\n '$(whoami) ALL = (root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | awk "{print \$1;}") $(which yabai) --load-sa' to '/private/etc/sudoers.d/yabai'"
echo "Installation complete...\n"
