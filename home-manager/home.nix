{
  config,
  pkgs,
  nixvim,
  llm-agents,
  zen-browser,
  ...
}:
{
  imports = [
    nixvim.homeModules.nixvim
    zen-browser.homeModules.twilight
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

  programs.opencode = {
    enable = true;
    package = llm-agents.packages.${pkgs.system}.opencode;
  };

  home.file.".config/opencode" = {
    source = ../opencode;
    recursive = true;
  };

  programs.zen-browser = {
    enable = true;
    suppressXdgMigrationWarning = true;
  };

  home.file.".local/share/fonts" = {
    source = ./fonts;
    recursive = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
