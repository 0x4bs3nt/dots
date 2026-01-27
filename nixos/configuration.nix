{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./modules/bundle.nix
  ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
