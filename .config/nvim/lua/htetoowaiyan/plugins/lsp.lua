-- LSP, Autocomplete, Snippet

return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    dependencies = {
        -- LSP Support
        { 'neovim/nvim-lspconfig' }, -- Required

        --- Uncomment these if you want to manage LSP servers from neovim
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },

        -- Autocompletion
        { 'hrsh7th/nvim-cmp' },     -- Required
        { 'hrsh7th/cmp-nvim-lsp' }, -- Required
        { 'hrsh7th/cmp-buffer' },
        { 'L3MON4D3/LuaSnip' },     -- Required

        -- Formatting
        { 'nvimtools/none-ls.nvim' },
        { 'MunifTanjim/prettier.nvim' },
    },
    config = function()
        local lsp = require('lsp-zero')

        local lsp_attach = function(client, bufnr)
            -- see :help lsp-zero-keybindings
            -- to learn the available actions
            lsp.default_keymaps({ buffer = bufnr })
        end

        lsp.extend_lspconfig({
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            lsp_attach = lsp_attach,
            float_border = 'rounded',
            sign_text = true,
        })

        require('mason').setup({})
        require('mason-lspconfig').setup({
            -- Replace the language servers listed here
            -- with the ones you want to install
            ensure_installed = { 'denols', 'ts_ls', 'eslint', 'rust_analyzer', 'tailwindcss' },
            handlers = {
                lsp.default_setup,
                lua_ls = function()
                    -- (Optional) Configure lua language server for neovim
                    require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
                end,
                eslint = function()
                    require('lspconfig').eslint.setup({
                        on_attach = lsp.on_attach,
                        root_dir = require('lspconfig.util').root_pattern("package.json", ".eslintrc.js", ".eslintrc.mjs"
                        , ".eslintrc.json")
                    })
                end,
                ts_ls = function()
                    require('lspconfig').ts_ls.setup({
                        on_attach = lsp.on_attach,
                        -- root_dir = require('lspconfig.util').root_pattern("package.json"),
                        root_dir = function(fname)
                            local util = require('lspconfig.util')
                            -- Check if the project has package.json but not deno.json, deno.jsonc, or deno.lock
                            if util.root_pattern("deno.json", "deno.jsonc", "deno.lock", "seed.sql")(fname) then
                                return nil
                            end
                            return util.root_pattern("package.json")(fname)
                        end,
                        single_file_support = false,
                    })
                end,
                denols = function()
                    require('lspconfig').denols.setup {
                        on_attach = lsp.on_attach,
                        root_dir = require('lspconfig.util').root_pattern("deno.json", "deno.jsonc", "deno.lock",
                            "seed.sql"),
                    }
                end,
                tailwindcss = function()
                    require('lspconfig').tailwindcss.setup {
                        on_attach = lsp.on_attach,
                        root_dir = require('lspconfig.util').root_pattern("tailwind.config.js", "tailwind.config.ts"),
                        settings = {
                            tailwindCSS = {
                                classAttributes = { "class", "className", "class:list", "classList", "ngClass",
                                    "extendedClassName" },
                                lint = {
                                    cssConflict = "warning",
                                    invalidApply = "error",
                                    invalidConfigPath = "error",
                                    invalidScreen = "error",
                                    invalidTailwindDirective = "error",
                                    invalidVariant = "error",
                                    recommendedVariantOrder = "warning"
                                },
                                validate = true
                            }
                        }
                    }
                end,
            },
        })

        local cmp = require('cmp')

        local has_words_before = function()
            if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
        end

        cmp.setup({
            sources = {
                { name = 'copilot',  group_index = 2 },
                -- { name = 'supermaven', group_index = 2 },
                { name = 'nvim_lsp', group_index = 2 },
                { name = 'path',     group_index = 2 },
                { name = 'buffer',   keyword_length = 3 },
            },
            mapping = cmp.mapping.preset.insert({
                -- `Enter` key to confirm completion
                ['<CR>'] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                }),
                ["<Tab>"] = vim.schedule_wrap(function(fallback)
                    if cmp.visible() and has_words_before() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        fallback()
                    end
                end),
            }),
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            sorting = {
                priority_weight = 2,
                comparators = {
                    require("copilot_cmp.comparators").prioritize,

                    -- Below is the default comparitor list and order for nvim-cmp
                    cmp.config.compare.offset,
                    -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    cmp.config.compare.recently_used,
                    cmp.config.compare.locality,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },
        })

        local prettier = require("prettier")

        prettier.setup({
            bin = 'prettierd', -- or `'prettierd'` (v0.23.3+)
            filetypes = {
                "css",
                "graphql",
                "html",
                "javascript",
                "javascriptreact",
                "json",
                "less",
                "markdown",
                "scss",
                "typescript",
                "typescriptreact",
                "yaml",
            },
        })

        local null_ls = require('null-ls')

        null_ls.setup({
            sources = {
                -- Replace these with the tools you have installed
                -- make sure the source name is supported by null-ls
                -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
                null_ls.builtins.formatting.prettierd,
            }
        })

        lsp.format_mapping('<leader>f', {
            format_opts = {
                async = true,
                timeout_ms = 10000,
            },
            servers = {
                ['lua_ls'] = { 'lua' },
                ['rust_analyzer'] = { 'rust' },
                -- ['tsserver'] = { 'javascript', 'typescript' },
                -- if you have a working setup with null-ls
                -- you can specify filetypes it can format.
                ['null-ls'] = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json', 'jsonc' },
            }
        })

        lsp.format_on_save({
            format_opts = {
                async = false,
                timeout_ms = 10000,
            },
            servers = {
                ['lua_ls'] = { 'lua' },
                ['rust_analyzer'] = { 'rust' },
                ['null-ls'] = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json', 'jsonc' },
            }
        })
    end
}
