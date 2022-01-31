----------------------------------------
-- nvim-tree.lua
----------------------------------------
local tree = require('nvim-tree')
local common = require('common')

tree.setup({
  -- updates the root directory of the tree on `DirChanged` (when `:cd` is run)
  update_cwd = true,
})

common.nvim_nmap('<leader>tree', [[:NvimTreeToggle<cr>]])
common.nvim_nmap('<leader>cd', ':cd %:p:h<CR>:pwd<CR>')

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
})

--local neoclip = require('neoclip')
--
--neoclip.setup({
--  keys = {
--    telescope = {
--      i = {
--        paste_behind = '<c-o>',
--      },
--    },
--  },
--})

common.nvim_nmap('<leader>f', [[<cmd>lua require('telescope.builtin').live_grep{}<CR>]])
common.nvim_nmap('<leader>ff', [[<cmd>lua require('telescope.builtin').find_files{}<CR>]])
common.nvim_nmap('<leader>fg', [[<cmd>lua require('telescope.builtin').git_files{}<CR>]])
--common.nvim_nmap('<leader>fr', [[<cmd>lua require('telescope').extensions.neoclip.default{}<CR>]])

-- vim pickers
common.nvim_nmap('<leader>fb', [[<cmd>lua require('telescope.builtin').buffers{show_all_buffers = true }<CR>]])
common.nvim_nmap('<leader>fm', [[<cmd>lua require('telescope.builtin').keymaps{}<CR>]])
common.nvim_nmap('<leader>fc', [[<cmd>lua require('telescope.builtin').commands{}<CR>]])
common.nvim_nmap('<leader>fk', [[<cmd>lua require('telescope.builtin').keymaps{}<CR>]])
common.nvim_nmap('<leader>ll', [[<cmd>lua require('telescope.builtin').loclist{}<cr>]])
