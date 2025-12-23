return {
  -- core dap
  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<leader>bb', desc = 'Toggle breakpoint' },
      { '<leader>bn', desc = 'Continue' },
      { '<leader>bl', desc = 'Step over' },
      { '<leader>bj', desc = 'Step into' },
      { '<leader>bk', desc = 'Step out' },
      { '<leader>bh', desc = 'Step back' },
    },
    config = function()
      local dap = require('dap')

      vim.keymap.set('n', '<leader>bb', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
      vim.keymap.set('n', '<leader>bn', dap.continue, { desc = 'Continue' })
      vim.keymap.set('n', '<leader>bl', dap.step_over, { desc = 'Step over' })
      vim.keymap.set('n', '<leader>bj', dap.step_into, { desc = 'Step into' })
      vim.keymap.set('n', '<leader>bk', dap.step_out, { desc = 'Step out' })
      vim.keymap.set('n', '<leader>bh', dap.step_back, { desc = 'Step back' })
    end,
  },

  -- virtual text
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
    opts = {},
  },

  -- dap ui
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    keys = {
      { '<leader>Du', desc = 'Toggle DAP UI' },
      { '<leader>Df', desc = 'DAP float scopes' },
    },
    config = function()
      local dapui = require('dapui')

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.50 },
              { id = 'stacks', size = 0.25 },
              { id = 'breakpoints', size = 0.25 },
            },
            position = 'left',
            size = 50,
          },
          {
            elements = {
              { id = 'repl', size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            position = 'bottom',
            size = 10,
          },
        },
      })

      vim.keymap.set('n', '<leader>Du', dapui.toggle, { desc = 'Toggle DAP UI' })
      vim.keymap.set('n', '<leader>Df', function()
        dapui.float_element('scopes')
      end, { desc = 'DAP float scopes' })
    end,
  },
}
