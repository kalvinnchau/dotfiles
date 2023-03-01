return {
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
              --hints = {
              --  assignVariableTypes = true,
              --  compositeLiteralFields = true,
              --  compositeLiteralTypes = true,
              --  constantValues = true,
              --  functionTypeParameters = true,
              --  parameterNames = true,
              --  rangeVariableTypes = true,
              --},
              staticcheck = true,
              usePlaceholders = true,
              experimentalPostfixCompletions = true,
            },
          },
        },
      },
      setup = {
        gopls = function(_, _)
          require('plugins.lsp.format').lsp_custom_format['gopls'] = function(buffer)
            local params = vim.lsp.util.make_range_params()
            params.context = { only = { 'source.organizeImports' } }
            local method = 'textDocument/codeAction'
            local result = vim.lsp.buf_request_sync(buffer, method, params, 10000)
            for _, res in pairs(result or {}) do
              for _, r in pairs(res.result or {}) do
                if r.edit then
                  vim.lsp.util.apply_workspace_edit(r.edit, 'utf-8')
                else
                  vim.lsp.buf.execute_command(r.command)
                end
              end
            end

            vim.lsp.buf.format()
          end

          -- still call lspconfig.gopls.setup
          return false
        end,
      },
    },
  },
}
