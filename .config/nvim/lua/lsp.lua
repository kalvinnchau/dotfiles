local lsp = require('lspconfig')
local common = require('common')

-- signs
--vim.fn.sign_define('LspDiagnosticsErrorSign', {text='✗', texthl='LspDiagnosticsError', linehl='', numhl=''})
--vim.fn.sign_define('LspDiagnosticsWarningSign', {text='⚠', texthl='LspDiagnosticsWarning', linehl='', numhl=''})
--vim.fn.sign_define('LspDiagnosticsInformationSign', {text='ⓘ', texthl='LspDiagnosticsInformation', linehl='', numhl=''})
--vim.fn.sign_define('LspDiagnosticsHintSign', {text='✓', texthl='LspDiagnosticsHint', linehl='', numhl=''})

-- icons
require('lspkind').init({
  with_text = true,
  preset = 'default',
})

-- configure nvim-cmp
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      -- vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<s-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
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

  common.nvim_buf_nmap('ld', [[<cmd>lua require('telescope.builtin').lsp_document_diagnostics{}<cr>]])
  common.nvim_buf_nmap('dn', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  common.nvim_buf_nmap('dp', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  common.nvim_buf_nmap('<c-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')

  common.nvim_buf_nmap('<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  common.nvim_buf_nmap('<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
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

null_ls.config({
  sources = {
    null_ls.builtins.formatting.stylua.with({
      extra_args = { '--config-path', vim.fn.expand('~/.config/stylua/stylua.toml') },
    }),
    null_ls.builtins.formatting.prettier.with({
      filetypes = { 'html', 'json', 'yaml', 'markdown' },
    }),
    null_ls.builtins.diagnostics.shellcheck,
  },
})

lsp['null-ls'].setup({
  on_attach = on_attach,
  capabilities = updated_capabilities,
})
--------------------------------------------------------------
---- efm https://github.com/mattn/efm-langserver
---- generic lsp support
--------------------------------------------------------------
--local stylua_config = os.getenv("HOME") .. '/.config/stylua/stylua.toml'
--lsp.efm.setup{
--  cmd = { "efm-langserver", "-logfile", "/tmp/efm.log", "-loglevel", "10"},
--  on_attach = on_attach,
--  capabilities = updated_capabilities,
--  init_options = {documentFormatting = true},
--  filetypes = {"sh", "lua", "json"},
--  settings = {
--    rootMarkers = {".git/"},
--    languages = {
--      sh = {{
--        lintCommand = 'shellcheck -f gcc -x -',
--        lintSource = 'shellcheck',
--        lintFormats = {'%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'},
--        lintIgnoreExitCode = true,
--        lintStdin = true,
--      }},
--      lua = {{
--        formatCommand = 'stylua --config-path ' .. stylua_config .. ' -',
--        formatStdin = true,
--      }},
--      json = {{
--        formatCommand = 'jq -r .',
--        formatStdin = true,
--      }}
--    }
--  }
--}

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
vim.cmd([[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]])

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,

  -- This will disable virtual text, like doing:
  -- let g:diagnostic_enable_virtual_text = 0
  virtual_text = false, -- {spacing = 4, prefix = "■"},

  -- This is similar to:
  -- let g:diagnostic_show_sign = 1
  -- To configure sign display,
  --  see: ':help vim.lsp.diagnostic.set_signs()'
  signs = true,

  -- This is similar to:
  -- 'let g:diagnostic_insert_delay = 1'
  update_in_insert = false,
})
