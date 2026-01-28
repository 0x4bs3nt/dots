{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./btop.nix
    ./ghostty.nix
    ./nvim
    ./claude.nix
    ./fastfetch.nix
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
    python3
    python3Packages.pip
    uv
    bun
  ];
}
