# NixOS Configuration

My personal NixOS + Home Manager flake configuration.

## Requirements

- Nix 2.4+ with flakes enabled
- A NixOS installation

## Quick Start

```bash
# Clone the repository
git clone https://github.com/dontwait/nix-conf.git
cd nix-conf

# Rebuild NixOS system
sudo nixos-rebuild switch --flake .#laptop

# Activate Home Manager
home-manager switch --flake .#dontwait
```

## Hosts

### laptop

Full desktop configuration:

- **Window Manager**: i3-gaps with picom, dunst, rofi
- **Display Manager**: LightDM
- **Terminal**: Ghostty, Wezterm
- **Shell**: zsh (Oh My Zsh)
- **File Manager**: Yazi, Thunar
- **Editor**: Neovim
- **Browser**: Firefox, Brave
- **PDF Reader**: Zathura
- **Audio**: PipeWire with PulseAudio/Jack support
- **Input Method**: Fcitx5 with Unikey
- **Virtualization**: Docker, VMware
- **Android SDK**: Platform tools, NDK 28, Build tools 35

### minimal-vm

Minimal VM configuration for lightweight development environment.

## Directory Structure

```
.
├── flake.nix              # Root flake with NixOS & HM outputs
├── flake.lock            # Locked dependencies
├── nixos/
│   ├── laptop/           # NixOS system config for laptop
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── minimal-vm/       # NixOS system config for VM
├── users/
│   ├── laptop/           # Home Manager config for laptop
│   │   ├── dontwait.nix
│   │   ├── db.nix
│   │   └── langs.nix
│   └── minimal-vm/       # Home Manager config for VM
├── modules/
│   └── home-manager/     # Reusable Home Manager modules
│       ├── nvim.nix
│       ├── ghostty.nix
│       ├── wezterm.nix
│       ├── zsh.nix
│       ├── picom.nix
│       ├── i3.nix
│       ├── yazi.nix
│       ├── firefox.nix
│       ├── zathura.nix
│       ├── tmux.nix
│       └── opencode.nix
└── dotfiles/             # Manual backups (nvim, zsh, i3, etc.)
```

## Switch Between Hosts

```bash
# For laptop
sudo nixos-rebuild switch --flake .#laptop
home-manager switch --flake .#dontwait

# For minimal-vm
sudo nixos-rebuild switch --flake .#minimal-vm
home-manager switch --flake .#dontwait-minimal-vm
```

## Update

```bash
# Update all inputs
nix flake update

# Or update specific input
nix flake update nixpkgs
```

## Customization

Before using this configuration, you need to modify several files to adapt it to your system.

### 1. Username

Change all occurrences of `dontwait` to your username:

**`users/laptop/dontwait.nix`** (lines 23-24):

```nix
home.username = "dontwait";
home.homeDirectory = "/home/dontwait";
```

**`users/minimal-vm/dontwait-vm.nix`**:

```nix
home.username = "dontwait";
home.homeDirectory = "/home/dontwait";
```

**`nixos/laptop/configuration.nix`** (lines 152-175):

```nix
users.users.dontwait = {
  isNormalUser = true;
  description = "dontwait";
  ...
};
```

### 2. Hostname

Update the hostname in NixOS configs:

**`nixos/laptop/configuration.nix`** (line 28):

```nix
networking.hostName = "nixos";
```

**`nixos/minimal-vm/...`** (same field).

### 3. Hardware Configuration

Generate your hardware config:

```bash
# For a new installation
sudo nixos-generate-config --root /mnt

# For existing system
sudo nixos-generate-config
```

Copy the generated `/etc/nixos/hardware-configuration.nix` to:

- `nixos/laptop/hardware-configuration.nix`
- `nixos/minimal-vm/hardware-configuration.nix` (if using VM)

Key hardware-specific settings include:

