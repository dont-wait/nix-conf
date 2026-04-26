{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.within.ghostty;
in
{
  options.within.ghostty.enable = mkEnableOption "Enables Within's Ghostty config";

  config = mkIf cfg.enable {
    home.file = {
      ".config/ghostty/config" = {
        source = ../../dotfiles/ghostty/config;
      };
    };
  };
}
