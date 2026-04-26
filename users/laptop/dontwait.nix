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

    ../../modules/home-manager/default.nix
    ../../modules/home-manager/i3.nix
    ../../modules/home-manager/yazi.nix
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/zathura.nix
  ];

  home.username = "dontwait";
  home.homeDirectory = "/home/dontwait";
  home.stateVersion = "25.11";

  within = {
    neovim.enable = true;
    ghostty.enable = true;
    zsh.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # terminal & shell
    oh-my-zsh
    fastfetch
    tree-sitter

    # desktop
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
    discord-ptb
    brave
    obs-studio
    libreoffice-qt
    hunspell
    mpv
    postman
    vscode-fhs
    autocutsel
    xclip
    autorandr
    arandr
    android-tools

    # dev
    android-studio
    flutter
    openssl
    azuredatastudio
    vmware-workstation

    # misc
    networkmanagerapplet
    edid-decode
    stow
    qt6Packages.fcitx5-configtool
    jq
    nerd-fonts.inconsolata
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
