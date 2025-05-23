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

local view_group = vim.api.nvim_create_augroup('auto_view', { clear = true })

vim.api.nvim_create_autocmd({ 'BufWinLeave', 'BufWritePost', 'WinLeave' }, {
  desc = 'Save view with mkview for real files',
  group = view_group,
  callback = function(args)
    if vim.b[args.buf].view_activated then
      vim.cmd.mkview({ mods = { emsg_silent = true } })
    end
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Try to load file view if available and enable view saving for real files',
  group = view_group,
  callback = function(args)
    if not vim.b[args.buf].view_activated then
      local filetype = vim.api.nvim_get_option_value('filetype', { buf = args.buf })
      local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })
      local ignore_filetypes = { 'gitcommit', 'gitrebase', 'svg', 'hgcommit' }
      if buftype == '' and filetype and filetype ~= '' and not vim.tbl_contains(ignore_filetypes, filetype) then
        vim.b[args.buf].view_activated = true
        vim.cmd.loadview({ mods = { emsg_silent = true } })
      end
    end
  end,
})

-- set conceallevel for markdown to 1 to use with obsidian.nvim
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  desc = 'Set conceallevel based on filetype',
  callback = function()
    if string.match(vim.bo.filetype, 'markdown') then
      vim.opt.conceallevel = 1
    else
      vim.opt.conceallevel = 0
    end
  end,
})

vim.api.nvim_create_augroup('DiffHighlights', { clear = false })
vim.api.nvim_create_autocmd({ 'WinEnter', 'OptionSet' }, {
  group = 'DiffHighlights',
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'DiffAdd', { fg = 'none', bg = '#2e4b2e', bold = true })
    vim.api.nvim_set_hl(0, 'DiffChange', { fg = 'none', bg = '#45565c', bold = true })
    vim.api.nvim_set_hl(0, 'DiffText', { fg = 'none', bg = '#635417', bold = true })
  end,
})
