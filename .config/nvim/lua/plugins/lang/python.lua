return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        --basedpyright = {
        --  settings = {
        --    disableOrganizeImports = true,
        --  },
        --},
        --pyright = {
        --  cmd = { 'pyright-langserver', '--stdio' },
        --  root_markers = {
        --    'pyproject.toml',
        --    'setup.py',
        --    'setup.cfg',
        --    'requirements.txt',
        --    'Pipfile',
        --    'pyrightconfig.json',
        --  },
        --  settings = {
        --    python = {
        --      analysis = {
        --        autoSearchPaths = true,
        --        useLibraryCodeForTypes = true,
        --      },
        --    },
        --  },
        --},
        ruff = {},
        ty = {},
      },
    },
    setup = {},
  },
}
-- kotlin.lua
--vim.lsp.enable('kotlin_lsp')
--vim.lsp.config('kotlin_lsp', {
--  cmd = { '/Users/kalvin/.local/share/nvim/mason/bin/kotlin-lsp', '--stdio' },
--})
--return {}
