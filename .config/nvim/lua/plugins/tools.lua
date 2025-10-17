return {
  -- file explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    cmd = 'Neotree',
    dependencies = {
      {
        's1n7ax/nvim-window-picker',
        version = '2.*',
        opts = {
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
              buftype = { 'terminal', 'quickfix' },
            },
          },
          highlights = {
            statusline = {
              focused = { fg = '#ededed', bg = '#e35e4f', bold = true },
              unfocused = { fg = '#ededed', bg = '#c96826', bold = true },
            },
            winbar = {
              focused = { fg = '#ededed', bg = '#e35e4f', bold = true },
              unfocused = { fg = '#ededed', bg = '#c96826', bold = true },
            },
          },
        },
      },
    },
    keys = {
      {
        '<leader>fe',
        function()
          require('neo-tree.command').execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = 'Neotree (cwd)',
      },
      {
        '<leader>fB',
        function()
          require('neo-tree.command').execute({ toggle = true, source = 'buffers' })
        end,
        desc = 'Neotree buffers',
      },
      {
        '<leader>fG',
        function()
          require('neo-tree.command').execute({ toggle = true, source = 'git_status' })
        end,
        desc = 'Neotree git status',
      },
      { '<leader>e', '<leader>fe', desc = 'Neotree (cwd)', remap = true },
      { '<leader>tree', '<leader>fe', desc = 'Neotree (cwd)', remap = true },
    },
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.uv.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require('neo-tree')
        end
      end
    end,
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
      },
      window = {
        mappings = {
          ['<space>'] = 'none',
          ['<C-v>'] = 'vsplit_with_window_picker',
          ['<C-x>'] = 'split_with_window_picker',
          ['<C-t>'] = 'open_tabnew',
        },
        fuzzy_finder_mappings = {
          ['<C-j>'] = 'move_cursor_down',
          ['<C-k>'] = 'move_cursor_up',
        },
      },
    },
  },

  -- fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = { 'nvim-telescope/telescope-dap.nvim' },
    keys = {
      { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Grep files (cwd)' },
      {
        '<leader>fw',
        function()
          require('telescope.builtin').live_grep({ default_text = vim.fn.expand('<cword>') })
        end,
        desc = 'Grep word under cursor',
      },
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find files (cwd)' },
      { '<leader>ft', '<cmd>Telescope git_files<cr>', desc = 'Find git files' },
      { '<leader>fs', '<cmd>Telescope git_status<cr>', desc = 'Git status files' },
      { '<leader>fb', '<cmd>Telescope buffers show_all_buffers=true<cr>', desc = 'Buffers' },
      { '<leader>fv', '<cmd>Telescope commands<cr>', desc = 'Commands' },
      { '<leader>fc', '<cmd>Telescope git_commits<cr>', desc = 'Git commits' },
      { '<leader>fk', '<cmd>Telescope keymaps<cr>', desc = 'Keymaps' },
      { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
      { '<leader>fh', '<cmd>Telescope search_history<cr>', desc = 'Search history' },
    },
    opts = {
      defaults = {
        path_display = {
          filename_first = { reverse_directories = true },
          shorten = { len = 2, exclude = { -1, -2, -3, -4 } },
        },
        layout_config = {
          horizontal = {
            width = { padding = 0 },
            height = { padding = 0 },
            preview_width = 0.5,
          },
        },
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
        },
        mappings = {
          i = {
            ['<C-j>'] = function(...)
              require('telescope.actions').move_selection_next(...)
            end,
            ['<C-k>'] = function(...)
              require('telescope.actions').move_selection_previous(...)
            end,
            ['<CR>'] = function(...)
              require('telescope.actions').select_default(...)
              require('telescope.actions').center(...)
            end,
            ['<C-x>'] = function(...)
              require('telescope.actions').select_horizontal(...)
            end,
            ['<C-v>'] = function(...)
              require('telescope.actions').select_vertical(...)
            end,
            ['<C-t>'] = function(...)
              require('telescope.actions').select_tab(...)
            end,
          },
        },
      },
      pickers = {
        git_commits = {
          mappings = {
            i = {
              ['<C-d>'] = function()
                local selected = require('telescope.actions.state').get_selected_entry()
                vim.api.nvim_win_close(0, true)
                vim.cmd('stopinsert')
                vim.schedule(function()
                  vim.cmd(('DiffviewOpen %s^!'):format(selected.value))
                end)
              end,
            },
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require('telescope')
      telescope.setup(opts)
      telescope.load_extension('dap')
    end,
  },

  -- which-key
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      plugins = { spelling = true },
      replace = { ['<leader>'] = 'SPC' },
    },
    config = function(_, opts)
      local wk = require('which-key')
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      wk.setup(opts)
      wk.add({
        mode = { 'n', 'v' },
        { '<leader><tab>', group = 'tabs' },
        { '<leader>b', group = 'buffer' },
        { '<leader>c', group = 'code' },
        { '<leader>d', group = 'diagnostics' },
        { '<leader>f', group = 'file/find' },
        { '<leader>g', group = 'git' },
        { '<leader>gh', group = 'hunks' },
        { '<leader>q', group = 'quit/session' },
        { '<leader>s', group = 'search' },
        { '<leader>u', group = 'ui' },
        { '<leader>w', group = 'windows' },
        { '<leader>x', group = 'diagnostics/quickfix' },
        { '[', group = 'prev' },
        { ']', group = 'next' },
        { 'g', group = 'goto' },
        {
          'fd',
          function()
            local start = vim.api.nvim_get_current_buf()
            vim.cmd('vnew | set buftype=nofile | read ++edit # | 0d_ | diffthis')
            local scratch = vim.api.nvim_get_current_buf()
            vim.cmd('wincmd p | diffthis')
            for _, buf in ipairs({ scratch, start }) do
              vim.keymap.set('n', 'q', function()
                vim.api.nvim_buf_delete(scratch, { force = true })
                vim.keymap.del('n', 'q', { buffer = start })
              end, { buffer = buf })
            end
          end,
          desc = 'Diff buffer vs disk',
        },
      })
    end,
  },

  -- trouble diagnostics
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer diagnostics' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=true win={type=split, position=left}<cr>', desc = 'Symbols' },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=true win={size=0.3, type=split, position=left}<cr>',
        desc = 'LSP defs/refs',
      },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location list' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix list' },
    },
    opts = {},
  },

  -- todo comments
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        desc = 'Next todo',
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        desc = 'Prev todo',
      },
      { '<leader>xt', '<cmd>TodoTrouble<cr>', desc = 'Todo (Trouble)' },
      { '<leader>xT', '<cmd>TodoTelescope<cr>', desc = 'Todo (Telescope)' },
    },
  },
}
