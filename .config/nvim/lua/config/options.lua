----------------------------------------
-- Vim Configuration
----------------------------------------
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- enable reading of rc files in cwd
vim.opt.exrc = true

vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildignore = '*.o,*~,*.pyc,*/tmp/*,*.zip,*/.git/*,*/tmp/*,*.swp'

-- set completeopt to have a better completion experience
--  :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.opt.completeopt = 'menuone,noinsert,noselect'
-- avoid showing message extra message when using completion
vim.opt.shortmess = vim.opt.shortmess + 'c'
-- show current position
vim.opt.ruler = true
-- find words as you type
vim.opt.incsearch = true
-- ignore case when searching
vim.opt.ignorecase = true
-- be smart about casing
vim.opt.smartcase = true
-- highlight search results
vim.opt.hlsearch = true

-- highlight the current line for easier visiual identification
vim.opt.cursorline = true
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#302D2B' })
  end,
})

-- have fixed column for diagnostics to appear
vim.opt.signcolumn = 'yes'

-- show effects of a command in a preview window
vim.opt.inccommand = 'split'

-- start scrolling before cursor hits top/bottom
vim.opt.scrolloff = 10
-- Number of lines to jump when scrolling off screen
-- -# = percentage
vim.opt.scrolljump = -10

-- allow resizing splits with mouse
vim.opt.mouse = vim.opt.mouse + 'a'

-- tab config
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- set auto indent and wrapping
vim.opt.wrap = true
vim.opt.ai = true

vim.opt.backspace = 'indent,eol,start'

-- turn off backup
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- undo config
vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.termguicolors = true
vim.o.background = 'dark'

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldenable = false
