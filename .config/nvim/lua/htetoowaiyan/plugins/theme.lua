-- Theme

return {
    -- Color scheme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato", -- latte, frappe, macchiato, mocha
                -- flavour = "latte", -- latte, frappe, macchiato, mocha
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
        end
    },

    -- File icons
    'nvim-tree/nvim-web-devicons',

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        -- dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
        config = function()
            require('lualine').setup {
                options = {
                    theme = "catppuccin"
                },
                sections = {
                    lualine_c = { {
                        "harpoon2",
                        -- icon = '♥',
                        indicators = { "n", "m", "u", "i" },
                        active_indicators = { "N", "M", "U", "I" },
                    } },
                    lualine_x = { "encoding", { "fileformat", symbols = { unix = "" } }, "filetype" },
                },
            }
        end
    },

    -- Git decorations
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Actions
                    map('n', '<leader>hs', gs.stage_hunk)
                    map('n', '<leader>hr', gs.reset_hunk)
                    map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                    map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                    map('n', '<leader>hu', gs.undo_stage_hunk)
                    map('n', '<leader>hR', gs.reset_buffer)
                    map('n', '<leader>hp', gs.preview_hunk)
                    map('n', '<leader>hb', function() gs.blame_line { full = true } end)
                    map('n', '<leader>hd', gs.diffthis)
                    map('n', '<leader>hD', function() gs.diffthis('~') end)
                    map('n', '<leader>td', gs.toggle_deleted)

                    -- Text object
                    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                end
            }
        end
    },

    -- Minimap
    {
        'echasnovski/mini.map',
        branch = 'stable',
        config = function()
            local map = require('mini.map')
            map.setup({
                integrations = {
                    map.gen_integration.gitsigns(),
                },
                symbols = {
                    encode = map.gen_encode_symbols.dot('4x2'),
                },
                window = {
                    width = 10,
                    show_integration_count = false,
                },
            })

            -- Open by default, but not in netrw
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function()
                    local exclude = { "netrw", "qf", "help", "minimap", "TelescopePrompt", "TelescopeResults", "lazy", "mason" }
                    if not vim.tbl_contains(exclude, vim.bo.filetype) then
                        map.open()
                    else
                        map.close()
                    end
                end,
            })

            vim.keymap.set('n', '<leader>mm', map.toggle, { desc = "Toggle Minimap" })
        end
    }

}
