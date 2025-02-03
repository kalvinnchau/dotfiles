return {
  -- snippets
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = 'TextChanged',
    },
  },

  {
    'onsails/lspkind-nvim',
    lazy = true,
    opts = {
      mode = 'text_symbol',
      preset = 'default',
    },
    config = function(_, opts)
      require('lspkind').init(opts)
    end,
  },

  -- auto completeion
  --{
  --  'hrsh7th/nvim-cmp',
  --  version = false, -- last release is way too old
  --  event = 'InsertEnter',
  --  dependencies = {
  --    'hrsh7th/cmp-nvim-lsp',
  --    'hrsh7th/cmp-buffer',
  --    'hrsh7th/cmp-path',
  --    'hrsh7th/cmp-nvim-lua',
  --    'saadparwaiz1/cmp_luasnip',
  --    'onsails/lspkind-nvim',
  --  },
  --  opts = function()
  --    -- configure nvim-cmp
  --    local cmp = require('cmp')
  --    local luasnip = require('luasnip')

  --    local has_words_before = function()
  --      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  --      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  --    end

  --    return {
  --      snippet = {
  --        expand = function(args)
  --          luasnip.lsp_expand(args.body)
  --        end,
  --      },
  --      mapping = cmp.mapping.preset.insert({
  --        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  --        ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --        ['<C-Space>'] = cmp.mapping.complete(),
  --        ['<C-e>'] = cmp.mapping.close(),
  --        ['<CR>'] = cmp.mapping.confirm({ select = false }),
  --        ['<Tab>'] = cmp.mapping(function(fallback)
  --          if cmp.visible() then
  --            cmp.select_next_item()
  --          elseif luasnip.expand_or_jumpable() then
  --            luasnip.expand_or_jump()
  --          elseif has_words_before() then
  --            cmp.complete()
  --          else
  --            fallback()
  --          end
  --        end, {
  --          'i',
  --          's',
  --        }),
  --        ['<S-Tab>'] = cmp.mapping(function(fallback)
  --          if cmp.visible() then
  --            cmp.select_prev_item()
  --          elseif luasnip.jumpable(-1) then
  --            luasnip.jump(-1)
  --          else
  --            fallback()
  --          end
  --        end, {
  --          'i',
  --          's',
  --        }),
  --      }),
  --      sources = {
  --        { name = 'nvim_lsp' },
  --        { name = 'luasnip' },
  --        { name = 'buffer' },
  --        { name = 'path' },
  --      },
  --      formatting = {
  --        format = require('lspkind').cmp_format({
  --          mode = 'text_symbol',
  --          menu = {
  --            buffer = '[buffer]',
  --            nvim_lsp = '[lsp]',
  --            luasnip = '[luaSnip]',
  --            nvim_lua = '[lua]',
  --            path = '[path]',
  --          },
  --        }),
  --      },
  --    }
  --  end,
  --},
  {
    -- perf focused fork of nvim-cmp
    'iguanacucumber/magazine.nvim',
    name = 'nvim-cmp',
    version = false, -- last release is way too old
    event = 'InsertEnter',
    dependencies = {
      { 'iguanacucumber/mag-nvim-lsp', name = 'cmp-nvim-lsp', opts = {} },
      { 'iguanacucumber/mag-nvim-lua', name = 'cmp-nvim-lua' },
      { 'iguanacucumber/mag-buffer', name = 'cmp-buffer' },
      { 'iguanacucumber/mag-cmdline', name = 'cmp-cmdline' },
      'https://codeberg.org/FelipeLema/cmp-async-path',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind-nvim',
    },
    opts = function()
      -- configure nvim-cmp
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local compare = require('cmp.config.compare')

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'async_path' },
        }, {
          { name = 'cmdline' },
        }),
        matching = {
          disallow_fullfuzzy_matching = false,
          disallow_fuzzy_matching = false,
          disallow_partial_fuzzy_matching = true,
          disallow_partial_matching = false,
          disallow_prefix_unmatching = false,
          disallow_symbol_nonprefix_matching = false,
        },
      })

      return {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, {
            'i',
            's',
          }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {
            'i',
            's',
          }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'async_path' },
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.offset,
            compare.exact,
            -- compare.scopes,
            compare.score,
            compare.recently_used,
            compare.locality,
            compare.kind,
            -- compare.sort_text,
            compare.length,
            compare.order,
          },
        },
        formatting = {
          format = require('lspkind').cmp_format({
            mode = 'text_symbol',
            menu = {
              buffer = '[buf]',
              nvim_lsp = '[lsp]',
              luasnip = '[luaSnip]',
              nvim_lua = '[lua]',
              path = '[path]',
            },
          }),
        },
      }
    end,
  },

  -- surround
  {
    'echasnovski/mini.surround',
    keys = { 'gz' },
    opts = {
      mappings = {
        add = 'gza', -- Add surrounding in Normal and Visual modes
        delete = 'gzd', -- Delete surrounding
        find = 'gzf', -- Find surrounding (to the right)
        find_left = 'gzF', -- Find surrounding (to the left)
        highlight = 'gzh', -- Highlight surrounding
        replace = 'gzr', -- Replace surrounding
        update_n_lines = 'gzn', -- Update `n_lines`
      },
      silent = false,
    },
    config = function(_, opts)
      -- use gz mappings instead of s to prevent conflict with leap
      require('mini.surround').setup(opts)
    end,
  },

  -- nvim-dap
  {
    'mfussenegger/nvim-dap',
    keys = {
      {
        '<leader>bb',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'toggle breakpoint',
      },
      {
        '<leader>bn',
        function()
          require('dap').continue()
        end,
        desc = 'continue application',
      },
      {
        '<leader>bl',
        function()
          require('dap').step_over()
        end,
        desc = 'step over',
      },
      {
        '<leader>bj',
        function()
          require('dap').step_into()
        end,
        desc = 'step into',
      },
      {
        '<leader>bk',
        function()
          require('dap').step_out()
        end,
        desc = 'step out',
      },
      {
        '<leader>bh',
        function()
          require('dap').step_back()
        end,
        desc = 'step back',
      },
    },
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    opts = {},
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    opts = {
      layouts = {
        {
          elements = {
            {
              id = 'scopes',
              size = 0.50,
            },
            {
              id = 'stacks',
              size = 0.25,
            },
            {
              id = 'breakpoints',
              size = 0.25,
            },
            --{
            --  id = 'watches',
            --  size = 0.25,
            --},
          },
          position = 'left',
          size = 50,
        },
        {
          elements = {
            {
              id = 'repl',
              size = 0.5,
            },
            {
              id = 'console',
              size = 0.5,
            },
          },
          position = 'bottom',
          size = 10,
        },
      },
    },
    keys = {
      {
        '<leader>du',
        function()
          require('dapui').toggle()
        end,
        desc = 'open DAP UI',
      },
      {
        '<leader>df',
        function()
          require('dapui').float_element('scopes')
        end,
        desc = 'open DAP scops in a floating window',
      },
    },
  },
}
