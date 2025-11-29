#!/bin/bash
#
# Dotfiles installation script for Arch Linux + i3
# Assumes base Arch Linux with i3 already installed
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Logging functions
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    error "Please do not run this script as root"
    exit 1
fi

# Update system
info "Updating system..."
sudo pacman -Syu --noconfirm

# Install packages from official repositories
info "Installing packages from official repositories..."
if [ -f "$DOTFILES_DIR/packages/pacman.txt" ]; then
    sudo pacman -S --needed --noconfirm $(grep -vE "^\s*#" "$DOTFILES_DIR/packages/pacman.txt" | tr '\n' ' ')
else
    warn "No pacman.txt found, skipping official packages"
fi

# Install AUR helper if not present
if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
    info "Installing yay (AUR helper)..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
else
    info "AUR helper already installed"
fi

# Install AUR packages
if [ -f "$DOTFILES_DIR/packages/aur.txt" ] && [ -s "$DOTFILES_DIR/packages/aur.txt" ]; then
    info "Installing AUR packages..."
    AUR_HELPER=$(command -v yay || command -v paru)
    $AUR_HELPER -S --needed --noconfirm $(grep -vE "^\s*#" "$DOTFILES_DIR/packages/aur.txt" | tr '\n' ' ')
else
    info "No AUR packages to install"
fi

# Create symlinks for dotfiles
info "Creating symlinks for dotfiles..."

# Create .config directory if it doesn't exist
mkdir -p ~/.config

# Symlink .config directories
for config_dir in "$DOTFILES_DIR/config/"*; do
    if [ -d "$config_dir" ]; then
        target="$HOME/.config/$(basename "$config_dir")"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            warn "Backing up existing $(basename "$config_dir") to ${target}.backup"
            mv "$target" "${target}.backup"
        fi
        ln -sfn "$config_dir" "$target"
        info "Linked $(basename "$config_dir")"
    fi
done

# Symlink home directory dotfiles
for dotfile in "$DOTFILES_DIR/home/".??*; do
    if [ -f "$dotfile" ]; then
        target="$HOME/$(basename "$dotfile")"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            warn "Backing up existing $(basename "$dotfile") to ${target}.backup"
            mv "$target" "${target}.backup"
        fi
        ln -sf "$dotfile" "$target"
        info "Linked $(basename "$dotfile")"
    fi
done

# Create .xinitrc if it doesn't exist
if [ ! -f ~/.xinitrc ]; then
    info "Creating .xinitrc..."
    echo "exec i3" > ~/.xinitrc
fi

# Enable and start services
info "Enabling services..."
sudo systemctl enable lightdm.service
sudo systemctl enable bluetooth.service
sudo systemctl enable iwd.service

# Post-install messages
info ""
info "======================================"
info "Installation complete!"
info "======================================"
info ""
info "Next steps:"
info "1. Review your configuration files in ~/.config"
info "2. Reboot or restart your display manager: sudo systemctl restart lightdm"
info "3. Any existing configs were backed up with .backup extension"
info ""
