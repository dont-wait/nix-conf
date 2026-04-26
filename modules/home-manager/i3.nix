{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.file.".config/i3" = {
    source = ../../dotfiles/i3;
    recursive = true;
  };
}
