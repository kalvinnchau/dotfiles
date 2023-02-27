vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- lazy
vim.keymap.set('n', '<leader>l', '<cmd>:Lazy<cr>', { desc = 'Lazy' })
