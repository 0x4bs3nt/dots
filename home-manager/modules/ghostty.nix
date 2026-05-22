{ pkgs, ghostty, ... }:
{
  programs.ghostty = {
    enable = true;
    package = ghostty.packages.${pkgs.system}.default;

    settings = {
      command = "${pkgs.fish}/bin/fish";

      # General
      auto-update-channel = "tip";
      shell-integration = "fish";
      shell-integration-features = "no-cursor,sudo,title,ssh-env,ssh-terminfo";

      # Theme
      theme = "Gruvbox Material Dark";

      # Font & Spacing
      font-family = [
        "TX-02"
        "Symbols Nerd Font"
      ];
      font-feature = "-calt";
      font-size = 11;
      adjust-cell-height = "45%";

      # Cursor
      cursor-style = "block";
      cursor-style-blink = false;
      mouse-hide-while-typing = true;

      # Window
      window-new-tab-position = "end";
      quit-after-last-window-closed = true;

      # Clipboard
      clipboard-read = "allow";
      clipboard-write = "allow";

      # Surface
      confirm-close-surface = false;

      # Shell
      bold-is-bright = true;

      # Linux/Theming
      gtk-titlebar = false;
      adw-toolbar-style = "flat";
      gtk-single-instance = true;

      gtk-custom-css = "tab-style.css";

      # Keybinds
      keybind = [
        "shift+enter=text:\\n"
        "alt+t=new_tab"
        "alt+w=close_tab"
        "ctrl+,=unbind"
      ];
    };
  };

  xdg.configFile."ghostty/tab-style.css".source = ../ghostty/tab-style.css;
}
