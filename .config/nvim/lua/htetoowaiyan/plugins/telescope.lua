-- Glorified fuzzy finder

return {
    {
        'nvim-telescope/telescope.nvim',
        branch = 'master',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            local Remap = require("htetoowaiyan.keymap")
            local nnoremap = Remap.nnoremap

            nnoremap('<C-p>', builtin.find_files, {})
            nnoremap('<leader><C-p>', builtin.git_files, {})
            nnoremap('<leader><C-f>', builtin.live_grep, {})
            nnoremap('<leader>fb', builtin.buffers, {})
            nnoremap('<leader>fc', builtin.commands, {})
            nnoremap('<leader>fch', builtin.command_history, {})
            nnoremap('<leader>fm', builtin.marks, {})
            nnoremap('<leader>fq', builtin.quickfix, {})
            nnoremap('<leader>fg', builtin.git_status, {})

            local actions = require("telescope.actions")

            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-h>"] = actions.preview_scrolling_left,
                            ["<C-l>"] = actions.preview_scrolling_right,
                        },
                        n = {
                            ["<C-h>"] = actions.preview_scrolling_left,
                            ["<C-l>"] = actions.preview_scrolling_right,
                        }
                    }
                }
            })

            require('telescope').load_extension('fzf')
        end
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
}
