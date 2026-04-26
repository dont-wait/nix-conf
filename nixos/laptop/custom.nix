{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Shell Envs
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    docker-compose
    lazydocker
    lazygit
    tlrc
    gnumake
    discord-ptb
    droidcam # android phone wbcam client
    android-tools
    fastfetch
    tree
    flameshot
    ffmpeg # video, graphics
    vlc
    screenkey
    xclip # clipboard
    unzip
  ];
  nixpkgs.config.allowUnfreePredicate = (_: true);
  boot.loader.systemd-boot.configurationLimit = 5;
  systemd = {
    targets = {
      sleep = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      suspend = {
        enable = true;
        unitConfig.DefaultDependencies = "no";
      };
      hibernate = {
        enable = true;
        unitConfig.DefaultDependencies = "no";
      };
      "hybrid-sleep" = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
    };
  };

  # Garbage Collector Setting
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";

  };
  
}
