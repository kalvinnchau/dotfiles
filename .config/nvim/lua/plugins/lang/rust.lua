vim.g.rustaceanvim = function()
  local cfg = {
    -- Plugin configuration
    tools = {
      float_win_config = {
        border = 'rounded',
      },
      test_executor = 'background',
    },
    -- LSP configuration
    server = {
      on_attach = function(client, bufnr) end,
      default_settings = {
        ['rust-analyzer'] = {
          settings = {
            diagnostic = {
              refreshSupport = false,
            },
          },
        },
      },
    },
    -- DAP configuration
    dap = {},
  }
  return cfg
end

return {
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false, -- This plugin is already lazy
    keys = {
      {
        '<leader>rd',
        function()
          vim.cmd.RustLsp('debuggables')
        end,
        desc = 'show all debuggables',
      },
      {
        '<leader>rr',
        function()
          vim.cmd.RustLsp('runnables')
        end,
        desc = 'show all runnables',
      },
      {
        '<leader>rt',
        function()
          vim.cmd.RustLsp('testables')
        end,
        desc = 'show all testables',
      },
    },
  },
}
