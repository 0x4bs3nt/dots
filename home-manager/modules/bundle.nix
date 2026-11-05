{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./btop.nix
    ./ghostty.nix
    ./nvim
    ./fastfetch.nix
    ./flectar-mail.nix
  ];

  home.packages = with pkgs; [
    obsidian
    obs-studio
    discord
    slack
    spotify
    element-desktop
    eza
    lazygit
    bat
    tree
    nixfmt-rfc-style
    gh
    nerd-fonts.symbols-only
  ];
}
