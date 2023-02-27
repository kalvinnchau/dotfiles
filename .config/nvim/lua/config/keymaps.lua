vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

vim.keymap.set(
  'n',
  '<leader>erc',
  ':e ~/.config/nvim/init.lua<cr> | :cd %:p:h<CR>:pwd<cr> | :NvimTreeToggle<cr>',
  { desc = 'edit nvim cfg' }
)

vim.keymap.set('n', '<leader>path', [[:echo expand('%:p')<cr>]])

-- lazy
vim.keymap.set('n', '<leader>l', '<cmd>:Lazy<cr>', { desc = 'Lazy' })
