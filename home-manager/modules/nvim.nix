{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # ONLY symlink the config files, not the whole directory
  # This leaves ~/.local/share/nvim writable for Mason
  xdg.configFile."nvim".source = ../nvim;
  
  # Ensure the dependencies Mason needs are installed via Nix
  home.packages = with pkgs; [
    lua-language-server
    stylua
    nil
    gcc
    gnumake
    unzip
    wget
    curl
  ];
}
