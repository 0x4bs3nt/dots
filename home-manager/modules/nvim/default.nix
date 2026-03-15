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
      loaded_perl_provider = 0;
      loaded_ruby_provider = 0;
      loaded_python3_provider = 0;
      loaded_node_provider = 0;
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
      termguicolors = true;
      pumblend = 10;
      winblend = 10;
      foldmethod = "expr";
      foldexpr = "nvim_treesitter#foldexpr()";
      foldlevel = 99;
      foldlevelstart = 99;
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

    # ── Nordic theme + IBL scope hook (runs before plugin setups) ──
    extraConfigLuaPre = ''
      -- Fillchars (box-drawing characters for window borders)
      vim.opt.fillchars = {
        eob = " ",
        vert = "│",
        horiz = "─",
        horizup = "┴",
        horizdown = "┬",
        vertleft = "┤",
        vertright = "├",
        verthoriz = "┼",
      }

      -- Nordic colorscheme setup
      require('nordic').setup({
        bold_keywords = true,
        italic_comments = true,
        transparent = { bg = false },
        bright_half = true,
        reduced_blue = true,
        cursorline = {
          bold = false,
          bold_number = true,
          theme = "dark",
          blend = 0.85,
        },
        noice = { style = "flat" },
        telescope = { style = "flat" },
        on_highlight = function(highlights, palette)
          highlights.WinSeparator = { fg = palette.gray2, bg = "NONE" }
          highlights.FloatBorder = { fg = palette.gray3, bg = "NONE" }
          highlights.NormalFloat = { bg = palette.gray0 }
        end,
      })

      -- IBL scope highlight (must be set before ibl.setup)
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IblScope", { fg = "#81A1C1" })
      end)
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
