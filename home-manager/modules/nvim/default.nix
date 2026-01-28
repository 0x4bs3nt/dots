{ pkgs, ... }:
{
  imports = [
    ./plugins.nix
    ./lsp.nix
    ./keymaps.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    nixpkgs.config.allowUnfree = true;

    # ── Globals ──────────────────────────────────────────────
    globals = {
      mapleader = " ";
      maplocalleader = " ";
      have_nerd_font = true;
    };

    # ── Options ──────────────────────────────────────────────
    opts = {
      number = true;
      mouse = "a";
      showmode = false;
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      shiftwidth = 4;
      tabstop = 4;
      splitright = true;
      splitbelow = true;
      inccommand = "split";
      cursorline = true;
      scrolloff = 15;
      guicursor = "n-v-c:block-Cursor/lCursor-blinkon0";
      clipboard = "unnamedplus";
    };

    # ── Autocommands ─────────────────────────────────────────
    autoGroups = {
      kickstart-highlight-yank = {
        clear = true;
      };
    };

    autoCmd = [
      {
        event = "TextYankPost";
        desc = "Highlight when yanking (copying) text";
        group = "kickstart-highlight-yank";
        callback = {
          __raw = ''
            function()
              vim.highlight.on_yank()
            end
          '';
        };
      }
    ];

    # ── Lualine bubbles theme (must load before plugins) ─────
    extraConfigLuaPre = ''
      local colors = {
        blue = "#80a0ff",
        cyan = "#79dac8",
        black = "#080808",
        white = "#c6c6c6",
        red = "#ff5189",
        violet = "#d183e8",
        grey = "#303030",
      }

      bubbles_theme = {
        normal = {
          a = { fg = colors.black, bg = colors.violet },
          b = { fg = colors.white, bg = colors.grey },
          c = { fg = colors.white },
        },
        insert = { a = { fg = colors.black, bg = colors.blue } },
        visual = { a = { fg = colors.black, bg = colors.cyan } },
        replace = { a = { fg = colors.black, bg = colors.red } },
        inactive = {
          a = { fg = colors.white, bg = colors.black },
          b = { fg = colors.white, bg = colors.black },
          c = { fg = colors.white },
        },
      }
    '';

    # ── Extra packages (formatters, linters, tools) ──────────
    extraPackages = with pkgs; [
      gcc
      stylua
      prettierd
      shfmt
      markdownlint-cli
      ripgrep
      fd
      nixfmt-rfc-style
    ];
  };
}
