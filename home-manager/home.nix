{ config, pkgs, nixvim, ...}: {
  imports = [
    nixvim.homeModules.nixvim
    ./fish.nix
    ./modules/bundle.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

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
