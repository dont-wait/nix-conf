{
  description = "dontwait nix config";

  nixConfig = {
    extra-substituters = [ "https://look.cachix.org" ];
    extra-trusted-public-keys = [ "look.cachix.org-1:8elPCeSVBzlDZXqIRKBK9GyLIK/Hoe1xiWZF0ir7uX4=" ];
  };

  inputs.look.url = "github:kunkka19xx/look?dir=apps/linows";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

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
      pkgs = nixpkgs.legacyPackages.${system};

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
            { nixpkgs.overlays = [ polybarOverlay ]; }
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
