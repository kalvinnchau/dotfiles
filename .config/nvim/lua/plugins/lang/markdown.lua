return {
  -- markdown table of contents generator
  {
    'mzlogin/vim-markdown-toc',
    ft = 'markdown',
  },

  -- markdown preview
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },

  -- paste images from clipboard
  {
    'mattdibi/incolla.nvim',
    ft = 'markdown',
    keys = {
      {
        '<leader>fp',
        function()
          require('incolla').incolla()
        end,
        desc = 'paste image as markdown uri',
      },
    },
    opts = {
      defaults = {
        img_dir = 'images',
        img_name = function()
          return os.date('%Y-%m-%d-%H-%M-%S')
        end,
        affix = '%s',
      },
      markdown = {
        affix = '![](%s)',
      },
    },
  },
}
