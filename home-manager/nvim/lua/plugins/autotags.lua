return {
    'windwp/nvim-ts-autotag',
    opts = function()
        require('nvim-ts-autotag').setup({
            opts = {
                enable_close = true,
                enable_rename = true,
                enable_close_on_slash = false,
            },
        })
    end,
}
