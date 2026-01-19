return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
        },
        config = function()
            -- Suppress lspconfig deprecation warning for now
            -- TODO: Migrate to vim.lsp.config() when the API is more stable
            vim.deprecate = function() end

            require("fidget").setup({})
            require("mason").setup()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "prettierd",
                    "stylua",
                },
            })

            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- Enhanced on_attach with additional navigation keymaps
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }

                -- Custom gd that jumps directly if only one definition
                local function go_to_definition()
                    -- Get position encoding from first LSP client
                    local clients = vim.lsp.get_clients({ bufnr = bufnr })
                    local offset_encoding = clients[1] and clients[1].offset_encoding or 'utf-16'

                    local params = vim.lsp.util.make_position_params(0, offset_encoding)
                    vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx, config)
                        if err then
                            vim.notify('Error getting definition: ' .. err.message, vim.log.levels.ERROR)
                            return
                        end
                        if not result or vim.tbl_isempty(result) then
                            vim.notify('No definition found', vim.log.levels.WARN)
                            return
                        end

                        -- Handle both single result and array of results
                        local locations = vim.islist(result) and result or { result }

                        -- Jump to first location (always, even if multiple)
                        vim.lsp.util.jump_to_location(locations[1], offset_encoding)
                    end)
                end

                -- Navigation keymaps
                vim.keymap.set("n", "gd", go_to_definition, opts)
                vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
                vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
                vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
                vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

                -- Workspace and diagnostics
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

                -- Code actions and refactoring
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

                -- Toggle inlay hints (Neovim 0.11+)
                if vim.lsp.inlay_hint then
                    vim.keymap.set("n", "<leader>vh", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
                    end, opts)
                end
            end

            -- Enhanced diagnostic configuration
            vim.diagnostic.config({
                virtual_text = {
                    prefix = '●',
                    source = 'if_many'
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    source = 'always',
                    border = 'rounded'
                },
            })

            -- Better diagnostic signs
            local signs = {
                Error = "󰅚 ",
                Warn = "󰀪 ",
                Hint = "󰌶 ",
                Info = " "
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            -- Get lspconfig
            local lspconfig = require("lspconfig")
            local util = require('lspconfig.util')

            -- Mason-lspconfig setup
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "ts_ls",
                    "eslint",
                    "tailwindcss",
                    "denols",
                    "lua_ls",
                    "rust_analyzer",
                },
            })

            -- TypeScript/JavaScript (ts_ls) - Enhanced monorepo support
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                root_dir = function(fname)
                    -- Skip Deno projects
                    if util.root_pattern("deno.json", "deno.jsonc", "deno.lock", "seed.sql")(fname) then
                        return nil
                    end

                    -- Monorepo support: prefer workspace root (lock files) to avoid duplicates
                    -- This ensures all files in the monorepo share the same LSP server instance
                    local root = util.root_pattern("yarn.lock", "pnpm-lock.yaml", "package-lock.json")(fname)
                        or util.root_pattern("package.json", "tsconfig.json")(fname)

                    return root
                end,
                single_file_support = false,
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        }
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        }
                    }
                }
            })

            -- ESLint - Support for flat config
            lspconfig.eslint.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                root_dir = function(fname)
                    -- Prefer workspace root to avoid duplicates in monorepos
                    return util.root_pattern("yarn.lock", "pnpm-lock.yaml", "package-lock.json")(fname)
                        or util.root_pattern(
                            "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
                            ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml", ".eslintrc.yml",
                            ".eslintrc.json", ".eslintrc", "package.json"
                        )(fname)
                end,
                settings = {
                    format = false,
                }
            })

            -- Tailwind CSS - Enhanced with cva/cx support
            lspconfig.tailwindcss.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    tailwindCSS = {
                        experimental = {
                            classRegex = {
                                { [=[cva\(([^)]*)\)]=], [=[["'`]([^"'`]*).*?["'`]]=] },
                                { [=[cx\(([^)]*)\)]=], [=[(?:'|"|`)([^']*)(?:'|"|`)]=] }
                            },
                        },
                    },
                },
            })

            -- Deno - Deno-specific projects
            lspconfig.denols.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                root_dir = util.root_pattern("deno.json", "deno.jsonc", "deno.lock", "seed.sql"),
                settings = {
                    deno = {
                        enable = true,
                        unstable = true,
                    }
                }
            })

            -- Lua - Enhanced with workspace library detection
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                        hint = {
                            enable = true,
                        },
                    },
                },
            })

            -- Rust Analyzer - Enhanced cargo support
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ['rust-analyzer'] = {
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            runBuildScripts = true,
                        },
                        procMacro = {
                            enable = true,
                        },
                        checkOnSave = {
                            command = "clippy",
                        },
                    },
                },
            })

            -- nvim-cmp configuration (unchanged - working correctly)
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                })
            })
        end
    },
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                css = { "prettierd", "prettier", stop_after_first = true },
                html = { "prettierd", "prettier", stop_after_first = true },
                json = { "prettierd", "prettier", stop_after_first = true },
                yaml = { "prettierd", "prettier", stop_after_first = true },
                markdown = { "prettierd", "prettier", stop_after_first = true },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        },
    }
}
