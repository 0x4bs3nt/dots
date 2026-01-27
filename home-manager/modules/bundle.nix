{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./btop.nix
    ./ghostty.nix
    ./nvim.nix
  ];

  home.packages = with pkgs; [
    # UI Apps
    brave
    obsidian
    discord
    element-desktop
    eza
    lazygit
    bat
    tree
    fastfetch
  ];
}
