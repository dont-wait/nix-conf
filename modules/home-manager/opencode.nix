

{ pkgs, inputs, ... }:

let
  # OpenCode V2 from nixpkgs master
  opencodePkgs =
    inputs.nixpkgs-opencode.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = [
    opencodePkgs.opencode
  ];

  # Manually manage OpenCode configuration
  xdg.configFile."opencode/config.json".text = builtins.toJSON {
    theme = "opencode";
    autoshare = false;
    autoupdate = false;

    keybinds = {
      leader = "ctrl+x";

      # Navigation
      history_previous = "up,ctrl+k";
      history_next = "down,ctrl+j";
      input_move_up = "up,ctrl+k";
      input_move_down = "down,ctrl+j";

      # Disable conflicting bindings
      input_delete_to_line_end = "none";

      # Newline shortcuts
      input_newline = "shift+return,ctrl+return,alt+return";
    };
  };
}

