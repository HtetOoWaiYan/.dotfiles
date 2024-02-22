-- Glorified autocomplete

return {
    {
        "zbirenbaum/copilot.lua",
        config = function()
            require('copilot').setup({
                suggestion = { enabled = false, auto_trigger = true },
                panel = { enabled = true, auto_refresh = true }
            })
        end
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        config = function()
            require('copilot_cmp').setup()
        end
    }
}
