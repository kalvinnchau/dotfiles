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
    c = { [[<cmd>lua require('telescope.builtin').commands{}<CR>]], 'pick any command' },
    k = { [[<cmd>lua require('telescope.builtin').keymaps{}<CR>]], 'pick any keymap' },
    r = { [[<cmd>lua require('telescope.builtin').oldfiles{}<CR>]], 'pick recently opened files' },
    s = { [[<cmd>lua require('telescope.builtin').search_history{}<CR>]], 'pick recent searches' },
  },
}, { prefix = '<leader>' })
