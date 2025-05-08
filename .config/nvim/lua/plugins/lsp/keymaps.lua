local M = {}

---@type PluginLspKeys
M._keys = nil

---@return (LazyKeys|{has?:string})[]
function M.get()
  local format = require('plugins.lsp.format').format
  if not M._keys then
    ---@class PluginLspKeys
    -- stylua: ignore
    M._keys = {
      { 'ca', vim.lsp.buf.code_action,                          desc = 'show code actions' },

      { 'gd', require('telescope.builtin').lsp_definitions,     desc = 'go to definition' },
      { 'gi', require('telescope.builtin').lsp_implementations, desc = 'show lsp implementations' },
      { 'gr', require('telescope.builtin').lsp_references,      desc = 'show references to the symbol' },
      {
        'gsd',
        function()
          require('telescope.builtin').lsp_definitions({
            jump_type = 'split',
          })
        end,
        desc = 'go to definition in a horizontal split view'
      },
      {
        'gsv',
        function()
          require('telescope.builtin').lsp_definitions({
            jump_type = 'vsplit',
          })
        end,
        desc = 'go to definition in a vertical split view'
      },
      {
        'K',
        function()
          if vim.bo.filetype == 'rust' then
            vim.cmd.RustLsp({ 'hover', 'actions' })
          else
            vim.lsp.buf.hover({ border = "single" })
          end
        end,
        desc = 'display information about the symbol'
      },
      { '<c-k>',     vim.lsp.buf.signature_help, desc = 'display the signature help' },
      {
        'ff',
        function()
          vim.lsp.buf.format({ async = true })
          require('mini.trailspace').trim()
        end,
        desc = 'format the current buffer'
      },
      {
        '<leader>tf',
        function()
          require('plugins.lsp.format').toggle()
        end,
        desc = 'toggle autoformat'
      },
      -- diagnostics
      {
        '<leader>da',
        function()
          require('telescope.builtin').diagnostics({ bufnr = 0 })
        end,
        desc = 'show diagnostics in current buffer'
      },
      {
        '<leader>dw',
        function()
          require('telescope.builtin').diagnostics()
        end,
        desc = 'show diagnostics for workspace'
      },
      {
        '<leader>dn',
        function()
          vim.diagnostic.jump({ count = 1, float = true })
        end,
        desc = 'go to next diagnostic'
      },
      {
        '<leader>dp',
        function()
          vim.diagnostic.jump({ count = -1, float = true })
        end,
        desc = 'go to previous diagnostic'
      },

      { '<space>rn', vim.lsp.buf.rename,         desc = 'rename the current symbol' },
    }
    if require('config.util').has('inc-rename.nvim') then
      M._keys[#M._keys + 1] = {
        '<leader>cr',
        function()
          require('inc_rename')
          return ':IncRename ' .. vim.fn.expand('<cword>')
        end,
        expr = true,
        desc = 'Rename',
        has = 'rename',
      }
    else
      M._keys[#M._keys + 1] = { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename', has = 'rename' }
    end
  end
  return M._keys
end

function M.on_attach(client, buffer)
  local Keys = require('lazy.core.handler.keys')
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

  for _, value in ipairs(M.get()) do
    local keys = Keys.parse(value)
    if keys.rhs == vim.NIL or keys.rhs == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end

  for _, keys in pairs(keymaps) do
    if not keys.has or client.server_capabilities[keys.has .. 'Provider'] then
      local opts = Keys.opts(keys)
      vim.keymap.set(keys.mode or 'n', keys.lhs, keys.rhs, { silent = true, buffer = buffer })
    end
  end
end

return M
