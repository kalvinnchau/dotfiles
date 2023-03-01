return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        bashls = {
          cmd = { 'bash-language-server', 'start' },
          root_dir = require('lspconfig').util.root_pattern('.git'),
        },
      },
    },
    setup = {
      bashls = function(_, _)
        return false
      end,
    },
  },
}
