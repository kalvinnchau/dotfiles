return {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    overrides = {
      BufferLineFill = {
        bg = '#282828',
      },
    },
  },
  config = function(_, opts)
    vim.o.background = 'dark'
    require('gruvbox').setup(opts)
    vim.cmd.colorscheme('gruvbox')
  end,
}
