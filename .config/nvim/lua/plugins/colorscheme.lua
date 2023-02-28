return {
  {
    'ellisonleao/gruvbox.nvim',
    version = false,
    lazy = false,
    priority = 1000,
    opts = {
      contrast = 'medium',
    },
    init = function(_, opts)
      vim.cmd.colorscheme('gruvbox')
    end,
  },
  config = function(_, opts)
    vim.o.background = 'dark'
    require('gruvbox').setup(opts)
    vim.cmd.colorscheme('gruvbox')
  end,
}
