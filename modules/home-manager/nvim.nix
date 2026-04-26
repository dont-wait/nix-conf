{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.within.neovim;
in
{
  options.within.neovim.enable = mkEnableOption "Enables Within's Neovim config";

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ];
      extraPackages = with pkgs; [
        nodePackages_latest.vscode-json-languageserver
        lua-language-server
        luajitPackages.jsregexp
        nil
        gopls
        gofumpt
        stylua
        basedpyright
        pyright
        ruff
        nixfmt-rfc-style
        zls
        ripgrep
        # fix bug lazy-luarocks
        # pkgs.luarocks
        lua51Packages.lua
        lua51Packages.luarocks
        asm-lsp
        websocat
        jdk
      ];

    };
    programs.neovim.home.file = {
      ".config/nvim" = {
        source = ../../dotfiles/nvim;
        recursive = true;
      };
    };
  };
}
