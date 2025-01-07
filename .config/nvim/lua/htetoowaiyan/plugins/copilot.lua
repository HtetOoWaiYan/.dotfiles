-- Glorified autocomplete

return {
    {
        "zbirenbaum/copilot.lua",
        config = function()
            require('copilot').setup({
                suggestion = { enabled = false, auto_trigger = false },
                panel = { enabled = false, auto_refresh = true }
            })
        end
    },
    -- {
    --     "supermaven-inc/supermaven-nvim",
    --     config = function()
    --         require("supermaven-nvim").setup({})
    --     end,
    -- },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        config = function()
            require('copilot_cmp').setup()
        end
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        dependencies = {
            { "github/copilot.vim" },                       -- or zbirenbaum/copilot.lua
            { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        build = "make tiktoken",                            -- Only on MacOS or Linux
        opts = {
            -- See Configuration section for options
            model = 'claude-3.5-sonnet'
        },
        -- See Commands section for default commands if you want to lazy load on them
    },
}
