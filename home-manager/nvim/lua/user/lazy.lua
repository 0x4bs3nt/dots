-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- Colorscheme Setup
    -- {
    --     'EdenEast/nightfox.nvim',
    --     priority = 1000,
    --     name = 'nightfox',
    --     config = function()
    --         require('nightfox').load()
    --
    --         vim.cmd('colorscheme dayfox')
    --     end,
    -- },
    -- {
    --     'catppuccin/nvim',
    --     priority = 1000,
    --     name = 'catppuccin',
    --     init = function()
    --         require('catppuccin').setup({
    --             vim.cmd.colorscheme('catppuccin-frappe'),
    --         })
    --     end,
    -- },
    -- {
    --     'scottmckendry/cyberdream.nvim',
    --     priority = 1000,
    --     lazy = false,
    --     init = function()
    --         require('cyberdream').setup({
    --             transparent = false,
    --             hide_fillchars = true,
    --             borderless_telescope = true,
    --             terminal_colors = true,
    --         })
    --
    --         vim.cmd('colorscheme cyberdream')
    --     end,
    -- },
    -- {
    -- 	"rose-pine/neovim",
    -- 	name = "rose-pine",
    -- 	config = true,
    -- 	priority = 1000,
    -- 	init = function()
    -- 		require("rose-pine").setup({
    -- 			variant = "moon",
    -- 		})
    -- 		vim.cmd("colorscheme rose-pine")
    -- 	end,
    -- },
    {
        'rebelot/kanagawa.nvim',
        priority = 1000,
        config = true,
        init = function()
            vim.cmd([[colorscheme kanagawa]])
        end,
    },
    -- {
    -- 	"nyoom-engineering/oxocarbon.nvim",
    -- 	priority = 1000,
    -- 	init = function()
    -- 		vim.cmd([[colorscheme oxocarbon]])
    -- 	end,
    -- },
    -- {
    -- 	"0xstepit/flow.nvim",
    -- 	priority = 1000,
    -- 	config = true,
    -- 	init = function()
    -- 		vim.cmd([[colorscheme flow]])
    -- 	end,
    -- },
    -- {
    -- 	"ellisonleao/gruvbox.nvim",
    -- 	priority = 1000,
    -- 	config = true,
    -- 	init = function()
    -- 		vim.o.background = "dark"
    --
    -- 		vim.cmd([[colorscheme gruvbox]])
    -- 	end,
    -- },
    -- Highlight todo, notes, etc in comments
    { import = 'plugins' },
})
