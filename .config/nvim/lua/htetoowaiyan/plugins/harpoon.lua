-- Navigation

return {
    "letieu/harpoon-lualine",
    dependencies = {
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            config = function()
                local harpoon = require("harpoon")

                -- REQUIRED
                harpoon:setup({
                    settings = {
                        save_on_toggle = true,
                        sync_on_ui_close = true,
                    }
                })
                -- REQUIRED

                local Remap = require("htetoowaiyan.keymap")
                local nnoremap = Remap.nnoremap

                nnoremap('<leader>a', function() harpoon:list():add() end)
                nnoremap('<C-h>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
                nnoremap('<leader>n', function() harpoon:list():select(1) end)
                nnoremap('<leader>m', function() harpoon:list():select(2) end)
                nnoremap('<leader>u', function() harpoon:list():select(3) end)
                nnoremap('<leader>i', function() harpoon:list():select(4) end)
            end
        }
    },

}
