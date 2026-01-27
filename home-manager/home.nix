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

  home.file.".local/share/fonts" = {
    source = ./fonts;
    recursive = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
