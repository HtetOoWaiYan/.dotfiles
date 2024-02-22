-- Quality of life plugins

return {
    'tpope/vim-surround',
    'tpope/vim-commentary',
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {}
        end
    },
    'bkad/CamelCaseMotion',

    -- Netrw enhancement
    'tpope/vim-vinegar',
    {
        'prichrd/netrw.nvim',
        config = function()
            require('netrw').setup {
                -- Put your configuration here, or leave the object empty to take the default
                -- configuration.
                icons = {
                    symlink = '', -- Symlink icon (directory and file)
                    directory = '', -- Directory icon
                    file = '', -- File icon
                },
                use_devicons = true, -- Uses nvim-web-devicons if true, otherwise use the file icon specified above
                mappings = {}, -- Custom key mappings
            }
        end
    }
}
