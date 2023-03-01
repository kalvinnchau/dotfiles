return {
  -- library used by other plugins
  'nvim-lua/plenary.nvim',

  {
    'antoinemadec/FixCursorHold.nvim',
    event = 'VeryLazy',
    init = function()
      vim.g.cursorhold_updatetime = 100
    end,
  },
}
