{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.rex.homeManagerModules.default
    ./db.nix
    inputs.zalo-for-linux.homeModules.default
    ./langs.nix

    ../../modules/home-manager/default.nix
    ../../modules/home-manager/yazi.nix
    ../../modules/home-manager/gtk.nix
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/zathura.nix
    ../../modules/home-manager/opencode.nix
    ../../modules/home-manager/codex.nix
    ../../modules/home-manager/llms.nix
    ../../modules/home-manager/obs.nix
    # ../../modules/home-manager/picom.nix
    # ../../modules/home-manager/flameshot.nix
    # ../../modules/home-manager/i3.nix
    # ../../modules/home-manager/polybar.nix
    ../../modules/home-manager/sway.nix
    ../../modules/home-manager/waybar.nix
    ../../modules/home-manager/niri.nix
    ../../modules/home-manager/jj.nix

  ];

  home.username = "dontwait";
  home.homeDirectory = "/home/dontwait";
  home.stateVersion = "26.11";
  home.enableNixpkgsReleaseCheck = false;

  programs.rex.enable = true;
  services.rex.enable = true;
  programs.ssh.enable = true;
  programs.zalo.enable = true;

  within = {
    neovim.enable = true;
    ghostty.enable = true;
    kitty.enable = true;
    wezterm.enable = true;
    zsh.enable = true;
    jujutsu.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # terminal & shell
    oh-my-zsh
    fastfetch
    tree-sitter
    inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    kitty
    wezterm
    yazi

    # desktop
    dunst
    fuzzel
    feh
    arandr
    xclip
    # rofi
    dmenu
    wdisplays
    blueman
    # file manager
    thunar
    thunar-volman
    gvfs
    udiskie
    udisks2
    zathura
    rar

    # apps
    # Brave's Wayland backend crashes in libxkbcommon on this machine.
    # Keep Brave on XWayland even when NIXOS_OZONE_WL enables the Wayland hint.
    (brave.override { commandLineArgs = "--ozone-platform=x11"; })
    libreoffice-qt
    hunspell
    mpv
    pavucontrol
    android-tools

    # music
    kew

    # dev
    direnv
    openssl
    virt-manager

    # misc
    networkmanagerapplet
    edid-decode
    stow
    qt6Packages.fcitx5-configtool
    jq
    wev
    grim
    slurp
    wl-clipboard
    nerd-fonts.inconsolata
    nerd-fonts.jetbrains-mono
    corefonts

    vscode
    platformio-core
    webkitgtk_4_1
  ];

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = [ "org.pwmt.zathura.desktop" ];
    "application/epub+zip" = [ "org.pwmt.zathura.desktop" ];

    "text/html" = [ "firefox.desktop" ];
    "application/xhtml+xml" = [ "firefox.desktop" ];
    "application/x-extension-htm" = [ "firefox.desktop" ];
    "application/x-extension-html" = [ "firefox.desktop" ];
    "application/x-extension-shtml" = [ "firefox.desktop" ];
    "application/x-extension-xhtml" = [ "firefox.desktop" ];
    "application/x-extension-xht" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
    "x-scheme-handler/chrome" = [ "firefox.desktop" ];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
