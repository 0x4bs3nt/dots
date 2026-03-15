{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide;
      }
    ];

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';

    shellAbbrs = {
      ll = "eza --long --all --group --group-directories-first --icons=auto --header --colour-scale=size --time-style=relative";
      lg = "lazygit";

      # Rebuilding aliases
      nr = "nixfmt ~/nix/**/*.nix; nixos-rebuild switch --sudo --impure --flake ~/nix#nixos";
      hms = "nixfmt ~/nix/**/*.nix; home-manager switch --flake ~/nix#jan";
      rebuild = "nixfmt ~/nix/**/*.nix; nixos-rebuild switch --sudo --impure --flake ~/nix#nixos && home-manager switch --flake ~/nix#jan";

      # Nix utilities
      clean = "nix-collect-garbage -d";
      update = "nix flake update --impure && nixfmt ~/nix/**/*.nix";
    };
  };
}
