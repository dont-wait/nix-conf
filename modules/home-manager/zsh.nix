{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  home-manager.users.dontwait =
    { lib, ... }:
    {
      home.file = {
        ".zshrc" = {
          source = ../../dotfiles/zsh/.zshrc;
        };
      };
    };
}
