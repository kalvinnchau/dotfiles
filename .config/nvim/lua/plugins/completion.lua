return {
  -- snippets
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
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

  -- lsp kind icons
  {
    'onsails/lspkind-nvim',
    lazy = true,
    opts = {
      mode = 'text_symbol',
      preset = 'default',
    },
  },

  -- completion engine
  {
    'saghen/blink.cmp',
    version = '*',
    dependencies = { 'L3MON4D3/LuaSnip' },
    event = 'InsertEnter',
    opts = {
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
        keymap = {
          ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      completion = {
        menu = {
          border = 'single',
          draw = {
            align_to = 'cursor',
            padding = 1,
            gap = 1,
            columns = {
              { 'source_name' },
              { 'kind_icon' },
              { 'label', 'label_description', gap = 1 },
            },
            components = {
              source_name = {
                width = { max = 6 },
                text = function(ctx)
                  local renames = {
                    cmdline = 'cmd',
                    snippets = 'snip',
                    buffer = 'buf',
                  }
                  local name = ctx.source_name:lower()
                  return '[' .. (renames[name] or name) .. ']'
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
          window = { border = 'single' },
        },
      },
      signature = {
        enabled = true,
        window = { border = 'single' },
      },
      snippets = { preset = 'luasnip' },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        min_keyword_length = function(ctx)
          if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then
            return 3
          end
          return 0
        end,
      },
    },
    opts_extend = { 'sources.default' },
  },
}
