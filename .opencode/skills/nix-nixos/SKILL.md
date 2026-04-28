---
name: nix-nixos
description: >
  Use this skill for any task involving Nix or NixOS: writing Nix expressions,
  flakes, NixOS modules, Home Manager configs, derivations, overlays, or shell
  environments. Trigger whenever the user mentions nix-shell, nix develop,
  nixpkgs, flake.nix, configuration.nix, home.nix, nix build, nix run,
  mkDerivation, stdenv, nixos-rebuild, or asks to package software with Nix,
  set up a dev shell, configure a NixOS system, pin dependencies, or migrate
  from imperative package managers to a declarative Nix setup. Also use when
  the user asks about Nix language syntax (let-in, with, inherit, rec, lib),
  lazy evaluation, the Nix store (/nix/store), garbage collection, or any
  Nix-specific error message. When in doubt, if the task touches a .nix file
  or any nix CLI tool, use this skill.
---

# Nix / NixOS Skill

## Overview

Nix is a purely functional package manager and build system. NixOS is a Linux
distribution built entirely on Nix. This skill covers the full Nix ecosystem:
the Nix language, nixpkgs, flakes, NixOS modules, Home Manager, and common
operational tasks.

---

## 1. Nix Language Essentials

### Types and literals
```nix
# Primitives
42           # int
3.14         # float
true / false # bool
null
"hello"      # string (double-quote)
''
  multiline
  string
''
./path       # path (relative to file)
/nix/store   # absolute path

# Collections
[ 1 2 3 ]                           # list
{ a = 1; b = "x"; }                 # attribute set (attrset)
{ inherit a; b = a + 1; }           # inherit shorthand
rec { a = 1; b = a + 1; }           # recursive attrset
```

### Expressions
```nix
# let…in
let x = 1; y = 2; in x + y

# with (import a scope)
with lib; [ optionalString concatStringsSep ]

# if…then…else  (always has both branches)
if condition then "yes" else "no"

# assert
assert x > 0; x * 2

# Function (always single argument; curry for multiple)
x: x + 1
{ a, b ? 0, ... }: a + b    # attrset argument with default and catch-all
```

### String interpolation & escaping
```nix
"Hello ${name}!"
"path is ${toString ./file}"
# To include a literal ${ in a string: use '' ... '' and escape as ''${ or use ''${
```

### Common lib functions
```nix
lib.optionals condition list       # [] if false
lib.mkIf condition value
lib.mkMerge [ attrset1 attrset2 ]
lib.mkDefault value                # lowest priority
lib.mkForce value                  # highest priority
lib.mapAttrs (n: v: ...) attrset
lib.filterAttrs (n: v: ...) attrset
lib.concatMapStringsSep sep f list
lib.types.*                        # module option types
```

---

## 2. Derivations and Packages

### stdenv.mkDerivation (classic)
```nix
{ stdenv, fetchurl, pkg-config, openssl }:

stdenv.mkDerivation {
  pname = "myapp";
  version = "1.2.3";

  src = fetchurl {
    url = "https://example.com/myapp-1.2.3.tar.gz";
    hash = "sha256-AAAA...==";   # use `nix-prefetch-url` or `nix store prefetch-file`
  };

  nativeBuildInputs = [ pkg-config ];   # run-time tools executed on build machine
  buildInputs = [ openssl ];            # libraries linked into the output

  configureFlags = [ "--disable-docs" ];

  meta = {
    description = "My application";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
```

### Key phases (override with `<phase>Phase` or `pre/postInstall` hooks)
| Phase | Hook variables |
|---|---|
| unpack | `preUnpack`, `postUnpack` |
| patch | `patches` list |
| configure | `configurePhase`, `configureFlags` |
| build | `buildPhase`, `buildFlags` |
| check | `checkPhase`, `doCheck = true` |
| install | `installPhase` |
| fixup | `postFixup` |

### buildPythonPackage / buildPythonApplication
```nix
python3.pkgs.buildPythonPackage {
  pname = "mypkg";
  version = "0.1.0";
  src = ...;
  propagatedBuildInputs = [ python3.pkgs.requests ];
  format = "pyproject";   # or "setuptools", "flit", "wheel"
}
```

### fetchFromGitHub / fetchFromGitLab
```nix
fetchFromGitHub {
  owner = "NixOS";
  repo  = "nixpkgs";
  rev   = "24.11";
  hash  = "sha256-AAAA...==";
}
```

> **Hash tip**: Set `hash = lib.fakeHash;`, run `nix build`, copy the correct
> hash from the error message.

---

## 3. Flakes

