require("harpoon").setup()

local Remap = require("htetoowaiyan.keymap")
local nnoremap = Remap.nnoremap

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

nnoremap('<leader>a', mark.add_file)
nnoremap('<C-h>', ui.toggle_quick_menu)
nnoremap('<leader>n', function() ui.nav_file(1) end)
nnoremap('<leader>m', function() ui.nav_file(2) end)
nnoremap('<leader>u', function() ui.nav_file(3) end)
nnoremap('<leader>i', function() ui.nav_file(4) end)
