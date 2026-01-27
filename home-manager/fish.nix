{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      ll = "eza -lag";
      lg = "lazygit";
      rebuild = "sudo nixos-rebuild switch --flake .";
      hms = "home-manager switch --flake .#jan";
    };
  };
}
