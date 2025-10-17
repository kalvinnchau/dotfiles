return {
  -- colorscheme
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    opts = { contrast = 'medium' },
    config = function(_, opts)
      require('gruvbox').setup(opts)
      vim.cmd.colorscheme('gruvbox')
    end,
  },

  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = { options = { theme = 'gruvbox' } },
  },

  -- bufferline
  {
    'akinsho/nvim-bufferline.lua',
    event = 'VeryLazy',
    keys = {
      { '[<tab>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
      { '[<s-tab>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
    },
    opts = {
      options = {
        numbers = 'buffer_id',
        diagnostics = 'nvim_lsp',
        offsets = {
          { filetype = 'neo-tree', text = 'Explorer', text_align = 'center' },
        },
      },
      highlights = {
        buffer_selected = { bold = true },
        diagnostic_selected = { bold = true },
        info_selected = { bold = true },
        info_diagnostic_selected = { bold = true },
        warning_selected = { bold = true },
        warning_diagnostic_selected = { bold = true },
        error_selected = { bold = true },
        error_diagnostic_selected = { bold = true },
        pick_selected = { bold = true },
        pick_visible = { bold = true },
        pick = { bold = true },
      },
    },
  },

  -- indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    main = 'ibl',
    opts = {
      indent = { char = '│' },
      exclude = {
        filetypes = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy' },
      },
    },
  },

  -- smooth scrolling
  {
    'karb94/neoscroll.nvim',
    event = 'VeryLazy',
    opts = { easing_function = 'quadratic' },
    config = function(_, opts)
      require('neoscroll').setup(opts)
      local t = {}
      t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '150', [['sine']] } }
      t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '150', [['sine']] } }
      t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '150', [['sine']] } }
      t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '150', [['sine']] } }
      t['<C-y>'] = { 'scroll', { '-0.10', 'false', '100', nil } }
      t['<C-e>'] = { 'scroll', { '0.10', 'false', '100', nil } }
      t['zt'] = { 'zt', { '100' } }
      t['zz'] = { 'zz', { '100' } }
      t['zb'] = { 'zb', { '100' } }
      require('neoscroll.config').set_mappings(t)
    end,
  },

  -- color highlighter
  {
    'norcalli/nvim-colorizer.lua',
    event = 'VeryLazy',
    config = true,
  },

  -- lsp progress ui
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {},
  },

  -- icons (MODERN: mini.icons instead of nvim-web-devicons)
  {
    'echasnovski/mini.icons',
    lazy = true,
    opts = {},
    init = function()
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
  },

  -- ui components library
  'MunifTanjim/nui.nvim',
}
