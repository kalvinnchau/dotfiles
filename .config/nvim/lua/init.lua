-- install packer if it's not already installed
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  vim.api.nvim_echo({{'packer.nvim not foun, installing packer.nvim', 'Type'}}, true, {})
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

-- import all our files
require('plugins')
require('appearance')
require('vimcfg')
require('other')
require('navigation')
require('lsp')