### Standard flake.nix structure
```nix
{
  description = "My project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    # pin a specific commit:
    nixpkgs-old.url = "github:NixOS/nixpkgs/abc1234";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        # Packages
        packages.default = pkgs.callPackage ./package.nix { };

        # Dev shell
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ git nodejs python3 ];
          shellHook = ''
            echo "Welcome to the dev shell!"
          '';
        };

        # Apps  (nix run)
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/myapp";
        };

        # Checks  (nix flake check)
        checks.default = pkgs.runCommand "check" { } ''
          ${self.packages.${system}.default}/bin/myapp --version
          touch $out
        '';
      }
    ) // {
      # System-independent outputs
      nixosModules.default = import ./module.nix;

      nixosConfigurations.myhostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/myhostname/configuration.nix ];
      };
    };
}
```

### Flake CLI cheat-sheet
```bash
nix flake init                     # scaffold flake.nix
nix flake update                   # update all inputs (writes flake.lock)
nix flake update nixpkgs           # update one input
nix flake show                     # list outputs
nix flake check                    # run checks
nix build                          # build packages.default
nix build .#myPackage
nix run                            # run apps.default
nix develop                        # enter devShells.default
nix develop .#myShell
```

---

## 4. Dev Shells

### Simple shell (no flake)
```nix
# shell.nix
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = with pkgs; [ rustc cargo clippy rust-analyzer ];
}
```
```bash
nix-shell            # enter
nix-shell --run 'cargo build'
```

### mkShell options
```nix
pkgs.mkShell {
  packages = [ ... ];             # things on $PATH
  buildInputs = [ ... ];          # C library headers / pkg-config
  nativeBuildInputs = [ ... ];    # build-time tools (cmake, meson, …)
  shellHook = ''
    export DATABASE_URL="sqlite:///dev.db"
  '';
  # Environment variables
  RUST_BACKTRACE = "1";
}
```

---

## 5. NixOS Configuration

### /etc/nixos/configuration.nix skeleton
```nix
{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.hostName = "mymachine";
  networking.networkmanager.enable = true;

  # Locale / time
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";

  # Users
  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim git curl wget htop
  ];

  # Services
  services.openssh.enable = true;
  services.printing.enable = true;

  # Firewall
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  system.stateVersion = "24.11";  # Do NOT change after install
}
```

### Common service patterns
```nix
# PostgreSQL
services.postgresql = {
  enable = true;
  package = pkgs.postgresql_16;
  ensureDatabases = [ "myapp" ];
  ensureUsers = [{ name = "myapp"; ensureDBOwnership = true; }];
};

# Nginx
services.nginx = {
  enable = true;
  virtualHosts."example.com" = {
    enableACME = true;
    forceSSL = true;
    root = "/var/www/example";
  };
};
security.acme.acceptTerms = true;
security.acme.defaults.email = "admin@example.com";

# Docker
virtualisation.docker.enable = true;

# Systemd user service
systemd.services.myapp = {
  description = "My App";
  wantedBy = [ "multi-user.target" ];
  after = [ "network.target" "postgresql.service" ];
  serviceConfig = {
    ExecStart = "${pkgs.myapp}/bin/myapp";
    Restart = "on-failure";
    User = "myapp";
    DynamicUser = true;
  };
};
```

### Apply changes
```bash
sudo nixos-rebuild switch          # switch to new config now
sudo nixos-rebuild boot            # switch on next reboot
sudo nixos-rebuild test            # test without making bootloader entry
sudo nixos-rebuild switch --flake .#myhostname
```

---

## 6. NixOS Modules

### Writing a module
```nix
# myapp/module.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.services.myapp;
in {
  options.services.myapp = {
    enable = lib.mkEnableOption "myapp";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port to listen on.";
    };

    package = lib.mkPackageOption pkgs "myapp" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.myapp = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/myapp --port ${toString cfg.port}";
        DynamicUser = true;
      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
```

### lib.types reference
| Type | Notes |
|---|---|
| `types.bool` | true / false |
| `types.int` | integer |
| `types.port` | 1–65535 |
| `types.str` | string |
| `types.path` | filesystem path |
| `types.package` | a derivation |
| `types.listOf t` | list of t |
| `types.attrsOf t` | attrset of t |
| `types.nullOr t` | t or null |
| `types.enum [ "a" "b" ]` | one of listed strings |
| `types.submodule { options = ...; }` | nested module |

---

## 7. Home Manager

### Standalone setup (flake)
```nix
# flake.nix (add to outputs)
homeConfigurations."alice@mymachine" = home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
  modules = [ ./home.nix ];
};
```

### home.nix skeleton
```nix
{ config, pkgs, lib, ... }:
{
  home.username = "alice";
  home.homeDirectory = "/home/alice";
  home.stateVersion = "24.11";

  # Packages
  home.packages = with pkgs; [ ripgrep fd bat eza ];

  # Programs with first-class HM support
  programs.git = {
    enable = true;
    userName = "Alice";
    userEmail = "alice@example.com";
    extraConfig.init.defaultBranch = "main";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
      theme = "robbyrussell";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  # Dotfiles (managed symlinks)
  home.file.".tmux.conf".source = ./tmux.conf;
  xdg.configFile."alacritty/alacritty.toml".source = ./alacritty.toml;

  # Session variables
  home.sessionVariables.EDITOR = "nvim";

  programs.home-manager.enable = true;
}
```

