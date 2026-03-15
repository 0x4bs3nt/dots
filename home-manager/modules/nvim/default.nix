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

      -- Catppuccin colorscheme setup (light mode)
      require('catppuccin').setup({
        flavour = 'latte',
        background = { light = 'latte' },
        integrations = {
          dashboard = true,
          flash = true,
          fidget = true,
          gitsigns = true,
          indent_blankline = { enabled = true },
          mason = true,
          mini = { enabled = true },
          native_lsp = { enabled = true },
          neotree = true,
          noice = true,
          notify = true,
          telescope = { enabled = true },
          treesitter = true,
          trouble = true,
          which_key = true,
        },
      })

      -- Synchronously detect system theme and apply colorscheme before plugins load
      local handle = io.popen(
        'dbus-send --session --print-reply=literal --reply-timeout=1000 '
        .. '--dest=org.freedesktop.portal.Desktop '
        .. '/org/freedesktop/portal/desktop '
        .. 'org.freedesktop.portal.Settings.Read '
        .. 'string:org.freedesktop.appearance string:color-scheme 2>/dev/null'
      )
      local result = handle and handle:read('*a') or ""
      if handle then handle:close() end

      if result:match("uint32 1") then
        vim.o.background = 'dark'
        vim.cmd.colorscheme('nordic')
      else
        vim.o.background = 'light'
        vim.cmd.colorscheme('catppuccin-latte')
      end

      -- IBL scope highlight (must be set before ibl.setup)
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        local color = vim.o.background == "light" and "#7287A0" or "#81A1C1"
        vim.api.nvim_set_hl(0, "IblScope", { fg = color })
      end)

      -- Re-apply IBL scope color on colorscheme change
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local color = vim.o.background == "light" and "#7287A0" or "#81A1C1"
          vim.api.nvim_set_hl(0, "IblScope", { fg = color })
        end,
      })
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
