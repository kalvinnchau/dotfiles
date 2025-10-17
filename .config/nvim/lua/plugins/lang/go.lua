return {
  -- gopls config
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        gopls = {
          cmd = { 'gopls', '-v', '-rpc.trace', '-logfile=/tmp/gopls.log' },
          settings = {
            gopls = {
              buildFlags = { '-tags=unit' },
              directoryFilters = {
                '-build',
                '-bazel-bin',
                '-bazel-out',
                '-bazel-testlogs',
              },
              analyses = {
                unusedParams = true,
                ST1003 = false,
              },
              staticcheck = true,
              usePlaceholders = true,
              experimentalPostfixCompletions = true,
            },
          },
        },
      },
    },
  },

  -- go formatting with goimports
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        go = { 'goimports', 'gofmt' },
      },
    },
  },
}
