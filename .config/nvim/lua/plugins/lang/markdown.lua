return {
  -- markdown table of contents generator
  {
    'hedyhli/markdown-toc.nvim',
    ft = 'markdown',
    cmd = { 'Mtoc' },
    keys = {
      { '<leader>mtoc', '<cmd>Mtoc<cr>', desc = 'Generate markdown table of contents' },
    },
    opts = {},
  },

  -- markdown preview
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    cmd = { 'MarkdownPreview', 'MarkdownPreviewToggle', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
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
