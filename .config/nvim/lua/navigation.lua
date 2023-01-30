----------------------------------------
-- nvim-tree.lua
----------------------------------------
local tree = require('nvim-tree')
local wk = require('which-key')

tree.setup({
  -- updates the root directory of the tree on `DirChanged` (when `:cd` is run)
  update_cwd = true,
  renderer = {
    add_trailing = true,
    indent_markers = {
      enable = true,
    },
  },
})

vim.keymap.set('n', '<leader>tree', [[:NvimTreeToggle<cr>]], { desc = 'toggle tree view' })

vim.g.symbols_outline = {
  show_guides = false,
  auto_preview = false,
  show_numbers = true,
  auto_close = true,
}

vim.keymap.set('n', '<leader>sm', [[:SymbolsOutline<cr>]], { desc = 'show all symbols in file' })

local symbols = require('symbols-outline')
symbols.setup()

----------------------------------------
-- telescope.nvim
----------------------------------------
local telescope = require('telescope')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

telescope.setup({
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
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<CR>'] = actions.select_default + actions.center,
        ['<C-x>'] = actions.select_horizontal,
        ['<C-v>'] = actions.select_vertical,
        ['<C-t>'] = actions.select_tab,
      },
    },
  },
  pickers = {
    git_commits = {
      mappings = {
        i = {
          -- Open selected commit in diffview
          ['<C-d>'] = function()
            local selected_entry = action_state.get_selected_entry()
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
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown({}),
    },
  },
})

telescope.load_extension('ui-select')

wk.register({
  f = {
    name = 'file', -- optional group name
    g = { [[<cmd>lua require('telescope.builtin').live_grep{}<CR>]], 'grep files in cwd' },
    f = { [[<cmd>lua require('telescope.builtin').find_files{}<CR>]], 'pick any files in cwd' },
    t = { [[<cmd>lua require('telescope.builtin').git_files{}<CR>]], 'pick git files in cwd' },
    b = { [[<cmd>lua require('telescope.builtin').buffers{show_all_buffers=true}<CR>]], 'pick from all buffers' },
    v = { [[<cmd>lua require('telescope.builtin').commands{}<CR>]], 'pick any vim command' },
    c = { [[<cmd>lua require('telescope.builtin').git_commits{}<CR>]], 'pick from git commits' },
    k = { [[<cmd>lua require('telescope.builtin').keymaps{}<CR>]], 'pick any keymap' },
    r = { [[<cmd>lua require('telescope.builtin').oldfiles{}<CR>]], 'pick recently opened files' },
    s = { [[<cmd>lua require('telescope.builtin').search_history{}<CR>]], 'pick recent searches' },
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
}, { prefix = '<leader>' })
