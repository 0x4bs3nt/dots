{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      # ── Completion ─────────────────────────────────────────────
      blink-cmp = {
        enable = true;
        settings = {
          keymap.preset = "enter";
          appearance = {
            use_nvim_cmp_as_default = true;
            nerd_font_variant = "mono";
          };
          completion.documentation = {
            auto_show = true;
            auto_show_delay_ms = 10;
          };
          signature.enabled = true;
          fuzzy.implementation = "prefer_rust_with_warning";
        };
      };

      # ── Pairs & Tags ──────────────────────────────────────────
      nvim-autopairs.enable = true;

      ts-autotag = {
        enable = true;
        settings.opts = {
          enable_close = true;
          enable_rename = true;
          enable_close_on_slash = false;
        };
      };

      # ── Formatting ────────────────────────────────────────────
      conform-nvim = {
        enable = true;
        settings = {
          notify_on_error = true;
          formatters_by_ft = {
            lua = [ "stylua" ];
            javascript = [ "prettierd" ];
            typescript = [ "prettierd" ];
            typescriptreact = [ "prettierd" ];
            markdown = [ "prettierd" ];
            css = [ "prettierd" ];
            html = [ "prettierd" ];
            json = [ "prettierd" ];
            shell = [ "shfmt" ];
            sh = [ "shfmt" ];
            zsh = [ "shfmt" ];
            nix = [ "nixpkgs-fmt" ];
          };
        };
      };

      # ── Linting ───────────────────────────────────────────────
      lint = {
        enable = true;
        lintersByFt = {
          markdown = [ "markdownlint" ];
        };
      };

      # ── Git ───────────────────────────────────────────────────
      gitsigns = {
        enable = true;
        settings.on_attach = {
          __raw = ''
            function(bufnr)
              local gitsigns = require('gitsigns')
              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end

              map('n', ']c', function()
                if vim.wo.diff then
                  vim.cmd.normal({ ']c', bang = true })
                else
                  gitsigns.nav_hunk('next')
                end
              end, { desc = 'Jump to next git [c]hange' })

              map('n', '[c', function()
                if vim.wo.diff then
                  vim.cmd.normal({ '[c', bang = true })
                else
                  gitsigns.nav_hunk('prev')
                end
              end, { desc = 'Jump to previous git [c]hange' })

              map('v', '<leader>hs', function()
                gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
              end, { desc = 'stage git hunk' })
              map('v', '<leader>hr', function()
                gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
              end, { desc = 'reset git hunk' })

              map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
              map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
              map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
              map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
              map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
              map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
              map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
              map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
              map('n', '<leader>hD', function()
                gitsigns.diffthis('@')
              end, { desc = 'git [D]iff against last commit' })

              map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
              map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
            end
          '';
        };
      };

      # ── Telescope ─────────────────────────────────────────────
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          ui-select.enable = true;
        };
        settings.extensions = {
          ui-select = {
            __raw = "{ require('telescope.themes').get_dropdown() }";
          };
        };
      };

      # ── Treesitter ────────────────────────────────────────────
      treesitter = {
        enable = true;
        settings = {
          ensure_installed = [
            "bash"
            "c"
            "diff"
            "html"
            "lua"
            "luadoc"
            "markdown"
            "markdown_inline"
            "query"
            "vim"
            "vimdoc"
          ];
          highlight = {
            enable = true;
            additional_vim_regex_highlighting = [ "ruby" ];
          };
          indent = {
            enable = true;
            disable = [ "ruby" ];
          };
        };
      };

      # ── File Explorer ─────────────────────────────────────────
      neo-tree = {
        enable = true;
        settings.filesystem.window.mappings = {
          "\\" = "close_window";
        };
      };

      # ── Statusline ────────────────────────────────────────────
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = {
              __raw = "bubbles_theme";
            };
            component_separators = "";
            section_separators = {
              left = "";
              right = "";
            };
          };
          sections = {
            lualine_a = [
              {
                __unkeyed-1 = "mode";
                separator = {
                  left = "";
                };
                right_padding = 2;
              }
            ];
            lualine_b = [
              "filename"
              "branch"
            ];
            lualine_c = [ "%=" ];
            lualine_x = [ ];
            lualine_y = [
              "filetype"
              "progress"
            ];
            lualine_z = [
              {
                __unkeyed-1 = "location";
                separator = {
                  right = "";
                };
                left_padding = 2;
              }
            ];
          };
          inactive_sections = {
            lualine_a = [ "filename" ];
            lualine_b = [ ];
            lualine_c = [ ];
            lualine_x = [ ];
            lualine_y = [ ];
            lualine_z = [ "location" ];
          };
          tabline = { };
          extensions = [ ];
        };
      };

      # ── UI & Navigation ───────────────────────────────────────
      which-key = {
        enable = true;
        settings.spec = [
          {
            __unkeyed-1 = "<leader>c";
            group = "[C]ode";
          }
          {
            __unkeyed-1 = "<leader>d";
            group = "[D]ocument";
          }
          {
            __unkeyed-1 = "<leader>r";
            group = "[R]ename";
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "[S]earch";
          }
          {
            __unkeyed-1 = "<leader>w";
            group = "[W]orkspace";
          }
          {
            __unkeyed-1 = "<leader>t";
            group = "[T]oggle";
          }
          {
            __unkeyed-1 = "<leader>h";
            group = "Git [H]unk";
            mode = [
              "n"
              "v"
            ];
          }
        ];
      };

      web-devicons.enable = true;
      fidget.enable = true;
      todo-comments = {
        enable = true;
        settings.signs = false;
      };
      sleuth.enable = true;
      lazygit.enable = true;
      copilot-vim.enable = true;

      lazydev = {
        enable = true;
        settings.library = [
          {
            path = "luvit-meta/library";
            words = [ "vim%.uv" ];
          }
        ];
      };

      mini = {
        enable = true;
        modules = {
          ai = {
            n_lines = 500;
          };
          surround = { };
        };
      };

      markdown-preview = {
        enable = true;
        settings = {
          auto_close = 0;
          refresh_slow = 0;
        };
      };
    };

    # ── Extra Plugins (no first-class Nixvim module) ─────────
    extraPlugins = with pkgs.vimPlugins; [
      auto-save-nvim
      cord-nvim
      claude-code-nvim
      oxocarbon-nvim
    ];

    colorscheme = "oxocarbon";

    extraConfigLua = ''
      -- AutoSave
      require('auto-save').setup({ enabled = true })
      vim.keymap.set('n', '<leader>ts', ':ASToggle<CR>', { noremap = true, silent = true, desc = 'Toggle Auto Save' })

      -- Discord Rich Presence
      require('cord').setup({})

      -- Claude Code
      require('claude-code').setup({
        window = {
          position = 'float',
          float = {
            width = '90%',
            height = '90%',
            row = 'center',
            col = 'center',
            relative = 'editor',
            border = 'double',
          },
        },
      })

      -- Lint autocommand
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    '';
  };
}
