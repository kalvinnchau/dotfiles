----------------------------------------
-- Common helper functions
----------------------------------------
-- non-recursive remap, silence output
local mapopts = { noremap = true, silent = true }

-- set keymap in normal mode, with noremap and silent
local function nvim_nmap(lhs, rhs)
  vim.api.nvim_set_keymap('n', lhs, rhs, mapopts)
end

-- buffer local keymap in normal mode, with noremap and silent
local function nvim_buf_nmap(lhs, rhs)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, mapopts)
end

return {
  nvim_nmap = nvim_nmap,
  nvim_buf_nmap = nvim_buf_nmap,
}
