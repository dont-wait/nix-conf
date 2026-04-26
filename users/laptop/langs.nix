{ config, pkgs, ... }:
let
  python_version = pkgs.python3_13;
  android_sdk.accept_license = true;
in
{
  # Tại đây khai báo các môi trường lập trình và LSP Server
  home.packages = with pkgs; [
    # C/C++
    gcc
    clang
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

    # Bash
    shfmt
    shellcheck
    bash-language-server

    # Java
    jdt-language-server
    google-java-format
    yaml-language-server
  ];

  home.sessionVariables = {
    # Python
    PYTHONSTARTUP = "${pkgs.python3}/lib/python3.13/site-packages";

    # Node.js
    # NODE_PATH = "~/.npm-global/lib/node_modules";
    NODE_PATH = "$NODE_PATH:$ (npm root - g)";

    # Rust
    CARGO_HOME = "~/.cargo";

    # Java
    JAVA_HOME = "${pkgs.jdk25}";
    PATH = "${pkgs.jdk25}/bin:$PATH";
  };
}
