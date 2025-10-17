return {
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    cmd = { 'TSUpdateSync', 'TSUpdate' },
    keys = {
      { '<C-space>', desc = 'Increment selection' },
      { '<bs>', desc = 'Shrink selection', mode = 'x' },
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = false },
      auto_install = true,
      ensure_installed = {
        'astro',
        'bash',
        'go',
        'dockerfile',
        'html',
        'java',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'query',
        'regex',
        'rust',
        'terraform',
        'typescript',
        'vim',
        'vimdoc',
        'vue',
        'yaml',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = '<nop>',
          node_decremental = '<bs>',
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- surround operations
  {
    'nvim-mini/mini.surround',
    keys = { 'gz' },
    opts = {
      mappings = {
        add = 'gza',
        delete = 'gzd',
        find = 'gzf',
        find_left = 'gzF',
        highlight = 'gzh',
        replace = 'gzr',
        update_n_lines = 'gzn',
      },
      silent = false,
    },
  },

  -- trailing whitespace
  {
    'nvim-mini/mini.trailspace',
    event = 'VeryLazy',
    opts = { only_in_normal_buffers = true },
  },

  -- flash motion
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s>',
        mode = 'c',
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },

  -- reference highlighting
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = { delay = 200 },
    config = function(_, opts)
      require('illuminate').configure(opts)
    end,
    keys = {
      {
        ']]',
        function()
          require('illuminate').goto_next_reference(false)
        end,
        desc = 'Next Reference',
      },
      {
        '[[',
        function()
          require('illuminate').goto_prev_reference(false)
        end,
        desc = 'Prev Reference',
      },
    },
  },

  {
    'azorng/goose.nvim',
    ft = { 'rust', 'python', 'typescript', 'markdown', 'sh', 'kotlin', 'typescriptreact' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'MeanderingProgrammer/render-markdown.nvim', opts = { anti_conceal = { enabled = false } } },
    },
    opts = {
      providers = {
        databricks = { 'goose-claude-4-sonnet', 'goose-claude-4-opus' },
      },
    },
  },

  -- utility library
  { 'nvim-lua/plenary.nvim', lazy = true },
}
