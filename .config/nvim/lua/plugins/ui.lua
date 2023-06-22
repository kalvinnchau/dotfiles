return {
  -- better vim.ui
  {
    'stevearc/dressing.nvim',
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.input(...)
      end
    end,
  },

  -- bufferline
  {
    'akinsho/nvim-bufferline.lua',
    event = 'VeryLazy',
    --lazy = false,
    --priority = 900,
    init = function()
      vim.keymap.set('n', '[<tab>', ':BufferLineCycleNext<cr>')
      vim.keymap.set('n', '[<s-tab>', ':BufferLineCyclePrev<cr>')
    end,
    config = true,
    opts = {
      options = {
        numbers = 'buffer_id',
        diagnostics = 'nvim_lsp',
        offsets = {
          {
            --filetype = 'NvimTree',
            filetype = 'neo-tree',
            text_align = 'center',
            text = 'Explorer',
          },
        },
      },
      -- remove italics
      highlights = {
        --fill = {
        --  bg = '#80a0ff',
        --},
        buffer_selected = {
          bold = true,
        },
        diagnostic_selected = {
          bold = true,
        },
        info_selected = {
          bold = true,
        },
        info_diagnostic_selected = {
          bold = true,
        },
        warning_selected = {
          bold = true,
        },
        warning_diagnostic_selected = {
          bold = true,
        },
        error_selected = {
          bold = true,
        },
        error_diagnostic_selected = {
          bold = true,
        },
        pick_selected = {
          bold = true,
        },
        pick_visible = {
          bold = true,
        },
        pick = {
          bold = true,
        },
      },
    },
  },

  -- statusline plugins
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      theme = 'gruvbox',
    },
  },

  -- indent guides for Neovim
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      char = '│',
      filetype_exclude = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy' },
      show_trailing_blankline_indent = false,
      show_current_context = true,
      show_current_context_start = true,
      use_treesitter = true,
    },
  },

  -- smooth scrolling
  {
    'karb94/neoscroll.nvim',
    event = 'VeryLazy',
    init = function()
      local t = {}
      -- Syntax: t[keys] = {function, {function arguments}}
      -- scroll(lines, move_cursor, time[, easing])
      t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '150', [['sine']] } }
      t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '150', [['sine']] } }
      t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '150', [['sine']] } }
      t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '150', [['sine']] } }
      -- Pass "nil" to disable the easing animation (constant scrolling speed)
      t['<C-y>'] = { 'scroll', { '-0.10', 'false', '100', nil } }
      t['<C-e>'] = { 'scroll', { '0.10', 'false', '100', nil } }
      -- When no easing function is provided the default easing function (in this case "quadratic") will be used
      -- zX(half_win_time[, easing])
      t['zt'] = { 'zt', { '100' } }
      t['zz'] = { 'zz', { '100' } }
      t['zb'] = { 'zb', { '100' } }

      require('neoscroll.config').set_mappings(t)
    end,
    opts = {
      easing_function = 'quadratic',
    },
  },

  -- highlights trailing spaces
  {
    'echasnovski/mini.trailspace',
    event = 'VeryLazy',
    version = false,
    opts = {
      only_in_normal_buffers = true,
    },
    config = function(_, opts)
      require('mini.trailspace').setup(opts)
    end,
  },

  -- render the colors
  {
    'norcalli/nvim-colorizer.lua',
    event = 'VeryLazy',
    config = true,
  },

  -- nvim-progress
  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    event = 'VeryLazy',
    config = true,
  },

  -- icons
  'nvim-tree/nvim-web-devicons',

  -- ui components
  'MunifTanjim/nui.nvim',

  -- nvim-progress
  'j-hui/fidget.nvim',
}
