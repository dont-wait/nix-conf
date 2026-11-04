{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.within.jujutsu;
in
{
  options.within.jujutsu.enable =
    mkEnableOption "Enables Jujutsu";

  config = mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;

      settings = {
        user = {
          name = "dont-wait";
          email = "157901375+dont-wait@users.noreply.github.com";
        };

        ui = {
          editor = "nvim";
          default-command = "log";
        };

        aliases = {
          l = [ "log" "-r" "all()" ];
          ll = [ "log" "-r" "all()" "-T" "builtin_log_detailed" ];
          s = [ "status" ];
          d = [ "diff" ];
          n = [ "new" ];
          push = [ "git" "push" ];
          fetch = [ "git" "fetch" ];
        };
      };
    };
  };
}
