#!/bin/bash
#
# Sync dotfiles from the current system to the repository
# Run this script to update your dotfiles after making changes
#

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() {
    echo -e "${GREEN}[SYNC]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

info "Syncing dotfiles to repository..."

# Copy home dotfiles
info "Copying home directory dotfiles..."
cp ~/.bashrc "$DOTFILES_DIR/home/.bashrc" 2>/dev/null || warn "No .bashrc found"
cp ~/.bash_profile "$DOTFILES_DIR/home/.bash_profile" 2>/dev/null || warn "No .bash_profile found"

# Copy .config directories
info "Copying .config directories..."
for config_dir in i3 polybar rofi nvim htop picom ghostty; do
    if [ -d ~/.config/$config_dir ]; then
        # Remove the old directory and copy fresh
        rm -rf "$DOTFILES_DIR/config/$config_dir"
        cp -r ~/.config/$config_dir "$DOTFILES_DIR/config/"
        # Remove any nested .git directories
        find "$DOTFILES_DIR/config/$config_dir" -name ".git" -type d -exec rm -rf {} + 2>/dev/null || true
        info "Synced $config_dir"
    else
        warn "~/.config/$config_dir not found"
    fi
done

# Update package list
info "Updating package list..."
pacman -Qqe > "$DOTFILES_DIR/packages/pacman-full.txt"
info "Package list saved to packages/pacman-full.txt (review and update pacman.txt manually)"

info ""
info "Sync complete! Review changes with:"
info "  cd $DOTFILES_DIR && git status"
info ""
info "Then commit and push:"
info "  git add -A"
info "  git commit -m 'Update dotfiles'"
info "  git push"
