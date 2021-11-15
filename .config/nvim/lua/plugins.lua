return require('packer').startup({
  function(use)
    ----------------------------------------
    -- Packer can manager itself
    ----------------------------------------
    use({
      'wbthomason/packer.nvim',
    })

    ----------------------------------------
    -- Appearance
    ----------------------------------------

    -- statusline plugins
    use({
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    })
    use({
      'akinsho/nvim-bufferline.lua',
      requires = 'kyazdani42/nvim-web-devicons',
    })

    -- show indentation levels
    use({
      'lukas-reineke/indent-blankline.nvim',
    })

    -- Highlights extra whitespace in bright red
    use({
      'ntpeters/vim-better-whitespace',
    })

    -- colorscheme
    use({
      'morhetz/gruvbox',
    })

    ----------------------------------------
    -- Navigation
    ----------------------------------------
    -- sneak around s<char><char>
    use({
      'justinmk/vim-sneak',
    })

    -- tree navigation
    use({
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function()
        require('nvim-tree').setup({})
      end,
    })

    use({
      'nvim-telescope/telescope.nvim',
      requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
    })

    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
    })

    use({
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end,
    })

    ----------------------------------------
    -- Git
    ----------------------------------------
    use({
      'sindrets/diffview.nvim',
    })

    ----------------------------------------
    -- Languages
    ----------------------------------------
    use({
      'neovim/nvim-lspconfig',
    })

    -- pictograms
    use({
      'onsails/lspkind-nvim',
    })

    -- nvim-cmp completion plugin
    use({
      'hrsh7th/nvim-cmp',
    })

    -- nvim-cmp completion sources
    use({
      'hrsh7th/cmp-nvim-lsp',
      requires = { 'hrsh7th/nvim-cmp' },
    })
    use({
      'hrsh7th/cmp-buffer',
      requires = { 'hrsh7th/nvim-cmp' },
    })
    use({
      'hrsh7th/cmp-path',
      requires = { 'hrsh7th/nvim-cmp' },
    })
    use({
      'hrsh7th/cmp-nvim-lua',
      requires = { 'hrsh7th/nvim-cmp' },
    })

    use({
      'jose-elias-alvarez/null-ls.nvim',
      requires = { { 'nvim-lua/plenary.nvim' }, { 'neovim/nvim-lspconfig' } },
    })

    -- snippet engine
    use({
      'L3MON4D3/LuaSnip',
    })

    use({
      'saadparwaiz1/cmp_luasnip',
    })

    -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
    use({
      'antoinemadec/FixCursorHold.nvim',
    })

    -- light build for code actions
    use({
      'kosayoda/nvim-lightbulb',
    })

    -- Filetypes
    use({
      'martinda/Jenkinsfile-vim-syntax',
      ft = 'Jenkinsfile',
    })

    use({
      'ekalinin/Dockerfile.vim',
      ft = 'dockerfile',
      config = function()
        vim.cmd([[au BufRead,BufNewFile Dockerfile set filetype=dockerfile]])
        vim.cmd([[au BufRead,BufNewFile Dockerfile* set filetype=dockerfile]])
      end,
    })

    use({
      'mitsuhiko/vim-jinja',
      ft = 'jinja',
    })

    use({
      'towolf/vim-helm',
      ft = 'helm',
    })

    use({
      'stephpy/vim-yaml',
      ft = 'yaml',
    })
    use({
      'pedrohdz/vim-yaml-folds',
      ft = 'yaml',
    })

    use({
      'elzr/vim-json',
      ft = 'json',
    })

    use({
      'mzlogin/vim-markdown-toc',
    })

    use({
      'iamcco/markdown-preview.nvim',
      run = function()
        vim.fn['mkdp#util#install']()
      end,
      ft = 'markdown',
    })

    use({
      'yuezk/vim-js',
    })

    use({
      'maxmellon/vim-jsx-pretty',
    })
  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    },
  },
})
