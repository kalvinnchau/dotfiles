return {
  -- lsp config
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'folke/neoconf.nvim', cmd = 'Neoconf', opts = { import = { vscode = false } } },
      { 'saghen/blink.cmp' },
    },
    opts = {
      diagnostics = {
        signs = true,
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        severity_sort = true,
      },
      servers = {
        bashls = {},
        metals = {},
        ts_ls = {},
        biome = {},
        terraformls = {},
        lemminx = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = { callSnippet = 'Replace' },
            },
          },
        },
        ruff = {},
        yamlls = {},
      },
    },
    config = function(_, opts)
      -- diagnostics config
      vim.diagnostic.config(opts.diagnostics)

      -- diagnostic signs
      local signs = { Error = '', Warn = '', Hint = '', Info = '' }
      for name, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. name
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
      end

      -- MODERN: LspAttach autocmd for keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'lsp: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, 'go to definition')
          map('gi', require('telescope.builtin').lsp_implementations, 'show implementations')
          map('gr', require('telescope.builtin').lsp_references, 'show references')
          map('gsd', function()
            require('telescope.builtin').lsp_definitions({ jump_type = 'split' })
          end, 'go to def (split)')
          map('gsv', function()
            require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit' })
          end, 'go to def (vsplit)')
          map('K', function()
            if vim.bo.filetype == 'rust' then
              vim.cmd.RustLsp({ 'hover', 'actions' })
            else
              vim.lsp.buf.hover({ border = 'single' })
            end
          end, 'hover')
          map('<c-k>', vim.lsp.buf.signature_help, 'signature help')
          map('ca', vim.lsp.buf.code_action, 'code action')
          map('<space>rn', vim.lsp.buf.rename, 'rename')
          map('ff', function()
            require('conform').format({ async = true, lsp_format = 'fallback' })
            require('mini.trailspace').trim()
          end, 'format')

          -- diagnostics
          map('<leader>da', function()
            require('telescope.builtin').diagnostics({ bufnr = 0 })
          end, 'buffer diagnostics')
          map('<leader>dw', function()
            require('telescope.builtin').diagnostics()
          end, 'workspace diagnostics')
          map('<leader>dn', function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, 'next diagnostic')
          map('<leader>dp', function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, 'prev diagnostic')

          -- show diagnostics on cursor hold
          vim.api.nvim_create_autocmd('CursorHold', {
            buffer = event.buf,
            callback = function()
              local opts = {
                focusable = false,
                close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
                border = 'single',
                source = 'always',
                prefix = ' ',
              }
              vim.diagnostic.open_float(nil, opts)
            end,
          })
        end,
      })

      -- setup servers
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      for server, server_opts in pairs(opts.servers) do
        -- Merge capabilities into server opts
        server_opts.capabilities = vim.tbl_deep_extend(
          'force',
          vim.lsp.protocol.make_client_capabilities(),
          capabilities,
          server_opts.capabilities or {}
        )

        -- Only call vim.lsp.config if we have custom settings
        if next(server_opts) ~= nil then
          vim.lsp.config(server, server_opts)
        end

        vim.lsp.enable(server)
      end
    end,
  },

  -- MODERN: lazydev.nvim (replaces neodev.nvim)
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- MODERN: conform.nvim (replaces none-ls.nvim for formatting)
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>tf',
        function()
          if vim.g.autoformat then
            vim.g.autoformat = false
            vim.notify('Disabled format on save', vim.log.levels.WARN)
          else
            vim.g.autoformat = true
            vim.notify('Enabled format on save', vim.log.levels.INFO)
          end
        end,
        desc = 'toggle format on save',
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'biome' },
        typescript = { 'biome' },
        javascriptreact = { 'biome' },
        typescriptreact = { 'biome' },
        json = { 'biome' },
        jsonc = { 'biome' },
        css = { 'biome' },
        graphql = { 'biome' },
        terraform = { 'terraform_fmt' },
        bzl = { 'buildifier' },
      },
      format_on_save = function()
        if vim.g.autoformat == false then
          return
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      formatters = {
        stylua = {
          prepend_args = { '--config-path', vim.fn.expand('~/.config/stylua/stylua.toml') },
        },
      },
    },
    init = function()
      vim.g.autoformat = true
    end,
  },

  -- MODERN: nvim-lint (replaces none-ls.nvim for linting)
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        bzl = { 'buildifier' },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('nvim_lint', { clear = true }),
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },

  -- mason
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    build = ':MasonUpdate',
    keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'mason' } },
    opts = {
      registries = {
        'github:mason-org/mason-registry',
        'github:mistweaverco/zana-registry',
      },
      ensure_installed = {
        -- python
        'ruff',
        'debugpy',
        'pyright',
        -- golang
        'gopls',
        'delve',
        'gomodifytags',
        'goimports',
        -- lua
        'lua-language-server',
        'stylua',
        -- sh
        'shellcheck',
        'shellharden',
        -- typescript/javascript
        'typescript-language-server',
        'prettier',
        -- java
        'lemminx',
        -- others
        'bash-language-server',
        'buildifier',
        'commitlint',
        'terraform-ls',
        'vale',
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require('mason-registry')
      mr:on('package:install:success', function()
        vim.defer_fn(function()
          require('lazy.core.handler.event').trigger({
            event = 'FileType',
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}
