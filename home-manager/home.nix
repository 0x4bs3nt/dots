{ config, pkgs, ...}: {
  imports = [
    ./fish.nix
    ./modules/bundle.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "jan";
    homeDirectory = "/home/jan";
    stateVersion = "25.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
