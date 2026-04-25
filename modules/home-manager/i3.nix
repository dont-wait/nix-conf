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
        ".config/i3" = {
          source = ../../dotfiles/i3/.config/i3;
          recursive = true;
        };
      };
    };
}
