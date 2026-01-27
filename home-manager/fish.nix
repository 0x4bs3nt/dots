{ pkgs, ... }: {
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';

    shellAbbrs = {
      ll = "eza -lag";
      lg = "lazygit";
     
      # Rebuilding aliases 
      nr = "sudo nixos-rebuild switch --flake ~/nix#nixos";
      hms = "home-manager switch --flake ~/nix#jan";
      rebuild = "sudo nixos-rebuild switch --flake ~/nix#nixos && home-manager switch --flake ~/nix#jan";
    };
  };
}
