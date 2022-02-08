local lsp = require('lspconfig')
local common = require('common')
local luasnip = require('luasnip')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local M = {}

function M.show_line_diagnostics()
  local opts = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = 'single',
    source = 'always',  -- show source in diagnostic popup window
    prefix = ' '
  }
  vim.diagnostic.open_float(nil, opts)
end

-- signs
vim.fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "⚠", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "ⓘ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- icons
require('lspkind').init({
  mode = 'text_symbol',
  preset = 'default',
})

-- configure nvim-cmp
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'text_symbol',
      menu = {
        buffer = '[buffer]',
        nvim_lsp = '[lsp]',
        luasnip = '[luaSnip]',
        nvim_lua = '[lua]',
        path = '[path]',
      },
    }),
  },
})

vim.cmd([[autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }]])

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities = require('cmp_nvim_lsp').update_capabilities(updated_capabilities)

-- function to attach completion and diagnostics
-- when setting up lsp
local on_attach = function(client)
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Setup our mappings for the lsp actions
  common.nvim_buf_nmap('ca', [[<cmd>lua require('telescope.builtin').lsp_code_actions{}<cr>]])
  common.nvim_buf_nmap('gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
  common.nvim_buf_nmap('gi', [[<cmd>lua require('telescope.builtin').lsp_implementations{}<cr>]])
  common.nvim_buf_nmap('gd', [[<cmd>lua require('telescope.builtin').lsp_definitions{}<cr>]])
  common.nvim_buf_nmap('gsd', [[<cmd>lua require('telescope.builtin').lsp_definitions{ jump_type = 'split' }<cr>]])
  common.nvim_buf_nmap('gr', [[<cmd>lua require('telescope.builtin').lsp_references{}<cr>]])

  common.nvim_buf_nmap('K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  common.nvim_buf_nmap('ff', '<cmd>lua vim.lsp.buf.formatting()<CR>')

  common.nvim_buf_nmap('td', [[<cmd>lua require('telescope.builtin').diagnostics{}<cr>]])
  common.nvim_buf_nmap('dn', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  common.nvim_buf_nmap('dp', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  common.nvim_buf_nmap('<c-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')

  common.nvim_buf_nmap('<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  common.nvim_buf_nmap('<space>e', '<cmd>lua require("lsp").show_line_diagnostics()<CR>')
end

-- Configure each of the LSPs that we want to use
-- Apply any custom configuration here

------------------------------------------------------------
-- python
------------------------------------------------------------
lsp.pylsp.setup({
  on_attach = on_attach,
  settings = {
    pyls = {
      enable = true,
      plugins = {
        jedi_completion = {
          enabled = true,
          include_params = true,
        },
        jedi_definition = {
          enabled = true,
          follow_builtin_imports = true,
          follow_imports = true,
        },
        jedi_hover = {
          enabled = true,
        },
        jedi_references = {
          enabled = true,
        },
        jedi_signature_help = {
          enabled = true,
        },
        jedi_symbols = {
          enabled = true,
          all_scopes = true,
        },
        pylint = {
          enabled = false,
        },
        yapf = {
          enabled = true,
        },
      },
    },
  },
  capabilities = updated_capabilities,
})

------------------------------------------------------------
-- bash
------------------------------------------------------------
lsp.bashls.setup({
  on_attach = on_attach,
  cmd = { 'bash-language-server', 'start' },
  root_dir = lsp.util.root_pattern('.git'),
  capabilities = updated_capabilities,
})

------------------------------------------------------------
-- null-ls https://github.com/jose-elias-alvarez/null-ls.nvim
------------------------------------------------------------
local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua.with({
      extra_args = { '--config-path', vim.fn.expand('~/.config/stylua/stylua.toml') },
    }),
    null_ls.builtins.formatting.prettier.with({
      filetypes = { 'html', 'json', 'yaml', 'markdown' },
    }),
    null_ls.builtins.diagnostics.shellcheck,
  },
  on_attach = on_attach,
  capabilities = updated_capabilities,
})

--lsp['null-ls'].setup({
--  on_attach = on_attach,
--  capabilities = updated_capabilities,
--})

------------------------------------------------------------
-- golang
------------------------------------------------------------
lsp.gopls.setup({
  on_attach = on_attach,
  cmd = { 'gopls', 'serve' },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  capabilities = updated_capabilities,
})

-- run the go formatter on save
vim.api.nvim_command('autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync()')

------------------------------------------------------------
-- java
------------------------------------------------------------
lsp.jdtls.setup({
  on_attach = on_attach,
  root_dir = lsp.util.root_pattern('.git', 'pom.xml', 'build.xml'),
  capabilities = updated_capabilities,
})

------------------------------------------------------------
-- lua
------------------------------------------------------------
local system_name
if vim.fn.has('mac') == 1 then
  system_name = 'macOS'
elseif vim.fn.has('unix') == 1 then
  system_name = 'Linux'
else
  print('Unsupported system for sumneko')
end

local sumneko_root_path = vim.fn.expand('~/code/src/github.com/sumneko/lua-language-server')
local sumneko_binary = sumneko_root_path .. '/bin/' .. system_name .. '/lua-language-server'

lsp.sumneko_lua.setup({
  cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
  on_attach = on_attach,
  capabilities = updated_capabilities,
})

-- Use a loop to setup servers that dont have custom settings
-- just attach the custom on_attach function
local servers = {
  'metals',
  'tsserver',
  'vuels',
  'rust_analyzer',
}
for _, lsp_name in ipairs(servers) do
  lsp[lsp_name].setup({
    on_attach = on_attach,
    capabilities = updated_capabilities,
  })
end

-- vim diagnostic config

-- time in ms for CursorHold, to display the current line's diagnostic
vim.g.cursorhold_updatetime = 100
vim.cmd([[autocmd CursorHold * lua require('lsp').show_line_diagnostics()]])

vim.diagnostic.config({
  underline = true,

  -- This will disable virtual text, like doing:
  -- let g:diagnostic_enable_virtual_text = 0
  virtual_text = false, -- {spacing = 4, prefix = "■"},

  -- This is similar to:
  -- let g:diagnostic_show_sign = 1
  -- To configure sign display,
  --  see: ':help vim.diagnostic.set_signs()'
  signs = true,

  -- This is similar to:
  -- 'let g:diagnostic_insert_delay = 1'
  update_in_insert = false,
})

return M
