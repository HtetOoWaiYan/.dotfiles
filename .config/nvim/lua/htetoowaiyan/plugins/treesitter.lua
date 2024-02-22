-- Treesitter

return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require 'nvim-treesitter.configs'.setup {
            ensure_installed = { "lua", "rust", "javascript", "typescript" },
            sync_install = false,

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        }
    end
}
