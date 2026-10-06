{
  description = "dontwait nix config";

  nixConfig = {
    extra-substituters = [ "https://look.cachix.org" ];
    extra-trusted-public-keys = [ "look.cachix.org-1:8elPCeSVBzlDZXqIRKBK9GyLIK/Hoe1xiWZF0ir7uX4=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    # Pin only the WebKitGTK recipe; updating stable must not change its version.
    webkitgtk-source = {
      url = "github:NixOS/nixpkgs/b6018f87da91d19d0ab4cf979885689b469cdd41";
      flake = false;
    };
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
      # Build stable WebKitGTK with this system's libraries, not stable's closure.
      webkitOverlay = final: prev: {
        webkitgtk_6_0 =
          let
            package = final.callPackage "${inputs.webkitgtk-source}/pkgs/development/libraries/webkitgtk" {
              harfbuzz = final.harfbuzzFull;
              inherit (final.gst_all_1) gst-plugins-base gst-plugins-bad;
              # The stable recipe predates these nixpkgs attribute renames.
              enchant2 = final.enchant;
              libpthreadstubs = final.libpthread-stubs;
              xorg = { libX11 = final.libx11; };
            };
          in
          assert package.version == "2.52.4";
          package;
        webkitgtk_4_1 = final.webkitgtk_6_0.override { gtk4 = final.gtk3; };
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
              let
                lookPackage = inputs.look.packages.${system}.default.override {
                  webkitgtk_4_1 = pkgs.webkitgtk_4_1;
                };
              in
              {
                nixpkgs.overlays = [ polybarOverlay webkitOverlay ];
                # Match Kunkka's per-app fcitx fix; Wayland uses its native IM context.
                programs.lookapp.package = pkgs.symlinkJoin {
                  name = "lookapp-fcitx-fix";
                  paths = [ lookPackage ];
                  nativeBuildInputs = [ pkgs.makeWrapper ];
                  postBuild = ''
                    wrapProgram $out/bin/lookapp --unset GTK_IM_MODULE_FILE --unset GTK_IM_MODULE
                  '';
                  inherit (lookPackage) meta;
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
