{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/bundle.nix
  ];

  # Nix Settings & Maintenance
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Deduplicate storage automatically
      auto-optimise-store = true;
    };
    # Automatic Garbage Collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Automatic System Upgrades
  system.autoUpgrade = {
    enable = true;
    flake = "/home/jan/nix";
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
    dates = "04:00";
    randomizedDelaySec = "45min";
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zagreb";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # System-level packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    home-manager
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.11";
}
