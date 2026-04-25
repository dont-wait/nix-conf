{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.wezterm = {
    enable = true;
    enableUaches = true;
    package = pkgs.wezterm;
  };

  home-manager.users.dontwait =
    { lib, ... }:
    {
      home.file = {
        ".config/wezterm" = {
          source = ../../dotfiles/wezterm/.wezterm.lua;
        };
      };
    };
}
