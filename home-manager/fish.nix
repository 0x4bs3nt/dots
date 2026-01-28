{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';

    shellAbbrs = {
      ll = "eza -lag";
      lg = "lazygit";

      # Rebuilding aliases
      nr = "nixfmt ~/nix/**/*.nix; sudo nixos-rebuild switch --flake ~/nix#nixos";
      hms = "nixfmt ~/nix/**/*.nix; home-manager switch --flake ~/nix#jan";
      rebuild = "nixfmt ~/nix/**/*.nix; sudo nixos-rebuild switch --flake ~/nix#nixos && home-manager switch --flake ~/nix#jan";
    };
  };
}
