{ config, pkgs, ... }:

{
  # Tại đây khai báo các môi trường lập trình và LSP Server
  environment.systemPackages = with pkgs; [
    # C/C++
    gcc
    clang
    gnumake

    # Node / Web
    nodejs
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    yarn-berry_3

    # Lua
    lua-language-server

    # Python
    python3
    pyright

    # Nix
    nil

    # Bash
    shfmt
    shellcheck
    bash-language-server

    # Java
    jdt-language-server
    google-java-format
    yaml-language-server

    # Flutter
    flutter
    android-studio

    #golang
    go
    gopls
    gofumpt

    # Tools
    pkg-config
    ninja
    ripgrep
    tree-sitter

    # Git / docker
    lazygit
    lazydocker
    docker-compose

    # Extra LSP từ config cũ
    stylua
    basedpyright
    ruff
    nixfmt-rfc-style
    zls
    asm-lsp
    websocat
    rustc
    cargo

    lua51Packages.lua
    lua51Packages.luarocks
  ];
}
