{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = [ pkgs.wl-clipboard ];

  programs.tmux = {
    plugins = [
      pkgs.tmuxPlugins.vim-tmux-navigator
    ];
    enable = true;
    extraConfig = builtins.readFile ../../dotfiles/tmux/tmux.conf;
  };
}
