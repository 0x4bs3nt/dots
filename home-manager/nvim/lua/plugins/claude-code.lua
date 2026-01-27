return {
    'greggh/claude-code.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
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
    end,
}
