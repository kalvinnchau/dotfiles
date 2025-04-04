return {
  -- generate a markdown table of contents
  {
    'mzlogin/vim-markdown-toc',
    ft = 'markdown',
  },

  -- toggle markdown preview
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },

  -- paste from macos clipboard to termnial
  {
    'mattdibi/incolla.nvim',
    ft = 'markdown',
    opts = {
      -- Default configuration for all filetype
      defaults = {
        img_dir = 'images',
        img_name = function()
          return os.date('%Y-%m-%d-%H-%M-%S')
        end,
        affix = '%s',
      },
      -- You can customize the behaviour for a filetype by creating a field named after the desired filetype
      -- If you're uncertain what to name your field to, you can run `lua print(vim.bo.filetype)`
      -- Missing options from `<filetype>` field will be replaced by the default configuration
      markdown = {
        affix = '![](%s)',
      },
    },
    init = function()
      vim.api.nvim_set_keymap('n', '<leader>fp', '', {
        noremap = true,
        callback = function()
          require('incolla').incolla()
        end,
        desc = 'paste image as markdown uri',
      })
    end,
  },
}
