# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelParams = [
      "video=HDMI-A-1:1920x1080@120"
      "i915.enable_fbc=0"
    ];

  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
  };
  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      #fcitx5-configtool
      qt6Packages.fcitx5-unikey
    ];
  };

  # Config i3
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    windowManager.i3.enable = true;
    libinput.touchpad.naturalScrolling = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    dpi = 96; # 96 (100%), 120 (125%), 144 (150%), 192 (200%)
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  };

  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Flatpak
  services.flatpak.enable = true;

  # File GUI
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.tumbler.enable = true;
  programs.dconf.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # config dns
  services.resolved.enable = true;

  # for global user
  users.defaultUserShell = pkgs.zsh;

  users.users.dontwait.shell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dontwait = {
    isNormalUser = true;
    description = "dontwait";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "docker"
      "plugdev"
      "storage"
      "disk"
      "video"
      "render"
      "kvm"
    ];
    packages = with pkgs; [
      #  thunderbird
      docker
    ];

  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
  ];
  programs = {
    adb.enable = true;
  };
  programs.bash.enableCompletion = true;

  programs.nm-applet.enable = true;

  nixpkgs.config.allowBroken = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    unzip
    gnutar
    gzip
    home-manager
    stdenv.cc.cc
    zlib
    glib
    cmake
    fontconfig
    freetype
    libGL
    tree
    pulseaudio
    intel-media-driver
    vulkan-loader
    intel-compute-runtime
    i3
    autocutsel
    xclip
    autorandr
    arandr
    openvpn
    networkmanager-openvpn
    update-systemd-resolved
    antigravity-fhs
    (androidenv.composeAndroidPackages {
      platformVersions = [ "36" ];
      ndkVersions = [ "28.2.13676358" ];
      buildToolsVersions = [ "35.0.0" ];
      includeNDK = true;
    }).androidsdk
  ];

  # NIXOS
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  virtualisation.docker.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    443
    80
    22
  ];
  networking.firewall.trustedInterfaces = [
    "vmnet1"
    "vmnet8"
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # VMWare config
  virtualisation.vmware.host.enable = true;
  virtualisation.vmware.guest.enable = true;

  # Garbage Collector Setting
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";

  system.stateVersion = "25.11"; 

}
