return {
  -- lsp config
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'saghen/blink.cmp' },
      { 'williamboman/mason.nvim' },
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
        ty = {},
        ruff = {},
        yamlls = {},
        -- kotlin: managed by plugins/lang/kotlin.lua (kotlin.nvim)
      },
    },
    config = function(_, opts)
      -- diagnostics config with signs
      vim.diagnostic.config(vim.tbl_deep_extend('force', opts.diagnostics, {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = 'E',
            [vim.diagnostic.severity.WARN] = 'W',
            [vim.diagnostic.severity.HINT] = 'H',
            [vim.diagnostic.severity.INFO] = 'I',
          },
        },
      }))

      -- LspAttach autocmd for keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
        callback = function(event)
          local function map(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'lsp: ' .. desc })
          end

          map('gd', function()
            Snacks.picker.lsp_definitions()
          end, 'go to definition')
          map('gi', function()
            Snacks.picker.lsp_implementations()
          end, 'show implementations')

          -- override neovim 0.11 gr* defaults with snacks.picker
          map('grr', function()
            Snacks.picker.lsp_references()
          end, 'references')
          map('gri', function()
            Snacks.picker.lsp_implementations()
          end, 'implementations')
          map('gO', function()
            Snacks.picker.lsp_symbols()
          end, 'document symbols')
          map('gsd', function()
            Snacks.picker.lsp_definitions({ confirm = { 'edit_split' } })
          end, 'go to def (split)')
          map('gsv', function()
            Snacks.picker.lsp_definitions({ confirm = { 'edit_vsplit' } })
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
            Snacks.picker.diagnostics({ filter = { buf = 0 } })
          end, 'buffer diagnostics')
          map('<leader>dw', function()
            Snacks.picker.diagnostics()
          end, 'workspace diagnostics')
          map('<leader>dn', function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, 'next diagnostic')
          map('<leader>dp', function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, 'prev diagnostic')

          -- show diagnostics on cursor hold
          local diagnostic_opts = {
            focusable = false,
            close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
            border = 'single',
            source = 'always',
            prefix = ' ',
          }

          vim.api.nvim_create_autocmd('CursorHold', {
            buffer = event.buf,
            callback = function()
              vim.diagnostic.open_float(nil, diagnostic_opts)
            end,
          })
        end,
      })

      -- setup servers
      local base_capabilities = vim.lsp.protocol.make_client_capabilities()
      local blink_capabilities = require('blink.cmp').get_lsp_capabilities()

      for server, server_opts in pairs(opts.servers) do
        -- merge capabilities into server opts
        server_opts.capabilities =
          vim.tbl_deep_extend('force', base_capabilities, blink_capabilities, server_opts.capabilities or {})

        -- get existing defaults and deep merge to preserve filetypes, cmd, root_markers
        local defaults = vim.lsp.config[server] or {}
        local merged = vim.tbl_deep_extend('force', defaults, server_opts)
        vim.lsp.config(server, merged)

        vim.lsp.enable(server)
      end
    end,
  },

  -- lazydev.nvim
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- conform.nvim
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>tf',
        function()
          vim.g.autoformat = not vim.g.autoformat
          local level = vim.g.autoformat and vim.log.levels.INFO or vim.log.levels.WARN
          local status = vim.g.autoformat and 'Enabled' or 'Disabled'
          vim.notify(status .. ' format on save', level)
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

  -- nvim-lint
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

  -- mason - package manager
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
