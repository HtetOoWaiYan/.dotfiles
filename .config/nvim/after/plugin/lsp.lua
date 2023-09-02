local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({ buffer = bufnr })
    -- local opts = { buffer = bufnr }
end)

lsp.extend_cmp()

require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = { 'tsserver', 'eslint', 'rust_analyzer' },
    handlers = {
        lsp.default_setup,
        lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
        end,
    },
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

local null_ls = require('null-ls')

null_ls.setup({
    sources = {
        -- Replace these with the tools you have installed
        -- make sure the source name is supported by null-ls
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
        null_ls.builtins.formatting.prettierd,
    }
})

local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'copilot' },
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'buffer', keyword_length = 3 },
    },
    mapping = {
        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }),
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    }
})
