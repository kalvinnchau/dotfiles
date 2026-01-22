return {
  -- snippets
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    event = 'InsertEnter',
    dependencies = { 'rafamadriz/friendly-snippets' },
    opts = {
      history = true,
    },
    config = function(_, opts)
      local ls = require('luasnip')
      ls.setup(opts)

      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_lua').lazy_load()

      -- LuaSnip jump keys - these need to close completion menu first
      vim.keymap.set({ 'i', 's' }, '<C-n>', function()
        if ls.expand_or_jumpable() then
          -- Close blink.cmp menu if open
          local ok, cmp = pcall(require, 'blink.cmp')
          if ok and cmp.is_visible() then
            cmp.hide()
          end
          ls.expand_or_jump()
        else
          -- Fallback to default C-n (completion)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, false, true), 'n', false)
        end
      end, { silent = true })

      vim.keymap.set({ 'i', 's' }, '<C-p>', function()
        if ls.jumpable(-1) then
          local ok, cmp = pcall(require, 'blink.cmp')
          if ok and cmp.is_visible() then
            cmp.hide()
          end
          ls.jump(-1)
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, false, true), 'n', false)
        end
      end, { silent = true })
    end,
  },

  -- completion engine
  {
    'saghen/blink.cmp',
    version = '*',
    dependencies = { 'L3MON4D3/LuaSnip' },
    event = 'InsertEnter',
    opts = {
      keymap = {
        preset = 'default',
        ['<C-d>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-k>'] = { 'scroll_signature_up', 'fallback' },
        ['<C-j>'] = { 'scroll_signature_down', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
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
        ghost_text = { enabled = true },
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
