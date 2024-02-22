-- Glorified fuzzy finder

return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
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

            require("telescope").setup()

            require('telescope').load_extension('fzf')
        end
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
}
