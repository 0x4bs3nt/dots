{
  config,
  pkgs,
  nixvim,
  zen-browser,
  ghostty,
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
    username = "absent";
    homeDirectory = "/home/absent";
    stateVersion = "25.11";

    # python3 is required by the security-guidance Claude Code plugin's hooks
    # (it shells out to a `python3` interpreter); NixOS ships none by default.
    packages = [ pkgs.python3 ];

    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "0";
      MOZ_DISABLE_RDD_SANDBOX = "1";
    };
  };

  programs.zen-browser = {
    enable = true;
    policies = {
      Preferences = {
        "gfx.webrender.compositor.force-enabled" = false;
        "gfx.webrender.compositor" = false;
        "layers.acceleration.force-enabled" = false;
      };
    };
  };

  home.file.".local/share/fonts" = {
    source = ./fonts;
    recursive = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
