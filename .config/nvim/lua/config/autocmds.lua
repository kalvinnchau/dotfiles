-- highlight yanks
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})

-- start terminal in insert mode
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  command = 'startinsert | set winfixheight',
})

-- auto remove trailing whitespace on write
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = ':%s/s+$//e',
})