```bash
home-manager switch --flake .#alice@mymachine
```

---

## 8. Overlays

```nix
# Override a package attribute
nixpkgs.overlays = [
  (final: prev: {
    # Upgrade a package
    myTool = prev.myTool.overrideAttrs (old: {
      version = "2.0.0";
      src = prev.fetchFromGitHub { ... };
    });

    # Add a package not in nixpkgs
    myNewPkg = final.callPackage ./pkgs/myNewPkg { };
  })
];
```

---

## 9. Common Patterns and Idioms

### callPackage pattern
```nix
# pkgs/myapp/default.nix
{ stdenv, lib, makeWrapper, python3 }:
stdenv.mkDerivation { ... }

# in flake / configuration
pkgs.callPackage ./pkgs/myapp { }   # auto-injects dependencies by name
```

### wrapProgram / makeWrapper
```nix
nativeBuildInputs = [ makeWrapper ];
postInstall = ''
  wrapProgram $out/bin/myapp \
    --prefix PATH : ${lib.makeBinPath [ pkgs.ffmpeg ]} \
    --set SOME_ENV "value"
'';
```

### Conditional config
```nix
# In a module
config = lib.mkIf cfg.enable { ... };

# In a list
environment.systemPackages = with pkgs;
  [ vim git ]
  ++ lib.optionals config.services.xserver.enable [ xterm ]
  ++ lib.optionals pkgs.stdenv.isLinux [ iproute2 ];
```

### Pinning nixpkgs without flakes
```nix
let
  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/24.11.tar.gz";
    sha256 = "sha256:AAAA...";
  };
  pkgs = import nixpkgs { };
in pkgs.mkShell { ... }
```

---

## 10. Troubleshooting

### Find the hash for a fixed-output derivation
```bash
# Method 1: use lib.fakeHash, let nix error show the real hash
# Method 2:
nix-prefetch-url --unpack https://example.com/src.tar.gz
# Method 3 (flakes):
nix store prefetch-file --hash-type sha256 https://example.com/src.tar.gz
```

### Inspect the build environment
```bash
nix develop          # enter dev shell
nix-shell --pure     # clean PATH
nix log /nix/store/...-myapp.drv   # build log
nix show-derivation /nix/store/...-myapp.drv
```

### Garbage collection
```bash
nix-collect-garbage -d           # delete all old generations
nix-store --gc                   # GC only unreachable store paths
sudo nix-collect-garbage -d      # system-wide (NixOS)
# Keep last N generations:
nix-env --delete-generations +5
```

### Useful nix CLI flags
```bash
nix build --print-build-logs      # verbose
nix build --keep-failed           # keep build dir on failure in /tmp/nix-build-*
nix build --impure                # allow access to env vars / current system
nix eval .#packages.x86_64-linux.default.version
nix repl '<nixpkgs>'              # interactive REPL
```

### nix repl tips
```
nix-repl> :l <nixpkgs>
nix-repl> pkgs.hello
nix-repl> :b pkgs.hello           # build
nix-repl> builtins.attrNames pkgs.lib
```

---

## 11. Channels vs Flakes Decision Guide

| Scenario | Recommendation |
|---|---|
| New project, full reproducibility needed | **Flakes** |
| Quick one-off shell | `nix-shell -p pkg1 pkg2` or `nix shell nixpkgs#pkg1` |
| Existing classic nixpkgs workflow | Channels are fine |
| Team project, CI | **Flakes** (lock file in VCS) |
| NixOS system config | **Flakes** strongly preferred |
| Home Manager | **Flakes** + home-manager module |

---

## 12. Reference Files

For deeper topics, see the bundled reference files (read when relevant):

- `references/nixpkgs-lib.md` — Full `lib.*` function index
- `references/module-system.md` — Advanced module patterns (mkOrder, mkOverride, priority values)
- `references/cross-compilation.md` — `pkgsCross`, `depsBuildBuild`, `depsHostHost`
- `references/fetchers.md` — All fetchers: `fetchurl`, `fetchgit`, `fetchFromGitHub`, `fetchPypi`, `fetchCrate`, etc.

---

## Quick Command Reference

```bash
# Package management
nix search nixpkgs#firefox
nix shell nixpkgs#nodejs                  # temporary shell with package
nix profile install nixpkgs#ripgrep       # user profile (replaces nix-env)
nix profile list

# System (NixOS)
sudo nixos-rebuild switch --flake .#hostname
nixos-option services.nginx.enable        # inspect current option value

# Home Manager
home-manager switch --flake .#user@host
home-manager generations

# Debugging
nix why-depends .#myPkg nixpkgs#openssl   # dependency path
nix path-info --recursive .#myPkg         # closure size
nix store ls /nix/store/...-myapp/        # inspect store path
```
