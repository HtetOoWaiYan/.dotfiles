return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- Theme
    -- use 'saltdotac/citylights.vim'
    use { "catppuccin/nvim", as = "catppuccin" }

    -- Add-ons
    use 'tpope/vim-surround'
    use 'tpope/vim-commentary'
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {}
        end
    }
    use 'bkad/CamelCaseMotion'

    -- Glorified autocomplete
    use "zbirenbaum/copilot.lua"
    use {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end
    }

    -- Glorified fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- LSP, Autocomplete, Snippet
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'dev-v3',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required

            --- Uncomment these if you want to manage LSP servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' }, -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'hrsh7th/cmp-buffer' },
            { 'L3MON4D3/LuaSnip' }, -- Required

            -- Formatting
            { 'jose-elias-alvarez/null-ls.nvim' },
            { 'MunifTanjim/prettier.nvim' },
        }
    }

    -- File icons
    use 'nvim-tree/nvim-web-devicons'

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- Statusline
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- Git decorations
    use 'lewis6991/gitsigns.nvim'

    -- Navigation
    use 'ThePrimeagen/harpoon'

    -- Netrw enhancement
    use 'tpope/vim-vinegar'
    use 'prichrd/netrw.nvim'

    -- File explorer
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        }
    }
end)
