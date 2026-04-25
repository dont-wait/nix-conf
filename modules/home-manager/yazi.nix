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
        ".config/yazi" = {
          source = ../../dotfiles/yazi/.config/yazi;
          recursive = true;
        };
      };
    };
}
