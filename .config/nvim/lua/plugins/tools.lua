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
          if vim.bo.filetype == 'snacks_dashboard' then
            vim.cmd('bd')
          end
          require('neo-tree.command').execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = 'Neotree (cwd)',
      },
      {
        '<leader>fB',
        function()
          if vim.bo.filetype == 'snacks_dashboard' then
            vim.cmd('bd')
          end
          require('neo-tree.command').execute({ toggle = true, source = 'buffers' })
        end,
        desc = 'Neotree buffers',
      },
      {
        '<leader>fG',
        function()
          if vim.bo.filetype == 'snacks_dashboard' then
            vim.cmd('bd')
          end
          require('neo-tree.command').execute({ toggle = true, source = 'git_status' })
        end,
        desc = 'Neotree git status',
      },
      { '<leader>e', '<leader>fe', desc = 'Neotree (cwd)', remap = true },
      { '<leader>tree', '<leader>fe', desc = 'Neotree (cwd)', remap = true },
    },
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.uv.fs_stat(vim.fn.argv(0) --[[@as string]])
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
        { '<leader>d', group = 'diagnostics/diff' },
        { '<leader>D', group = 'DAP' },
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
    cmd = { 'TodoTrouble' },
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
    },
  },
}
