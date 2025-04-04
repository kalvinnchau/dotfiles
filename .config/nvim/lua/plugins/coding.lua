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

  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },

    -- use a release tag to download pre-built binaries
    version = '*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        preset = 'enter',
        ['<C-d>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },

        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
      },

      cmdline = {
        -- on enter accept and feed a newline
        keymap = {
          ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        menu = {
          border = 'single',
          draw = {
            align_to = 'cursor',
            padding = 1,
            gap = 1,
            columns = { { 'source_name' }, { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
            components = {
              source_name = {
                width = { max = 6 },
                text = function(ctx)
                  local name = ctx.source_name:lower()
                  local renames = {
                    cmdline = 'cmd',
                    snippets = 'snip',
                    buffer = 'buf',
                  }
                  local final = renames[name] or name
                  return '[' .. final .. ']'
                end,
                highlight = 'BlinkCmpSource',
              },
              label = {
                width = { fill = true, max = 40 },
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          window = {
            border = 'single',
          },
        },
      },

      signature = {
        enabled = true,
        window = {
          border = 'single',
        },
      },

      snippets = { preset = 'luasnip' },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        min_keyword_length = function(ctx)
          -- only applies when typing a command, doesn't apply to arguments
          if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then
            return 3
          end
          return 0
        end,
      },
    },
    opts_extend = { 'sources.default' },
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
