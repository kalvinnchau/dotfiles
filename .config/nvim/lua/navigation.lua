----------------------------------------
-- nvim-tree.lua
----------------------------------------
vim.api.nvim_set_keymap('', '<leader>tree', [[:NvimTreeToggle<cr>]], {silent=true})

local tree = require('nvim-tree')

tree.setup {
}

----------------------------------------
-- telescope.nvim
----------------------------------------
local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<CR>"]  = actions.select_default + actions.center,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
      }
    }
  }
}

local opts = {noremap=true, silent=true}

vim.api.nvim_set_keymap(
  'n', '<leader>f', [[<cmd>lua require('telescope.builtin').live_grep{}<CR>]], opts
)

vim.api.nvim_set_keymap(
  'n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files{}<CR>]], opts
)

vim.api.nvim_set_keymap(
  'n', '<leader>fg', [[<cmd>lua require('telescope.builtin').git_files{}<CR>]], opts
)

-- vim pickers
vim.api.nvim_set_keymap(
  'n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers{show_all_buffers = true }<CR>]], opts
)
vim.api.nvim_set_keymap(
  'n', '<leader>fm', [[<cmd>lua require('telescope.builtin').keymaps{}<CR>]], opts
)
vim.api.nvim_set_keymap(
  'n', '<leader>fc', [[<cmd>lua require('telescope.builtin').commands{}<CR>]], opts
)


vim.api.nvim_set_keymap(
  'n', '<leader>ll', [[<cmd>lua require('telescope.builtin').loclist{}<cr>]], opts
)
