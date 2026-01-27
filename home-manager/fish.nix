{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      # Existing aliases
      ll = "eza -lag";
      lg = "lazygit";
      
      # 'nr' for NixOS Rebuild
      nr = "sudo nixos-rebuild switch --flake ~/nix#nixos";
      
      # 'hms' for Home Manager Switch
      hms = "home-manager switch --flake ~/nix#jan";
      
      # One to do both
      rebuild = "sudo nixos-rebuild switch --flake ~/nix#nixos && home-manager switch --flake ~/nix#jan";
    };
  };
}
