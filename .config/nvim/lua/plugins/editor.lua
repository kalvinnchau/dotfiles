return {
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TSUpdateSync', 'TSUpdate' },
    main = 'nvim-treesitter',
    opts = {},
    init = function()
      local ensure_installed = {
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
        'gitcommit',
      }
      local installed = require('nvim-treesitter.config').get_installed()
      local to_install = vim.iter(ensure_installed)
        :filter(function(p) return not vim.tbl_contains(installed, p) end)
        :totable()
      if #to_install > 0 then
        require('nvim-treesitter').install(to_install)
      end

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
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

  -- utility library
  { 'nvim-lua/plenary.nvim', lazy = true },
}
