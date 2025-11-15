#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting dotfiles installation...${NC}\n"

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Homebrew not found. Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    echo -e "${GREEN}Homebrew installed successfully!${NC}\n"
else
    echo -e "${GREEN}Homebrew is already installed.${NC}\n"
fi

# Function to install or upgrade a package
install_or_upgrade() {
    local package=$1
    local is_cask=$2
    
    if [ "$is_cask" = "cask" ]; then
        if brew list --cask "$package" &> /dev/null; then
            echo -e "${YELLOW}Upgrading $package (if needed)...${NC}"
            brew upgrade --cask "$package" || echo -e "${GREEN}$package is already up to date.${NC}"
        else
            echo -e "${YELLOW}Installing $package...${NC}"
            brew install --cask "$package"
            echo -e "${GREEN}$package installed successfully!${NC}"
        fi
    else
        if brew list "$package" &> /dev/null; then
            echo -e "${YELLOW}Upgrading $package (if needed)...${NC}"
            brew upgrade "$package" || echo -e "${GREEN}$package is already up to date.${NC}"
        else
            echo -e "${YELLOW}Installing $package...${NC}"
            brew install "$package"
            echo -e "${GREEN}$package installed successfully!${NC}"
        fi
    fi
}

# Install required packages
echo -e "${YELLOW}Installing/upgrading required packages...${NC}\n"
install_or_upgrade "nikitabobko/tap/aerospace" "cask"
install_or_upgrade "ghostty" "cask"
install_or_upgrade "stow" ""
install_or_upgrade "fastfetch" ""
install_or_upgrade "lsd" ""
install_or_upgrade "zoxide" ""
install_or_upgrade "starship" ""
install_or_upgrade "fzf" ""
install_or_upgrade "visual-studio-code" "cask"

echo ""

# Backup existing dotfiles if they exist
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y-%m-%d-%H-%M-%S)"
NEEDS_BACKUP=false

if [ -f "$HOME/.zshrc" ] || [ -d "$HOME/.config/aerospace" ] || [ -d "$HOME/.config/ghostty" ]; then
    NEEDS_BACKUP=true
    mkdir -p "$BACKUP_DIR"
    echo -e "${YELLOW}Backing up existing dotfiles to $BACKUP_DIR${NC}"
    
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$BACKUP_DIR/.zshrc"
        echo "  - Backed up .zshrc"
    fi
    
    if [ -d "$HOME/.config/aerospace" ]; then
        mkdir -p "$BACKUP_DIR/.config"
        cp -r "$HOME/.config/aerospace" "$BACKUP_DIR/.config/"
        echo "  - Backed up .config/aerospace"
    fi
    
    if [ -d "$HOME/.config/ghostty" ]; then
        mkdir -p "$BACKUP_DIR/.config"
        cp -r "$HOME/.config/ghostty" "$BACKUP_DIR/.config/"
        echo "  - Backed up .config/ghostty"
    fi
    
    echo -e "${GREEN}Backup completed!${NC}\n"
fi

# Get the directory where the script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Symlink dotfiles using stow
echo -e "${YELLOW}Symlinking dotfiles using stow...${NC}"
cd "$DOTFILES_DIR"
stow --ignore='README.md|install.sh|.git' -v -t "$HOME" .

echo -e "\n${GREEN}✓ Dotfiles installation completed successfully!${NC}"

if [ "$NEEDS_BACKUP" = true ]; then
    echo -e "${YELLOW}Your previous dotfiles were backed up to: $BACKUP_DIR${NC}"
fi

