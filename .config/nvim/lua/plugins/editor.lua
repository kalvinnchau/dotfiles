return {

  -- file explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    cmd = 'Neotree',
    keys = {
      {
        '<leader>fe',
        function()
          require('neo-tree.command').execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = 'Neotree Files (cwd)',
      },
      {
        '<leader>fB',
        function()
          require('neo-tree.command').execute({ toggle = true, source = 'buffers' })
        end,
        desc = 'Neotree Buffers (cwd)',
      },
      {
        '<leader>fG',
        function()
          require('neo-tree.command').execute({ toggle = true, source = 'git_status' })
        end,
        desc = 'Neotree Git Status (cwd)',
      },
      { '<leader>e', '<leader>fe', desc = 'Neotree Files (cwd)', remap = true },
      { '<leader>tree', '<leader>fe', desc = 'Neotree Files (cwd)', remap = true },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require('neo-tree')
        end
      end
    end,
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = {
          enabled = true,
        },
      },
      window = {
        mappings = {
          ['<space>'] = 'none',
          ['<C-v>'] = 'open_vsplit',
          ['<C-x>'] = 'open_split',
          ['<C-t>'] = 'open_tabnew',
        },
      },
    },
  },

  -- fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    version = false, -- telescope did only one release, so use HEAD for now
    keys = {
      { '<leader>fg', [[<cmd>lua require('telescope.builtin').live_grep{}<CR>]], desc = 'grep files in cwd' },
      { '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files{}<CR>]], desc = 'pick any files in cwd' },
      { '<leader>ft', [[<cmd>lua require('telescope.builtin').git_files{}<CR>]], desc = 'pick git files in cwd' },
      {
        '<leader>fb',
        [[<cmd>lua require('telescope.builtin').buffers{show_all_buffers=true}<CR>]],
        desc = 'pick from all buffers',
      },
      { '<leader>fv', [[<cmd>lua require('telescope.builtin').commands{}<CR>]], desc = 'pick any vim command' },
      { '<leader>fc', [[<cmd>lua require('telescope.builtin').git_commits{}<CR>]], desc = 'pick from git commits' },
      { '<leader>fk', [[<cmd>lua require('telescope.builtin').keymaps{}<CR>]], desc = 'pick any keymap' },
      { '<leader>fr', [[<cmd>lua require('telescope.builtin').oldfiles{}<CR>]], desc = 'pick recently opened files' },
      { '<leader>fs', [[<cmd>lua require('telescope.builtin').search_history{}<CR>]], desc = 'pick recent searches' },
    },
    opts = {
      defaults = {
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
        },
        mappings = {
          i = {
            ['<C-j>'] = function(...)
              require('telescope.actions').move_selection_next(...)
            end,
            ['<C-k>'] = function(...)
              require('telescope.actions').move_selection_previous(...)
            end,
            ['<CR>'] = function(...)
              require('telescope.actions').select_default(...)
              require('telescope.actions').center(...)
            end,
            ['<C-x>'] = function(...)
              require('telescope.actions').select_horizontal(...)
            end,
            ['<C-v>'] = function(...)
              require('telescope.actions').select_vertical(...)
            end,
            ['<C-t>'] = function(...)
              require('telescope.actions').select_tab(...)
            end,
          },
        },
      },
      pickers = {
        git_commits = {
          mappings = {
            i = {
              -- Open selected commit in diffview
              ['<C-d>'] = function()
                local selected_entry = require('telescope.actions.state').get_selected_entry()
                local value = selected_entry.value
                -- close Telescope window properly prior to switching windows
                vim.api.nvim_win_close(0, true)
                vim.cmd('stopinsert')
                vim.schedule(function()
                  vim.cmd(('DiffviewOpen %s^!'):format(value))
                end)
              end,
            },
          },
        },
      },
    },
  },

  -- which-key
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      plugins = { spelling = true },
      key_labels = { ['<leader>'] = 'SPC' },
    },
    config = function(_, opts)
      local wk = require('which-key')
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      wk.setup(opts)
      wk.register({
        mode = { 'n', 'v' },
        ['g'] = { name = '+goto' },
        [']'] = { name = '+next' },
        ['['] = { name = '+prev' },
        ['<leader><tab>'] = { name = '+tabs' },
        ['<leader>b'] = { name = '+buffer' },
        ['<leader>c'] = { name = '+code' },
        ['<leader>f'] = { name = '+file/find' },
        ['<leader>g'] = { name = '+git' },
        ['<leader>gh'] = { name = '+hunks' },
        ['<leader>q'] = { name = '+quit/session' },
        ['<leader>s'] = { name = '+search' },
        ['<leader>u'] = { name = '+ui' },
        ['<leader>w'] = { name = '+windows' },
        ['<leader>x'] = { name = '+diagnostics/quickfix' },
        ['<leader>d'] = { name = '+diagnostics' },
        f = {
          d = {
            -- diff the current buffer against what's on the disk, useful before writing
            function()
              -- Get start buffer
              local start = vim.api.nvim_get_current_buf()

              -- `vnew` - Create empty vertical split window
              -- `set buftype=nofile` - Buffer is not related to a file, will not be written
              -- `0d_` - Remove an extra empty start row
              -- `diffthis` - Set diff mode to a new vertical split
              vim.cmd('vnew | set buftype=nofile | read ++edit # | 0d_ | diffthis')

              -- Get scratch buffer
              local scratch = vim.api.nvim_get_current_buf()

              -- `wincmd p` - Go to the start window
              -- `diffthis` - Set diff mode to a start window
              vim.cmd('wincmd p | diffthis')

              -- Map `q` for both buffers to exit diff view and delete scratch buffer
              for _, buf in ipairs({ scratch, start }) do
                vim.keymap.set('n', 'q', function()
                  vim.api.nvim_buf_delete(scratch, { force = true })
                  vim.keymap.del('n', 'q', { buffer = start })
                end, { buffer = buf })
              end
            end,
            'diff buffer against disk',
          },
        },
      })
    end,
  },

  -- diff views
  {
    'sindrets/diffview.nvim',
    opts = {},
    keys = {
      {
        '<leader>dh',
        '<cmd>DiffviewOpen<cr>',
        desc = 'diff against HEAD',
      },
    },
  },

  -- git signs
  {
    'lewis6991/gitsigns.nvim',
    branch = 'main',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      current_line_blame = false,
      current_line_blame_opts = { virt_text = true, virt_text_pos = 'eol' },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map("n", "<leader>gn", gs.next_hunk, "Next Hunk")
        map("n", "<leader>gp", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- references
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = { delay = 200 },
    config = function(_, opts)
      require('illuminate').configure(opts)
    end,
    -- stylua: ignore
    keys = {
      {
        ']]',
        function()
          require('illuminate').goto_next_reference(false)
        end,
        desc = 'Next Reference',
      },
      {
        '[[',
        function()
          require('illuminate').goto_prev_reference(false)
        end,
        desc = 'Prev Reference',
      },
    },
  },

  -- better diagnostics list and others
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = { use_diagnostic_signs = true },
    keys = {
      { '<leader>xx', '<cmd>TroubleToggle document_diagnostics<cr>', desc = 'Document Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace Diagnostics (Trouble)' },
      { '<leader>xL', '<cmd>TroubleToggle loclist<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>TroubleToggle quickfix<cr>', desc = 'Quickfix List (Trouble)' },
    },
  },

  -- todo comments
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = true,
    -- stylua: ignore
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        desc = 'Next todo comment',
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        desc = 'Previous todo comment',
      },
      { '<leader>xt', '<cmd>TodoTrouble<cr>', desc = 'Todo Trouble' },
      --{ '<leader>xtt', '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>', desc = 'Todo Trouble' },
      { '<leader>xT', '<cmd>TodoTelescope<cr>', desc = 'Todo Telescope' },
    },
  },
}
