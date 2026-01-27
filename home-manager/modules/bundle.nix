{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./btop.nix
    ./ghostty.nix
    ./nvim.nix
    ./claude.nix
  ];

  home.packages = with pkgs; [
    brave
    obsidian
    discord
    element-desktop
    eza
    lazygit
    bat
    tree
    fastfetch
    python3
    python3Packages.pip
  ];
}
