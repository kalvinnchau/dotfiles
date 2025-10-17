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
      local neoscroll = require('neoscroll')
      neoscroll.setup(opts)

      -- custom mappings using helper functions (replaces deprecated set_mappings)
      local modes = { 'n', 'v', 'x' }
      local keymap = {
        ['<C-u>'] = function()
          neoscroll.ctrl_u({ duration = 150, easing = 'sine' })
        end,
        ['<C-d>'] = function()
          neoscroll.ctrl_d({ duration = 150, easing = 'sine' })
        end,
        ['<C-b>'] = function()
          neoscroll.ctrl_b({ duration = 150, easing = 'sine' })
        end,
        ['<C-f>'] = function()
          neoscroll.ctrl_f({ duration = 150, easing = 'sine' })
        end,
        ['<C-y>'] = function()
          neoscroll.scroll(-0.10, { move_cursor = false, duration = 100 })
        end,
        ['<C-e>'] = function()
          neoscroll.scroll(0.10, { move_cursor = false, duration = 100 })
        end,
        ['zt'] = function()
          neoscroll.zt({ half_win_duration = 100 })
        end,
        ['zz'] = function()
          neoscroll.zz({ half_win_duration = 100 })
        end,
        ['zb'] = function()
          neoscroll.zb({ half_win_duration = 100 })
        end,
      }
      for key, func in pairs(keymap) do
        vim.keymap.set(modes, key, func)
      end
    end,
  },

  -- color highlighter
  {
    'nvim-mini/mini.hipatterns',
    event = 'VeryLazy',
    opts = function()
      local hi = require('mini.hipatterns')
      return {
        highlighters = {
          hex_color = hi.gen_highlighter.hex_color(),
        },
      }
    end,
  },

  -- lsp progress ui
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },

  -- icons
  {
    'nvim-mini/mini.icons',
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
