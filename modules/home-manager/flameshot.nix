{
  inputs,
  pkgs,
  ...
}:

let
  pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.system};
in
{
  home.packages = [
    pkgs-stable.flameshot
  ];
}
