local common = require('common')
----------------------------------------
-- Appearance settings
----------------------------------------
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_context_patterns = {
    'class', 'function', 'method', '^if', '^while',
    '^for', '^object', '^table', 'block', 'arguments',
    'func_literal', 'block',
}

vim.o.termguicolors = true
vim.o.background = 'dark'

-- gruvbox
vim.g.gruvbox_contrast_dark = 'medium'
vim.g.gruvbox_contrast_light = 'medium'
--vim.g.gruvbox_improved_strings = 1
vim.g.gruvbox_improved_warnings = 1

require('lualine').setup{
    options = {
        theme = 'gruvbox',
    }
}

require('bufferline').setup{
    options = {
        numbers = 'buffer_id',
        diagnostics = 'nvim_lsp',
    }
}

-- cycle through buffers with b+tab or b+shift+tab
common.nvim_nmap('b<tab>',    ':BufferLineCycleNext<cr>')
common.nvim_nmap('b<s-tab>',  ':BufferLineCyclePrev<cr>')

require('nvim-web-devicons').setup{}

vim.cmd[[colorscheme gruvbox]]
