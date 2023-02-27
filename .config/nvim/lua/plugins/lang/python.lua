return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        pyright = {},
      },
    },
    setup = {
      pyright = function(_, _)
        return false
      end,
    },
  },
}
