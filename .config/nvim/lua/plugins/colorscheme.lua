return {
  {
    'ellisonleao/gruvbox.nvim',
    version = false,
    lazy = false,
    priority = 1000,
    opts = {
      contrast = 'medium',
    },
    init = function()
      vim.cmd.colorscheme('gruvbox')
    end,
  },
}
