return {
  -- markdown table of contents generator
  {
    'hedyhli/markdown-toc.nvim',
    ft = 'markdown',
    cmd = { 'Mtoc' },
    keys = {
      { '<leader>mtoc', '<cmd>Mtoc<cr>', desc = 'Generate markdown table of contents' },
    },
    opts = {},
  },

  -- markdown preview
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    cmd = { 'MarkdownPreview', 'MarkdownPreviewToggle', 'MarkdownPreviewStop' },
    build = ':call mkdp#util#install()',
  },

  -- paste images from clipboard
  {
    'mattdibi/incolla.nvim',
    ft = 'markdown',
    keys = {
      {
        '<leader>fp',
        function()
          require('incolla').incolla()
        end,
        desc = 'paste image as markdown uri',
      },
    },
    opts = {
      defaults = {
        img_dir = 'images',
        img_name = function()
          return os.date('%Y-%m-%d-%H-%M-%S')
        end,
        affix = '%s',
      },
      markdown = {
        affix = '![](%s)',
      },
    },
  },

  -- todo management in markdown
  {
    'bngarren/checkmate.nvim',
    ft = 'markdown',
    dependencies = { 'L3MON4D3/LuaSnip' },
    opts = {
      files = { '**/todo.md', '**/TODO.md', '**/*-todo.md', '**/global-todo.md' },

      todo_states = {
        unchecked = {
          marker = '○',
          order = 1,
          style = { fg = '#928374' },
        },
        in_progress = {
          marker = '◐',
          markdown = '-',
          order = 2,
          style = { fg = '#fabd2f' },
        },
        urgent = {
          marker = '◈',
          markdown = '!',
          order = 3,
          style = { fg = '#fb4934', bold = true },
        },
        checked = {
          marker = '●',
          order = 4,
          style = { fg = '#928374', strikethrough = true },
        },
      },

      metadata = {
        priority = {
          choices = { 'high', 'medium', 'low' },
        },
        started = {
          get_value = function()
            return os.date('%Y-%m-%d %H:%M')
          end,
        },
        done = {
          get_value = function()
            return os.date('%Y-%m-%d %H:%M')
          end,
        },
        due = {
          get_value = function()
            return os.date('%Y-%m-%d', os.time() + 86400) -- tomorrow
          end,
          choices = { 'today', 'tomorrow', 'this week', 'next week' },
        },
      },

      smart_toggle = {
        check_down = 'direct_children',
        check_up = 'direct_children',
      },

      list_continuation = { enabled = true },
    },
    config = function(_, opts)
      require('checkmate').setup(opts)

      local ls = require('luasnip')
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node

      local function timestamp()
        return os.date('%Y-%m-%d %H:%M')
      end

      ls.add_snippets('markdown', {
        s('.td', {
          t('- [ ] '),
          i(1, 'task'),
        }),
        s('.bug', {
          t('- [ ] BUG: '),
          i(1, 'description'),
          t(' @started('),
          f(timestamp, {}),
          t(')'),
        }),
        s('.feat', {
          t('- [ ] FEAT: '),
          i(1, 'feature'),
        }),
      })
    end,
    keys = {
      {
        '<leader>tt',
        function()
          require('checkmate').toggle()
        end,
        ft = 'markdown',
        desc = 'Toggle todo state',
      },
      {
        '<leader>tc',
        function()
          require('checkmate').check()
        end,
        ft = 'markdown',
        desc = 'Mark as checked',
      },
      {
        '<leader>tu',
        function()
          require('checkmate').uncheck()
        end,
        ft = 'markdown',
        desc = 'Mark as unchecked',
      },
      {
        '<leader>tn',
        function()
          require('checkmate').create()
        end,
        ft = 'markdown',
        desc = 'Create new todo',
      },
      {
        '<leader>tj',
        function()
          require('checkmate').cycle()
        end,
        ft = 'markdown',
        desc = 'Cycle to next state',
      },
      {
        '<leader>tf',
        function()
          require('checkmate').select_todo()
        end,
        ft = 'markdown',
        desc = 'Find todos',
      },
      {
        '<leader>td',
        function()
          require('checkmate').add_metadata('done')
        end,
        ft = 'markdown',
        desc = 'Add @done metadata',
      },
      {
        '<leader>ts',
        function()
          require('checkmate').add_metadata('started')
        end,
        ft = 'markdown',
        desc = 'Add @started metadata',
      },
      {
        '<leader>tr',
        function()
          require('checkmate').add_metadata('priority')
        end,
        ft = 'markdown',
        desc = 'Add @priority metadata',
      },
      -- Quick exit snippet and add checkbox
      {
        '<C-]>',
        function()
          local ls = require('luasnip')
          if ls.in_snippet() then
            ls.unlink_current()
          end
          vim.schedule(function()
            require('checkmate').create()
          end)
        end,
        mode = { 'i', 's' },
        ft = 'markdown',
        desc = 'Exit snippet and add checkbox',
      },
    },
  },
}
