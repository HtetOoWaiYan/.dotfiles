return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Theme
  use 'saltdotac/citylights.vim'

  -- Glorified autocomplete
  use 'github/copilot.vim'

  -- Fuzzy finder
  use {
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
  }

  -- Add-ons
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'

  -- LSP
  use 'neovim/nvim-lspconfig'

  -- Autocomplete
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/nvim-cmp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- Treesitter
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
  }

  -- Statusline
  use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
end)