- `fileSystems` - your disk partitions and mount points
- `boot.initrd.luks.devices` - encrypted partitions
- `hardware.cpu.intel.updateMicrocode` or AMD equivalent
- `hardware.graphics` settings
- `hardware.bluetooth` enable

### 4. User Groups

Check and update user groups in **`nixos/laptop/configuration.nix`** (lines 158-169):

```nix
extraGroups = [
  "networkmanager"
  "wheel"
  "docker"
  "adbusers"
  "plugdev"
  "storage"
  "disk"
  "video"
  "render"
  "kvm"
];
```

Remove groups that don't exist on your system or add new ones.

### 5. Time Zone

Update in **`nixos/laptop/configuration.nix`** (line 40):

```nix
time.timeZone = "Asia/Ho_Chi_Minh";
```

### 6. Locale

Update in **`nixos/laptop/configuration.nix`** (lines 43-55):

```nix
i18n.defaultLocale = "en_US.UTF-8";
```

### 7. Input Method (Fcitx5)

If you don't need Vietnamese input, you can simplify **`nixos/laptop/configuration.nix`** (lines 57-65):

```nix
i18n.inputMethod = {
  enable = true;
  type = "fcitx5";
  fcitx5.addons = with pkgs; [
    fcitx5-gtk
  ];
};
```

Or disable entirely by removing this section.

### 8. Display Manager (LightDM)

Check **`nixos/laptop/configuration.nix`** (line 94):

```nix
services.xserver.displayManager.lightdm.enable = true;
```

If using a different DM (SDDM, GDM, etc.), change accordingly.

### 9. Android SDK

The Android SDK is configured in **`nixos/laptop/configuration.nix`** (lines 236-241):

```nix
(androidenv.composeAndroidPackages {
  platformVersions = [ "36" ];
  ndkVersions = [ "28.2.13676358" ];
  buildToolsVersions = [ "35.0.0" ];
  includeNDK = true;
}).androidsdk
```

Update versions as needed or remove if not required.

### 10. Docker

Docker is enabled in **`nixos/laptop/configuration.nix`** (line 246):

```nix
virtualisation.docker.enable = true;
```

### 11. Auto-Upgrade Path

Update the flake path in **`nixos/laptop/configuration.nix`** (line 272):

```nix
system.autoUpgrade = {
  enable = true;
  flake = "/home/dontwait/nix#laptop";  # Change to your path
  ...
};
```

### 12. Home Manager Modules

Review imports in **`users/laptop/dontwait.nix`** (lines 10-21):

```nix
imports = [
  ./db.nix
  ./langs.nix

  ../../modules/home-manager/default.nix
  ../../modules/home-manager/i3.nix
  ../../modules/home-manager/picom.nix
  ../../modules/home-manager/yazi.nix
  ../../modules/home-manager/firefox.nix
  ../../modules/home-manager/zathura.nix
  ../../modules/home-manager/opencode.nix
];
```

Disable or enable modules based on what you actually need.

### 13. Packages

Review and update packages in:

- **`nixos/laptop/configuration.nix`** (lines 208-242) - system packages
- **`users/laptop/dontwait.nix`** (lines 35-91) - user packages

Remove packages you don't need or add new ones.

### 14. Flatpak

Flatpak is enabled in **`nixos/laptop/configuration.nix`** (line 129):

```nix
services.flatpak.enable = true;
```

Disable if not needed.

### 15. Printing (CUPS)

Printing is enabled in **`nixos/laptop/configuration.nix`** (line 124):

```nix
services.printing.enable = true;
```

Disable if no printer.

## Auto Upgrade

The `laptop` host has auto-upgrade enabled via `system.autoUpgrade`:

- Runs weekly
- Automatically commits lock file changes

## Versions

- **NixOS**: nixos-unstable + nixos-25.11 (for polybar)
- **Home Manager**: nixos-unstable
- **State Version**: 26.05

## Acknowledgments

Inspired by [Kunkka19xx](https://github.com/Kunkka19xx) - thanks for the great NixOS configs!
