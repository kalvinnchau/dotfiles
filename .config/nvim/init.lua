-- enable lua module caching for faster startup
if vim.loader then
  vim.loader.enable()
end

-- load core configuration
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- add mason bin to PATH
vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local out = vim
    .system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
    })
    :wait()

  if out.code ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out.stderr, 'WarningMsg' },
      { '\nPress any key to exit...', 'WarningMsg' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- setup plugins
require('lazy').setup({
  spec = {
    { import = 'plugins' },
    { import = 'plugins.lang' },
  },
  defaults = {
    lazy = true,
  },
  install = { colorscheme = { 'gruvbox' } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
