{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.file.".config/yazi" = {
    source = ../../dotfiles/yazi;
    recursive = true;
  };
}
