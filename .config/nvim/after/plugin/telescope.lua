local builtin = require('telescope.builtin')
local actions = require("telescope.actions")
local Remap = require("htetoowaiyan.keymap")
local nnoremap = Remap.nnoremap

nnoremap('<C-p>', builtin.find_files, {})
nnoremap('<leader><C-p>', builtin.git_files, {})
nnoremap('<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
    },
})
