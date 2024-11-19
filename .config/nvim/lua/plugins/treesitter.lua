return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old and doesn't work on Windows
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        init = function()
          -- disable rtp plugin, as we only need its queries for mini.ai
          -- In case other textobject modules are enabled, we will load them
          -- once nvim-treesitter is loaded
          require('lazy.core.loader').disable_rtp_plugin('nvim-treesitter-textobjects')
          load_textobjects = true
        end,
      },
    },
    cmd = { 'TSUpdateSync' },
    keys = {
      { '<c-space>', desc = 'Increment selection' },
      { '<bs>', desc = 'Schrink selection', mode = 'x' },
    },
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = false },
      context_commentstring = { enable = true, enable_autocmd = false },
      auto_install = true,
      ensure_installed = {
        'astro',
        'bash',
        'go',
        'dockerfile',
        'html',
        'java',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'query',
        'regex',
        'rust',
        'rust',
        'terraform',
        'typescript',
        'vim',
        'vimdoc',
        'vue',
        'yaml',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = '<nop>',
          node_decremental = '<bs>',
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
