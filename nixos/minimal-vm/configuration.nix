



{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  
  boot.loader.systemd-boot.enable = true;
  
  networking.hostName = "nixos"; 

  
  networking.networkmanager.enable = true;

  
  time.timeZone = "Asia/Ho_Chi_Minh";
 
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  hardware.graphics = {
    enable = true;
  };
  nix = {
   package = pkgs.nix;
   extraOptions = ''
      experimental-features = nix-command flakes
   '';
  };
  
  services.xserver = {
  	enable = true;
	windowManager.i3 = {
		enable = true;
		extraPackages = with pkgs;[
			dmenu
			i3status
			i3blocks
		];
	};
  };
  virtualisation.vmware.guest.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.defaultSession = "none+i3";
  programs.i3lock.enable = true;
 
  nixpkgs.config.allowUnfree = true;
  
  users.users.dontwait = {
    isNormalUser = true;
     extraGroups = [ "wheel" "docker" "networkmanager"]; 
     packages = with pkgs; [
       tree
       docker
     ];
  };
 
   environment.systemPackages = with pkgs; [
     vim 
    wget
    neovim
    fastfetch
    git
    wget
    gh
    gcc
    home-manager
    open-vm-tools
    gnumake
   ];
 
  system.stateVersion = "25.11"; 
}
