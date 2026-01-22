---@diagnostic disable: undefined-global
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
    'saghen/blink.indent',
    event = { 'BufReadPost', 'BufNewFile' },
    ---@module 'blink.indent'
    opts = {
      blocked = {
        filetypes = {
          include_defaults = true,
          'alpha',
          'neo-tree',
          'Trouble',
          'lazy',
        },
      },
      static = {
        char = '┊',
      },
      scope = {
        enabled = true,
        char = '│',
        underline = {
          enabled = true,
        },
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

  -- better vim.ui + picker
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    keys = {
      {
        '<leader>ff',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find files',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep files',
      },
      {
        '<leader>fw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = 'Grep word under cursor',
      },
      {
        '<leader>ft',
        function()
          Snacks.picker.git_files()
        end,
        desc = 'Find git files',
      },
      {
        '<leader>fs',
        function()
          Snacks.picker.git_status()
        end,
        desc = 'Git status files',
      },
      {
        '<leader>fb',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>fv',
        function()
          Snacks.picker.commands()
        end,
        desc = 'Commands',
      },
      {
        '<leader>fc',
        function()
          Snacks.picker.git_log()
        end,
        desc = 'Git commits',
      },
      {
        '<leader>fk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = 'Keymaps',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.recent()
        end,
        desc = 'Recent files',
      },
      {
        '<leader>fh',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command history',
      },
      {
        '<leader>tg',
        function()
          local todo_dir = vim.fn.expand('~/.local/share/todo')
          if vim.fn.isdirectory(todo_dir) == 0 then
            vim.fn.mkdir(todo_dir, 'p')
          end
          Snacks.scratch.open({
            file = todo_dir .. '/global-todo.md',
            ft = 'markdown',
            name = 'Global Todo',
          })
        end,
        desc = 'Open global todo',
      },
      {
        '<leader>tp',
        function()
          local todo_dir = vim.fn.expand('~/.local/share/todo')
          if vim.fn.isdirectory(todo_dir) == 0 then
            vim.fn.mkdir(todo_dir, 'p')
          end
          local git_root = Snacks.git.get_root()
          local name = git_root and vim.fn.fnamemodify(git_root, ':t') or 'local'
          Snacks.scratch.open({
            file = todo_dir .. '/' .. name .. '-todo.md',
            ft = 'markdown',
            name = name .. ' Todo',
          })
        end,
        desc = 'Open project todo',
      },
    },
    opts = {
      input = { enabled = true },
      scratch = { enabled = true },
      picker = {
        enabled = true,
        ui_select = true,
        layout = {
          reverse = true,
          layout = {
            box = 'horizontal',
            width = 0.95,
            height = 0.9,
            {
              box = 'vertical',
              border = 'rounded',
              { win = 'list', border = 'none' },
              { win = 'input', height = 1, border = 'top' },
            },
            { win = 'preview', width = 0.5, border = 'rounded' },
          },
        },
        win = {
          input = {
            keys = {
              ['<C-x>'] = { 'edit_split', mode = { 'i', 'n' } },
              ['<C-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
              ['<C-t>'] = { 'edit_tab', mode = { 'i', 'n' } },
            },
          },
        },
        formatters = {
          file = {
            filename_first = true,
          },
        },
      },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            {
              icon = '󰈞',
              key = 'f',
              desc = 'find file',
              action = function()
                Snacks.picker.files()
              end,
            },
            { icon = '󰈔', key = 'n', desc = 'new file', action = ':ene | startinsert' },
            {
              icon = ' ',
              key = 'g',
              desc = 'find text',
              action = function()
                Snacks.picker.grep()
              end,
            },
            {
              icon = ' ',
              key = 'r',
              desc = 'recent files',
              action = function()
                Snacks.picker.recent()
              end,
            },
            {
              icon = '󰊢 ',
              key = 'c',
              desc = 'git commits',
              action = function()
                Snacks.picker.git_log()
              end,
            },
            {
              icon = '󰘬 ',
              key = 's',
              desc = 'git status',
              action = function()
                Snacks.picker.git_status()
              end,
            },
            {
              icon = '󰄬 ',
              key = 't',
              desc = 'todo',
              action = function()
                local todo_dir = vim.fn.expand('~/.local/share/todo')
                if vim.fn.isdirectory(todo_dir) == 0 then
                  vim.fn.mkdir(todo_dir, 'p')
                end
                Snacks.scratch.open({
                  file = todo_dir .. '/global-todo.md',
                  ft = 'markdown',
                  name = 'Global Todo',
                })
              end,
            },
            { icon = '', key = 'C', desc = 'config', action = ':e ~/.config/nvim/init.lua | :cd %:p:h' },
            { icon = '󰒲 ', key = 'L', desc = 'lazy', action = ':Lazy' },
            { icon = ' ', key = 'q', desc = 'quit', action = ':qa' },
          },
        },
        sections = {
          { section = 'header' },
          { section = 'keys', gap = 1, padding = 1 },
          { pane = 2, icon = ' ', title = 'recent files', section = 'recent_files', indent = 2, padding = 1 },
          { pane = 2, icon = ' ', title = 'projects', section = 'projects', indent = 2, padding = 1 },
          {
            pane = 2,
            icon = ' ',
            title = 'git status',
            section = 'terminal',
            enabled = function()
              ---@diagnostic disable-next-line: undefined-global
              return Snacks.git.get_root() ~= nil
            end,
            cmd = 'git status --short --branch --renames',
            height = 12,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = 'startup' },
        },
      },
    },
  },

  -- ui components library
  'MunifTanjim/nui.nvim',
}
