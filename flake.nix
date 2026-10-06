{
  description = "dontwait nix config";

  nixConfig = {
    extra-substituters = [ "https://look.cachix.org" ];
    extra-trusted-public-keys = [ "look.cachix.org-1:8elPCeSVBzlDZXqIRKBK9GyLIK/Hoe1xiWZF0ir7uX4=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    look = {
      url = "github:kunkka19xx/look?dir=apps/linows";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:guibou/nixGL";
    spotx-nix = {
      url = "github:SpotX-Official/SpotX-Nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      # Use the older WebKitGTK from the locked stable input for both ABIs.
      webkitOverlay = final: prev: {
        inherit (nixpkgs-stable.legacyPackages.${system}) webkitgtk_4_1 webkitgtk_6_0;
      };

      pkgs = nixpkgs.legacyPackages.${system}.extend webkitOverlay;

      polybarOverlay = final: prev: {
        polybar = nixpkgs-stable.legacyPackages.${system}.polybar.override {
          i3Support = true;
          pulseSupport = true;
        };
      };

      mkNixosConfig =
        extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [ polybarOverlay webkitOverlay ];
                # Look's default package uses its own package set, outside these overlays.
                programs.lookapp.package = inputs.look.packages.${system}.default.override {
                  webkitgtk_4_1 = pkgs.webkitgtk_4_1;
                };
              }
            )
            inputs.look.nixosModules.default
          ]
          ++ extraModules;
        };

      mkHmConfig =
        extraModules:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = extraModules;
        };
    in
    {
      nixosConfigurations = {
        laptop = mkNixosConfig [ ./nixos/laptop/configuration.nix ];
        minimal-vm = mkNixosConfig [ ./nixos/minimal-vm/configuration.nix ];
      };

      homeConfigurations = {
        "dontwait" = mkHmConfig [ ./users/laptop/dontwait.nix ];
        "dontwait-minimal-vm" = mkHmConfig [ ./users/minimal-vm/dontwait-vm.nix ];
      };
    };
}
