{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./db.nix
    ./langs.nix

    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/i3.nix
    ../../modules/home-manager/yazi.nix
    ../../modules/home-manager/wezterm.nix
    ../../modules/home-manager/ghostty.nix
    ../../modules/home-manager/nvim.nix
  ];

  home.username = "dontwait";
  home.homeDirectory = "/home/dontwait";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # terminal & shell
    neovim
    wezterm
    ghostty
    tmux
    zsh
    oh-my-zsh
    fastfetch
    tldr
    tree-sitter
    yazi

    # desktop
    dmenu
    dunst
    feh
    picom
    rofi
    flameshot
    pavucontrol
    brightnessctl
    blueman
    (polybar.override {
      i3Support = true;
      pulseSupport = true;
    })

    # file manager
    xfce.thunar
    xfce.thunar-volman
    gvfs
    udiskie
    udisks2
    zathura
    rar

    # apps
    discord
    brave
    obs-studio
    libreoffice-qt
    hunspell
    mpv
    postman
    vscode-fhs

    # dev
    android-studio
    flutter
    openssl
    azuredatastudio
    staruml
    vmware-workstation

    # misc
    networkmanagerapplet
    edid-decode
    stow
    qt6Packages.fcitx5-configtool
  ];

  programs.home-manager.enable = true;
}
