# Dotfiles

Personal Arch Linux + i3 configuration files and installation script.

## Prerequisites

- Fresh Arch Linux installation
- i3 window manager installed
- Git installed
- Internet connection

## Installation

1. Clone this repository:
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

2. Run the install script:
```bash
chmod +x install.sh
./install.sh
```

3. Reboot or restart your display manager:
```bash
sudo systemctl restart lightdm
```

## Structure

```
dotfiles/
├── install.sh          # Main installation script
├── packages/
│   ├── pacman.txt     # Official repository packages
│   └── aur.txt        # AUR packages
├── config/            # ~/.config directory contents
│   ├── i3/
│   ├── polybar/
│   ├── rofi/
│   ├── nvim/
│   └── ...
└── home/              # Home directory dotfiles
    ├── .bashrc
    ├── .bash_profile
    └── ...
```

## What Gets Installed

- All packages listed in `packages/pacman.txt` and `packages/aur.txt`
- Configuration files symlinked to their proper locations
- System services enabled (lightdm, bluetooth, iwd)
- AUR helper (yay) if not already installed

## Customization

1. **Add packages**: Edit `packages/pacman.txt` or `packages/aur.txt`
2. **Modify configs**: Edit files in `config/` or `home/` directories
3. **Commit changes**: `git add . && git commit -m "Update config"`

## Backup

The install script automatically backs up any existing configuration files with a `.backup` extension before creating symlinks.

## Notes

- Run `./install.sh` again to update symlinks and install new packages
- Existing configs are preserved as `.backup` files
- The script is idempotent - safe to run multiple times
