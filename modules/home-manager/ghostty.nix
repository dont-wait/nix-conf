{
  config,
  pkgs,
  lib,
  ...
}:

{
  home-manager.users.dontwait =
    { lib, ... }:
    {
      home.file = {
        ".config/ghostty" = {
          source = ../../dotfiles/ghostty/.config/ghostty;
          recursive = true;
        };
      };
    };
}
