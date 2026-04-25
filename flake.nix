{
  description = "dontwait nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs   = nixpkgs.legacyPackages.${system};

      mkNixosConfig = extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = extraModules;
        };

      mkHmConfig = extraModules:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = extraModules;
        };
    in
    {
      nixosConfigurations = {
        nixos      = mkNixosConfig [ ./nixos/laptop/configuration.nix ];
        minimal-vm = mkNixosConfig [ ./nixos/minimal-vm/configuration.nix ];
      };

      homeConfigurations = {
        "dontwait"            = mkHmConfig [ ./users/laptop/dontwait.nix ];
        "dontwait-minimal-vm" = mkHmConfig [ ./users/minimal-vm/dontwait-vm.nix ];
      };
    };
}
