return {
  -- git signs
  {
    'lewis6991/gitsigns.nvim',
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
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map('n', ']h', gs.next_hunk, 'Next Hunk')
        map('n', '[h', gs.prev_hunk, 'Prev Hunk')
        map('n', '<leader>gn', gs.next_hunk, 'Next Hunk')
        map('n', '<leader>gp', gs.prev_hunk, 'Prev Hunk')
        map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
        map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
        map('n', '<leader>ghS', gs.stage_buffer, 'Stage Buffer')
        map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
        map('n', '<leader>ghR', gs.reset_buffer, 'Reset Buffer')
        map('n', '<leader>ghp', gs.preview_hunk, 'Preview Hunk')
        map('n', '<leader>ghb', function()
          gs.blame_line({ full = true })
        end, 'Blame Line')
        map('n', '<leader>ghd', gs.diffthis, 'Diff This')
        map('n', '<leader>ghD', function()
          gs.diffthis('~')
        end, 'Diff This ~')
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
      end,
    },
  },

  -- diff view
  --{
  --  'sindrets/diffview.nvim',
  --  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
  --  keys = {
  --    { '<leader>dh', '<cmd>DiffviewOpen<cr>', desc = 'Diff view (HEAD)' },
  --    { '<leader>dc', '<cmd>DiffviewClose<cr>', desc = 'Close diff view' },
  --  },
  --  opts = {
  --    enhanced_diff_hl = true,
  --    use_icons = true,
  --    view = {
  --      default = { layout = 'diff2_horizontal' },
  --    },
  --  },
  --  config = function(_, opts)
  --    require('diffview').setup(opts)

  --    local function set_diff_highlights()
  --      vim.api.nvim_set_hl(0, 'DiffAdd', { fg = 'none', bg = '#2e4b2e', bold = true })
  --      vim.api.nvim_set_hl(0, 'DiffDelete', { fg = 'none', bg = '#4c1e15', bold = true })
  --      vim.api.nvim_set_hl(0, 'DiffChange', { fg = 'none', bg = '#45565c', bold = true })
  --      vim.api.nvim_set_hl(0, 'DiffText', { fg = 'none', bg = '#635417', bold = true })
  --    end

  --    set_diff_highlights()
  --    vim.api.nvim_create_autocmd('ColorScheme', {
  --      group = vim.api.nvim_create_augroup('DiffColors', { clear = true }),
  --      callback = set_diff_highlights,
  --    })
  --  end,
  --},

  -- vscode-diff.nvim
  {
    'esmuellert/vscode-diff.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = { 'CodeDiff' },
    keys = {
      { '<leader>dfh', '<cmd>CodeDiff file HEAD<cr>', desc = 'Diff file against HEAD' },
      {
        '<leader>dfm',
        function()
          local base = vim.fn.trim(vim.fn.system('git merge-base origin/main HEAD'))
          vim.cmd.CodeDiff('file', base)
        end,
        desc = 'Diff file against merge-base',
      },
      { '<leader>dh', '<cmd>CodeDiff HEAD<cr>', desc = 'Open diff explorer against HEAD' },
      {
        '<leader>dm',
        function()
          local base = vim.fn.trim(vim.fn.system('git merge-base origin/main HEAD'))
          vim.cmd.CodeDiff(base)
        end,
        desc = 'Open diff explorer against merge-base',
      },
      { '<leader>gs', desc = 'Git search (buffer)' },
      { '<leader>gS', desc = 'Git search (global)' },
      { '<leader>gl', desc = 'Git log file' },
      { '<leader>gL', desc = 'Git log repo' },
    },
    config = function()
      require('codediff').setup({
        -- Highlight configuration
        highlights = {
          -- Line-level: accepts highlight group names or hex colors (e.g., "#2ea043")
          line_insert = '#2e4b2e', -- Line-level insertions
          line_delete = '#4c1e15', -- Line-level deletions

          -- Character-level: accepts highlight group names or hex colors
          -- If specified, these override char_brightness calculation
          char_insert = '#635417', -- Character-level insertions
          char_delete = '#635417', -- Character-level deletions

          -- Brightness multiplier (only used when char_insert/char_delete are nil)
          -- nil = auto-detect based on background (1.4 for dark, 0.92 for light)
          char_brightness = nil, -- Auto-adjust based on your colorscheme
        },

        -- Diff view behavior
        diff = {
          disable_inlay_hints = true, -- Disable inlay hints in diff windows for cleaner view
          max_computation_time_ms = 5000, -- Maximum time for diff computation (VSCode default)
        },

        -- Keymaps in diff view
        keymaps = {
          view = {
            next_hunk = '<leader><tab>', -- Jump to next change
            prev_hunk = '<leader><s-tab>', -- Jump to previous change
            next_file = ']f', -- Next file in explorer mode
            prev_file = '[f', -- Previous file in explorer mode
          },
          explorer = {
            select = '<CR>', -- Open diff for selected file
            hover = 'K', -- Show file diff preview
            refresh = 'R', -- Refresh git status
          },
        },
      })

      -- Snacks.picker integration: browse git history and open commits in CodeDiff
      local Snacks = require('snacks')

      local function walk_in_codediff(picker, item)
        picker:close()
        if item.commit then
          local current_commit = item.commit
          vim.fn.setreg('+', current_commit)
          vim.notify('Copied: ' .. current_commit)

          -- get parent commit
          local parent_commit = vim.trim(vim.fn.system('git rev-parse --short ' .. current_commit .. '^'))
          parent_commit = parent_commit:match('[a-f0-9]+')

          if vim.v.shell_error ~= 0 then
            vim.notify('Cannot find parent (Root commit?)', vim.log.levels.WARN)
            parent_commit = ''
          end

          local cmd = string.format('CodeDiff %s %s', parent_commit, current_commit)
          vim.notify('Diffing: ' .. parent_commit .. ' -> ' .. current_commit)
          vim.cmd(cmd)
        end
      end

      local function git_pickaxe(opts)
        opts = opts or {}
        local is_global = opts.global or false
        local current_file = vim.api.nvim_buf_get_name(0)

        if not is_global and (current_file == '' or current_file == nil) then
          vim.notify('Buffer is not a file, switching to global search', vim.log.levels.WARN)
          is_global = true
        end

        local title_scope = is_global and 'Global' or vim.fn.fnamemodify(current_file, ':t')
        vim.ui.input({ prompt = 'Git Search (-G) in ' .. title_scope .. ': ' }, function(query)
          if not query or query == '' then
            return
          end

          vim.fn.setreg('/', query)
          local old_hl = vim.opt.hlsearch
          vim.opt.hlsearch = true

          local args = {
            'log',
            '-G' .. query,
            '-i',
            '--pretty=format:%C(yellow)%h%Creset %s %C(green)(%cr)%Creset %C(blue)<%an>%Creset',
            '--abbrev-commit',
            '--date=short',
          }

          if not is_global then
            table.insert(args, '--')
            table.insert(args, current_file)
          end

          Snacks.picker({
            title = 'Git Log: "' .. query .. '" (' .. title_scope .. ')',
            finder = 'proc',
            cmd = 'git',
            args = args,
            transform = function(item)
              local clean_text = item.text:gsub('\27%[[0-9;]*m', '')
              local hash = clean_text:match('^%S+')
              if hash then
                item.commit = hash
                if not is_global then
                  item.file = current_file
                end
              end
              return item
            end,
            preview = 'git_show',
            confirm = walk_in_codediff,
            format = 'text',
            on_close = function()
              vim.opt.hlsearch = old_hl
              vim.cmd('noh')
            end,
          })
        end)
      end

      -- Keymaps for git log/search with CodeDiff
      vim.keymap.set('n', '<leader>gs', function()
        git_pickaxe({ global = false })
      end, { desc = 'Git search (buffer)' })

      vim.keymap.set('n', '<leader>gS', function()
        git_pickaxe({ global = true })
      end, { desc = 'Git search (global)' })

      vim.keymap.set('n', '<leader>gl', function()
        Snacks.picker.git_log_file({ confirm = walk_in_codediff })
      end, { desc = 'Git log file' })

      vim.keymap.set('n', '<leader>gL', function()
        Snacks.picker.git_log({ confirm = walk_in_codediff })
      end, { desc = 'Git log repo' })
    end,
  },
}
