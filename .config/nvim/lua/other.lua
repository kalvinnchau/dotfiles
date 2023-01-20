----------------------------------------
-- generic 'other' config
----------------------------------------
local wk = require('which-key')

-- name the group for diagnostics
wk.register({
  d = {
    name = 'diagnostics',
  }
}, { prefix = '<leader>' })

-- vim lua config mappings
wk.register({
  er = {
    name = 'config',
    c = { ':e ~/.config/nvim/init.vim<cr> | :cd %:p:h<CR>:pwd<cr> | :NvimTreeToggle<cr>', 'open vim cfg' },
    l = { ':vsp ~/.config/nvim/lua/init.lua<cr>', 'open init lua in split' },
  },
}, { prefix = '<leader>' })

wk.register({
  p = {
    name = 'path',
    wd = { ':cd %:p:h<cr>:pwd<cr>', 'show cwd' },
    ath = { ':echo expand("%:p")<cr>', 'show full path of current buffer'}
  }
}, { prefix = '<leader>' })

-- setup packer mappings
wk.register({
  P = {
    name = 'Packer',
    I = { '<cmd>PackerInstall<cr>', 'packer install' },
    U = { '<cmd>PackerUpdate<cr>', 'packer update and compile' },
    S = { '<cmd>PackerSync<cr>', 'packer sync packages' },
    C = { '<cmd>PackerCompile<cr>', 'packer compile' },
  },
}, { prefix = '<leader>' })

-- treesitter config
local tree = require('nvim-treesitter.configs')
tree.setup({
  -- TODO consider using 'maintained'
  ensure_installed = {
    'bash',
    'dockerfile',
    'go',
    'java',
    'javascript',
    'lua',
    'python',
    'rust',
    'tsx',
    'typescript',
    'vue',
    'yaml',
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

-- setup diffview
-- -- Lua
local cb = require('diffview.config').diffview_callback

require('diffview').setup({
  diff_binaries = false, -- Show diffs for binaries
  file_panel = {
    win_config = {
      width = 35,
    },
  },
  key_bindings = {
    disable_defaults = false, -- Disable the default key bindings
    -- The `view` bindings are active in the diff buffers, only when the current
    -- tabpage is a Diffview.
    view = {
      ['<tab>'] = cb('select_next_entry'), -- Open the diff for the next file
      ['<s-tab>'] = cb('select_prev_entry'), -- Open the diff for the previous file
      ['<leader>e'] = cb('focus_files'), -- Bring focus to the files panel
      ['<leader>b'] = cb('toggle_files'), -- Toggle the files panel.
    },
    file_panel = {
      ['j'] = cb('next_entry'), -- Bring the cursor to the next file entry
      ['<down>'] = cb('next_entry'),
      ['k'] = cb('prev_entry'), -- Bring the cursor to the previous file entry.
      ['<up>'] = cb('prev_entry'),
      ['<cr>'] = cb('select_entry'), -- Open the diff for the selected entry.
      ['o'] = cb('select_entry'),
      ['<2-LeftMouse>'] = cb('select_entry'),
      ['-'] = cb('toggle_stage_entry'), -- Stage / unstage the selected entry.
      ['S'] = cb('stage_all'), -- Stage all entries.
      ['U'] = cb('unstage_all'), -- Unstage all entries.
      ['R'] = cb('refresh_files'), -- Update stats and entries in the file list.
      ['<tab>'] = cb('select_next_entry'),
      ['<s-tab>'] = cb('select_prev_entry'),
      ['<leader>e'] = cb('focus_files'),
      ['<leader>b'] = cb('toggle_files'),
    },
  },
})

-- don't hide the quotes for json
vim.g.vim_json_syntax_conceal = 0

require('incolla').setup({
  -- Default configuration for all filetype
  defaults = {
    img_dir = 'images',
    img_name = function()
      return os.date('%Y-%m-%d-%H-%M-%S')
    end,
    affix = '%s',
  },
  -- You can customize the behaviour for a filetype by creating a field named after the desired filetype
  -- If you're uncertain what to name your field to, you can run `lua print(vim.bo.filetype)`
  -- Missing options from `<filetype>` field will be replaced by the default configuration
  markdown = {
    affix = '![](%s)',
  },
})

vim.api.nvim_set_keymap('n', '<leader>xp', '', {
    noremap = true,
    callback = function()
        require'incolla'.incolla()
    end,
})
