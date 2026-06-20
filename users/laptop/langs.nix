{ config, pkgs, ... }:
let
  python_version = pkgs.python3_13;
in
{
  # Tại đây khai báo các môi trường lập trình và LSP Server
  home.packages = with pkgs; [
    # C/C++
    gcc
    gnumake

    # Node / Web
    nodejs_latest
    yarn-berry_3

    # Lua
    lua-language-server

    # Python
    python3
    pyright

    # Nix
    nil

    # Go
    go
    go-tools

    # Flutter
    gradle_9
    flutter329

    # Bash
    shfmt
    shellcheck
    bash-language-server

    # Java
    jdt-language-server
    google-java-format
    yaml-language-server

    # Rust
    cargo
    rustc
    rustfmt
    # rustlings
    clippy
  ];

  home.sessionVariables = {
    # Python
    PYTHONSTARTUP = "${pkgs.python3}/lib/python3.13/site-packages";

    # Node.js
    # NODE_PATH = "~/.npm-global/lib/node_modules";
    NODE_PATH = "$NODE_PATH:$ (npm root - g)";

    # Rust
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";

    # Java
    JAVA_HOME = "${pkgs.jdk25}";
  };

  home.sessionPath = [
    "${pkgs.jdk25}/bin"
    "${config.home.homeDirectory}/.cargo/bin"
  ];
}
