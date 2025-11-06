return {
  -- python lsp config
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {},
    },
  },

  -- python formatting with ruff
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        python = { 'ruff_format', 'ruff_organize_imports' },
      },
    },
  },

  -- python linting with ruff
  {
    'mfussenegger/nvim-lint',
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.python = { 'ruff' }
      return opts
    end,
  },
}
