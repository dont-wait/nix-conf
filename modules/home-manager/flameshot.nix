# ~/.config/home-manager/flameshot.nix
{ pkgs, ... }:

{
  home.packages = [
    (pkgs.flameshot.overrideAttrs (oldAttrs: rec {
      version = "12.1.0";
      src = pkgs.fetchFromGitHub {
        owner = "flameshot-org";
        repo = "flameshot";
        rev = "v${version}";
        sha256 = "sha256-omyMN8d+g1uYsEw41KmpJCwOmVWLokEfbW19vIvG79w=";
      };
    }))
  ];

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        showStartupLaunchMessage = false;
      };
    };
  };
}
