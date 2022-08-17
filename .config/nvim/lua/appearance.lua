----------------------------------------
-- Appearance settings
----------------------------------------
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_context_patterns = {
  'class',
  'function',
  'method',
  '^if',
  '^while',
  '^for',
  '^object',
  '^table',
  'block',
  'arguments',
  'func_literal',
  'block',
}

vim.o.termguicolors = true
vim.o.background = 'dark'

-- use only filetype.lua
-- may miss some filetypes nvim 0.7 is opt-in
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- gruvbox
vim.g.gruvbox_contrast_dark = 'medium'
vim.g.gruvbox_contrast_light = 'medium'
--vim.g.gruvbox_improved_strings = 1
vim.g.gruvbox_improved_warnings = 1

require('lualine').setup({
  options = {
    theme = 'gruvbox',
  },
})

require('bufferline').setup({
  options = {
    numbers = 'buffer_id',
    diagnostics = 'nvim_lsp',
    offsets = {
      {
        filetype = 'NvimTree',
        text_align = 'center',
        text = 'File Explorer',
      },
    },
  },
  -- remove italics
  highlights = {
    buffer_selected = {
      bold = true,
    },
    diagnostic_selected = {
      bold = true,
    },
    info_selected = {
      bold = true,
    },
    info_diagnostic_selected = {
      bold = true,
    },
    warning_selected = {
      bold = true,
    },
    warning_diagnostic_selected = {
      bold = true,
    },
    error_selected = {
      bold = true,
    },
    error_diagnostic_selected = {
      bold = true,
    },
    pick_selected = {
      bold = true,
    },
    pick_visible = {
      bold = true,
    },
    pick = {
      bold = true,
    },
  },
})

-- cycle through buffers with [+tab or ]+shift+tab
vim.keymap.set('n', '[<tab>', ':BufferLineCycleNext<cr>')
vim.keymap.set('n', '[<s-tab>', ':BufferLineCyclePrev<cr>')

require('nvim-web-devicons').setup({})

vim.o.background = 'dark'
vim.cmd([[colorscheme gruvbox]])

require('mini.trailspace').setup({
  only_in_normal_buffers = true,
})
