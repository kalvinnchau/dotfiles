----------------------------------------
-- nvim-tree.lua
----------------------------------------
local tree = require('nvim-tree')

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

vim.keymap.set('n', '<leader>tree', [[:NvimTreeToggle<cr>]])
vim.keymap.set('n', '<leader>cd', ':cd %:p:h<cr>:pwd<cr>')

vim.g.symbols_outline = {
  show_guides = false,
  auto_preview = false,
  show_numbers = true,
  auto_close = true,
}
vim.keymap.set('n', '<leader><Tab>', [[:SymbolsOutline<cr>]])

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
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      },
    },
  },
})

telescope.load_extension("ui-select")

vim.keymap.set('n', '<leader>f', [[<cmd>lua require('telescope.builtin').live_grep{}<CR>]])
vim.keymap.set('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files{}<CR>]])
vim.keymap.set('n', '<leader>fg', [[<cmd>lua require('telescope.builtin').git_files{}<CR>]])
--vim.keymap.set('n', '<leader>fr', [[<cmd>lua require('telescope').extensions.neoclip.default{}<CR>]])

-- vim pickers
vim.keymap.set('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers{show_all_buffers = true }<CR>]])
vim.keymap.set('n', '<leader>fm', [[<cmd>lua require('telescope.builtin').keymaps{}<CR>]])
vim.keymap.set('n', '<leader>fc', [[<cmd>lua require('telescope.builtin').commands{}<CR>]])
vim.keymap.set('n', '<leader>fk', [[<cmd>lua require('telescope.builtin').keymaps{}<CR>]])
vim.keymap.set('n', '<leader>ll', [[<cmd>lua require('telescope.builtin').loclist{}<cr>]])
