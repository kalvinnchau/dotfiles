return {
  -- Core DAP
  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<leader>bb', function() require('dap').toggle_breakpoint() end, desc = 'Toggle breakpoint' },
      { '<leader>bn', function() require('dap').continue() end, desc = 'Continue' },
      { '<leader>bl', function() require('dap').step_over() end, desc = 'Step over' },
      { '<leader>bj', function() require('dap').step_into() end, desc = 'Step into' },
      { '<leader>bk', function() require('dap').step_out() end, desc = 'Step out' },
      { '<leader>bh', function() require('dap').step_back() end, desc = 'Step back' },
    },
  },

  -- Virtual text
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
    opts = {},
  },

  -- DAP UI
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    keys = {
      { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle DAP UI' },
      { '<leader>df', function() require('dapui').float_element('scopes') end, desc = 'DAP float scopes' },
    },
    opts = {
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
    },
  },
}
