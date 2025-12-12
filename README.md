# Dotfiles

Personal Arch Linux configuration files and installation script.

Supports both **i3** (X11) and **Sway** (Wayland) window managers.

## Prerequisites

- Fresh Arch Linux installation
- Git installed
- Internet connection
- For NVIDIA GPUs: nvidia-open-dkms driver recommended

## Quick Start Installation

For a fresh Arch install, use this streamlined process:

### 1. During archinstall
- Select **minimal** or **base** profile
- Ensure **git** is included in additional packages
- Create your user account
- Complete installation and reboot

### 2. After first boot
```bash
# Clone dotfiles
git clone https://github.com/tekwon/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run installation script
chmod +x install.sh
./install.sh

# Reboot or restart display manager
sudo systemctl restart lightdm
```

That's it! The script will install everything (i3, Sway, all packages, configs, scripts).

## Manual Installation

If you already have a configured system:

1. Clone this repository:
```bash
git clone https://github.com/tekwon/dotfiles.git ~/dotfiles
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
├── install.sh              # Main installation script
├── sync.sh                 # Sync configs from system to repo
├── packages/
│   ├── pacman.txt         # Official repository packages
│   └── aur.txt            # AUR packages
├── config/                # ~/.config directory contents
│   ├── i3/               # i3 window manager (X11)
│   ├── sway/             # Sway compositor (Wayland)
│   ├── polybar/          # Status bar for i3
│   ├── waybar/           # Status bar for Sway
│   ├── rofi/
│   ├── nvim/
│   └── ...
├── home/                  # Home directory dotfiles
│   ├── .bashrc
│   ├── .bash_profile
│   └── .local/
│       ├── bin/          # User scripts
│       └── share/
│           └── applications/  # Custom .desktop files
├── scripts/               # Utility scripts (copied to ~/.local/bin)
│   ├── sway-nvidia       # Sway launcher for NVIDIA GPUs
│   ├── set-wallpaper     # Wallpaper script
│   └── gparted-wrapper   # GParted launcher
└── wayland-sessions/      # Display manager session files
    └── sway-nvidia.desktop
```

## What Gets Installed

- All packages listed in `packages/pacman.txt` and `packages/aur.txt`
- Both i3 and Sway window managers
- Configuration files symlinked to their proper locations
- Custom scripts copied to `~/.local/bin`
- Custom `.desktop` files copied to `~/.local/share/applications`
- System services enabled (lightdm, bluetooth, iwd)
- AUR helper (yay or paru) if not already installed

## Customization

1. **Add packages**: Edit `packages/pacman.txt` or `packages/aur.txt`
2. **Modify configs**: Edit files in `config/` or `home/` directories
3. **Commit changes**: `git add . && git commit -m "Update config"`

## Backup

The install script automatically backs up any existing configuration files with a `.backup` extension before creating symlinks.

## Window Manager Choice

### i3 (X11)
- Lightweight and fast
- Better compatibility with older applications
- Use polybar for status bar

### Sway (Wayland)
- Modern Wayland compositor
- Better HiDPI support
- Improved security
- Use waybar for status bar
- **NVIDIA GPU users**: Use the "Sway (Nvidia)" session from your display manager

## NVIDIA + Wayland Setup

For NVIDIA GPUs running Sway/Wayland (10 series cards require --unsupported-gpu):

1. The install script sets up a custom sway launcher (`~/.local/bin/sway-nvidia`) that runs:
   ```bash
   exec sway --unsupported-gpu "$@"
   ```

2. Firefox on Wayland with NVIDIA requires these environment variables (already in `.bashrc`):
   ```bash
   export GBM_BACKEND=nvidia-drm
   export __GLX_VENDOR_LIBRARY_NAME=nvidia
   export MOZ_ENABLE_WAYLAND=1
   export MOZ_DISABLE_RDD_SANDBOX=1
   ```

3. Select "Sway (Nvidia)" from your display manager login screen

## Notes

- Run `./install.sh` again to update symlinks and install new packages
- Use `./sync.sh` to copy your current configs back to this repository
- Existing configs are preserved as `.backup` files
- The script is idempotent - safe to run multiple times
