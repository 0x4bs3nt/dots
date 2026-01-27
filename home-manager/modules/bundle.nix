{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./btop.nix
  ];

  # This is where your GUI apps go now
  home.packages = with pkgs; [
    brave
    obsidian
    ghostty
    discord
    element-desktop
    fastfetch
    bat
    tree
  ];
}
