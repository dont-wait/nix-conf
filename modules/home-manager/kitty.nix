{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.within.kitty;
in
{
  options.within.kitty.enable = mkEnableOption "Enables Within's Kitty config";

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      extraConfig = builtins.readFile ../../dotfiles/kitty/kitty.conf;
    };
  };
}
