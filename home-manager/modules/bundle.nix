{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./btop.nix
    ./ghostty.nix
    ./nvim
    ./claude.nix
    ./fastfetch.nix
    ./thunderbird.nix
  ];

  home.packages = with pkgs; [
    brave
    obsidian
    discord
    slack
    element-desktop
    eza
    lazygit
    bat
    tree
    nixfmt-rfc-style
  ];
}
