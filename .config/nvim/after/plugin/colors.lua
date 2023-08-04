-- vim.cmd("colorscheme citylights")

require("catppuccin").setup({
    flavour = "macchiato", -- latte, frappe, macchiato, mocha
    show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
    integrations = {
        cmp = true,
        gitsigns = true,
        harpoon = true,
        mason = true,
        treesitter = true,
        telescope = {
            enabled = true,
        }
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
