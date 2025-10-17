vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

vim.keymap.set(
  'n',
  '<leader>erc',
  ':e ~/.config/nvim/init.lua<cr> | :cd %:p:h<CR>:pwd<cr> | :Neotree toggle<cr>',
  { desc = 'edit nvim cfg' }
)

vim.keymap.set('n', '<leader>path', [[:echo expand('%:p')<cr>]])

-- base64 visual selection decoding and encoding
vim.keymap.set('v', '<leader>b', 'y:let @"=system(\'base64 --decode\', @")<cr>gvP')
vim.keymap.set('v', '<leader>B', 'y:let @"=trim(system(\'base64\', @"))<cr>gvP')

-- copy path of file to clipboard
vim.keymap.set(
  'n',
  '<leader>pf',
  ':let @+=expand("%:p")<CR>',
  { silent = true, desc = 'Copy absolute file path to clipboard' }
)
vim.keymap.set(
  'n',
  '<leader>pr',
  ':let @+=expand("%:p:.")<CR>',
  { silent = true, desc = 'Copy relative file path to clipboard' }
)
