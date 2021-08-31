local lsp = require'lspconfig'

-- function to attach completion and diagnostics
-- when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)

     local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Setup our mappings for the lsp actions
    local opts = {noremap = true, silent = true}
    buf_set_keymap("n", "ca",    "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "gD",    "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd",    "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "gr",    "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "gi",    "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "K",     "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "ff",    "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    buf_set_keymap("n", "dn",    "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "dp",    "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<c-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

    buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<space>e",  "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)

end

-- Configure each of the LSPs that we want to use
-- Apply any custom configuration here
lsp.pylsp.setup{
  on_attach = on_attach;
  settings = {
      pyls = {
          enable = true;
          plugins = {
              jedi_completion = {
                  enabled = true;
                  include_params = true;
              };
              jedi_definition = {
                  enabled = true;
                  follow_builtin_imports = true;
                  follow_imports = true;
              };
              jedi_hover = {
                  enabled = true;
              };
              jedi_references = {
                  enabled = true;
              };
              jedi_signature_help = {
                  enabled = true;
              };
              jedi_symbols = {
                  enabled = true;
                  all_scopes = true;
              };
              pylint = {
                  enabled = false;
              };
              yapf = {
                  enabled = true;
              };
          }
      }
  }
}

lsp.bashls.setup{
    on_attach = on_attach;
    cmd = { "bash-language-server", "start"};
    root_dir = lsp.util.root_pattern('.git');
}

lsp.gopls.setup{
  on_attach = on_attach;
  cmd = {"gopls", "serve"};
  settings = {
    gopls = {
      analyses = {
        unusedparams = true;
      };
      staticcheck = true;
      };
  };
}

lsp.jdtls.setup{
  on_attach = on_attach;
  root_dir = lsp.util.root_pattern(".git", "pom.xml", "build.xml")
}

lsp.diagnosticls.setup {
    on_attach = on_attach;
    cmd = {"diagnostic-languageserver", "--stdio"},
    filetypes = {
        "lua",
        "sh",
        "json",
        "yaml",
        "toml"
    },
    init_options = {
        linters = {
            shellcheck = {
                command = "shellcheck",
                debounce = 100,
                args = {"--format", "json", "-"},
                sourceName = "shellcheck",
                parseJson = {
                    line = "line",
                    column = "column",
                    endLine = "endLine",
                    endColumn = "endColumn",
                    message = "${message} [${code}]",
                    security = "level"
                },
                securities = {
                    error = "error",
                    warning = "warning",
                    info = "info",
                    style = "hint"
                }
            },
        },
        filetypes = {
            sh = "shellcheck",
        },
        formatters = {
            shfmt = {
                command = "shfmt",
                args = {"-i", "2", "-bn", "-ci", "-sr"}
            },
            prettier = {
                command = "prettier",
                args = {"--stdin-filepath", "%filepath"},
            }
        },
        formatFiletypes = {
            sh = "shfmt",
            json = "prettier",
            yaml = "prettier",
            toml = "prettier",
            lua = "prettier"
        }
    }
}

-- Use a loop to setup servers that dont have custom settings
-- just attach the custom on_attach function
local servers = {
  "metals",
  "tsserver",
  "vuels",
  "rust_analyzer"
}
for _, lsp_name in ipairs(servers) do
    lsp[lsp_name].setup {
        on_attach = on_attach
    }
end

-- vim diagnostic config
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,

    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = false,

    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,

    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = false,
  }
)


-- setup telescope.nvim
local telescope = require'telescope'
local actions = require'telescope.actions'

telescope.setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<CR>"]  = actions.select_default + actions.center,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
      }
    }
  }
}

-- treesitter config
local tree = require'nvim-treesitter.configs'
tree.setup {
  ensure_installed = { "bash", "dockerfile", "go", "java", "javascript", "lua", "python", "rust", "tsx", "typescript", "vue", "yaml" },
  highlight = {
    enable = true
  }
}

-- setup diffview
-- -- Lua
local cb = require'diffview.config'.diffview_callback

require'diffview'.setup {
  diff_binaries = false,    -- Show diffs for binaries
  file_panel = {
    width = 35,
    use_icons = true        -- Requires nvim-web-devicons
  },
  key_bindings = {
    disable_defaults = false,                   -- Disable the default key bindings
    -- The `view` bindings are active in the diff buffers, only when the current
    -- tabpage is a Diffview.
    view = {
      ["<tab>"]     = cb("select_next_entry"),  -- Open the diff for the next file
      ["<s-tab>"]   = cb("select_prev_entry"),  -- Open the diff for the previous file
      ["<leader>e"] = cb("focus_files"),        -- Bring focus to the files panel
      ["<leader>b"] = cb("toggle_files"),       -- Toggle the files panel.
    },
    file_panel = {
      ["j"]             = cb("next_entry"),         -- Bring the cursor to the next file entry
      ["<down>"]        = cb("next_entry"),
      ["k"]             = cb("prev_entry"),         -- Bring the cursor to the previous file entry.
      ["<up>"]          = cb("prev_entry"),
      ["<cr>"]          = cb("select_entry"),       -- Open the diff for the selected entry.
      ["o"]             = cb("select_entry"),
      ["<2-LeftMouse>"] = cb("select_entry"),
      ["-"]             = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
      ["S"]             = cb("stage_all"),          -- Stage all entries.
      ["U"]             = cb("unstage_all"),        -- Unstage all entries.
      ["R"]             = cb("refresh_files"),      -- Update stats and entries in the file list.
      ["<tab>"]         = cb("select_next_entry"),
      ["<s-tab>"]       = cb("select_prev_entry"),
      ["<leader>e"]     = cb("focus_files"),
      ["<leader>b"]     = cb("toggle_files"),
    }
  }
}
