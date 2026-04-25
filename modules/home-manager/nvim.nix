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
        ".config/nvim" = {
          source = ../../dotfiles/nvim/.config/nvim;
          recursive = true;
        };
      };
    };
}
