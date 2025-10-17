vim.g.rustaceanvim = function()
  return {
    tools = {
      float_win_config = { border = 'rounded' },
      test_executor = 'background',
    },
    server = {
      on_attach = function(client, bufnr) end,
      default_settings = {
        ['rust-analyzer'] = {
          settings = {
            diagnostic = { refreshSupport = false },
          },
        },
      },
    },
    dap = {},
  }
end

return {
  -- rust tooling (modern, replaces rust-tools.nvim)
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
    keys = {
      { '<leader>rd', function() vim.cmd.RustLsp('debuggables') end, desc = 'show debuggables' },
      { '<leader>rr', function() vim.cmd.RustLsp('runnables') end, desc = 'show runnables' },
      { '<leader>rt', function() vim.cmd.RustLsp('testables') end, desc = 'show testables' },
    },
  },
}
