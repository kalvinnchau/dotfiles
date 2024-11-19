return {
  -- lspconfig
  {
    'neovim/nvim-lspconfig',
    branch = 'master',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      {
        'folke/neoconf.nvim',
        cmd = 'Neoconf',
        opts = {
          import = { vscode = false },
        },
        config = true,
      },
      { 'folke/neodev.nvim', opts = { experimental = { pathStrict = true } } },
      'williamboman/mason.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        signs = true,
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        --virtual_text = { spacing = 4, prefix = '●' },
        severity_sort = true,
      },
      -- Automatically format on save
      autoformat = true,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overriden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        bashls = {},
        metals = {},
        ts_ls = {},
        vuels = {},
        rust_analyzer = {},
        terraformls = {},
        lemminx = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        ruff = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be  lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      --setup = {
      --  -- example to setup with typescript.nvim
      --  -- tsserver = function(_, opts)
      --  --   require("typescript").setup({ server = opts })
      --  --   return true
      --  -- end,
      --  -- Specify * to use this function as a fallback for any server
      --  -- ["*"] = function(server, opts) end,
      --},
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      local init_lsp_on_attach_group = vim.api.nvim_create_augroup('init_lsp_on_attach_group', {})
      function show_line_diagnostics()
        local opts = {
          focusable = false,
          close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
          border = 'single',
          source = 'always', -- show source in diagnostic popup window
          prefix = ' ',
        }
        vim.diagnostic.open_float(nil, opts)
      end

      -- setup autoformat
      require('plugins.lsp.format').autoformat = opts.autoformat
      -- setup formatting and keymaps
      require('config.util').on_attach(function(client, buffer)
        require('plugins.lsp.format').on_attach(client, buffer)
        require('plugins.lsp.keymaps').on_attach(client, buffer)
        vim.api.nvim_clear_autocmds({ group = init_lsp_on_attach_group, buffer = bufnr })
        vim.api.nvim_create_autocmd('CursorHold', {
          desc = 'show diagnostics when the cursor is over an error',
          group = init_lsp_on_attach_group,
          buffer = bufnr,
          callback = function()
            show_line_diagnostics()
          end,
        })
      end)

      -- diagnostics
      for name, icon in pairs(require('config.icons').diagnostics) do
        name = 'DiagnosticSign' .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
      end
      vim.diagnostic.config(opts.diagnostics)

      local servers = opts.servers
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local function setup(server)
        local server_opts = servers[server] or {}
        server_opts.capabilities = capabilities
        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup['*'] then
          if opts.setup['*'](server, server_opts) then
            return
          end
        end
        require('lspconfig')[server].setup(server_opts)
      end

      --local mlsp = require('mason-lspconfig')
      --local available = mlsp.get_available_servers()

      for server, server_opts in pairs(servers) do
        setup(server)
      end

      --require('mason-lspconfig').setup({ ensure_installed = ensure_installed })
      --require('mason-lspconfig').setup_handlers({ setup })
    end,
  },

  -- formatters
  {
    'nvimtools/none-ls.nvim',
    event = 'BufReadPre',
    dependencies = {
      'williamboman/mason.nvim',
    },
    opts = function()
      local nls = require('null-ls')
      return {
        sources = {
          nls.builtins.formatting.stylua.with({
            extra_args = { '--config-path', vim.fn.expand('~/.config/stylua/stylua.toml') },
          }),

          --nls.builtins.formatting.clang_format.with({
          --  filetypes = { 'c', 'cpp', 'proto' },
          --}),
          --nls.builtins.formatting.cmake_format,

          nls.builtins.formatting.prettier.with({
            extra_args = { '--ignore-path', vim.fn.expand('~/.prettierignore') },
          }),

          nls.builtins.formatting.terraform_fmt,

          --nls.builtins.formatting.ruff,
          --nls.builtins.formatting.black,

          nls.builtins.formatting.buildifier,
          nls.builtins.diagnostics.buildifier,

          nls.builtins.diagnostics.vale,
        },
      }
    end,
  },

  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
    build = ':MasonUpdate',
    opts = {
      ensure_installed = {
        -- python
        'ruff',
        'ruff-lsp',
        --'python-lsp-server',
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
        -- java,
        'lemminx', -- xml
        -- others
        'bash-language-server',
        'buildifier',
        'commitlint',
        'terraform-ls',
        'vale',
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
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
