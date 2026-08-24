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
    hurl
    lazygit
    tlrc
    gnumake
    discord-ptb
    fastfetch
    tree
    btop
    ffmpeg # video, graphics
    vlc
    screenkey
    xclip # clipboard
    unzip
    brightnessctl
    cargo-tauri
    spotify-spotx

    inputs.look.packages.${pkgs.system}.default
    inputs.nixgl.packages.${system}.nixGLIntel
  ];

  nixpkgs = {
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "spotify"
        "spotify-spotx"
      ];
    overlays = [ inputs.spotx-nix.overlays.default ];
  };

  boot.loader.systemd-boot.configurationLimit = 5;
  systemd = {
    targets = {
      sleep = {
        enable = true;
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
