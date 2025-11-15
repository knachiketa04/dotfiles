# Dotfiles

My personal macOS development environment configuration.

## Overview

This dotfiles repository provides an automated setup for a complete macOS development environment, including window management, terminal configuration, and essential tools.

## What's Included

### Window Manager

- **AeroSpace** - Tiling window manager for macOS

### Terminal

- **Ghostty** - Fast, native, GPU-accelerated terminal emulator
- **Starship** - Fast, customizable cross-shell prompt
- **Fastfetch** - System information display

### Shell Configuration (Zsh)

- **Zinit** - Plugin manager with lazy loading
- **Zsh Plugins:**
  - `zsh-completions` - Additional completion definitions
  - `zsh-autosuggestions` - Fish-like autosuggestions
  - `fzf-tab` - Fuzzy completion with fzf
  - `fast-syntax-highlighting` - Syntax highlighting
- **Oh My Zsh Snippets:**
  - Git integration
  - Sudo plugin
  - Command-not-found suggestions

### CLI Tools

- **lsd** - Modern replacement for `ls` with icons and colors
- **zoxide** - Smarter `cd` command with frecency-based directory jumping
- **fzf** - Command-line fuzzy finder
- **stow** - Symlink manager for dotfiles

### Development

- **Visual Studio Code** - Code editor (installed, settings synced separately)

## Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/knachiketa04/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the installation script:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

The script will:

- Install Homebrew (if not already installed)
- Install all required packages via Homebrew
- Automatically backup existing dotfiles to `~/.dotfiles_backup/YYYY-MM-DD-HH-MM-SS/`
- Symlink configuration files to your home directory using GNU Stow

## Post-Installation

### AeroSpace

AeroSpace requires accessibility permissions to function:

1. Open System Settings > Privacy & Security > Accessibility
2. Add AeroSpace and grant it permission
3. Start AeroSpace

### Visual Studio Code

Sign in to VS Code to sync your existing profile (extensions, settings, keybindings).

## Structure

```
dotfiles/
├── .config/
│   ├── aerospace/
│   │   └── aerospace.toml
│   ├── ghostty/
│   │   └── config
│   └── starship.toml
├── .zshrc
├── install.sh
└── README.md
```

## Maintenance

To update installed packages:

```bash
brew update && brew upgrade
```

To re-run the installation (updates packages and re-stows dotfiles):

```bash
./install.sh
```

## License

MIT
