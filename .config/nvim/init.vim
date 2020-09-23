""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
filetype plugin indent on

let mapleader = ","

"""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""
" Turn on the Wild menu
set wildmenu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*/tmp/*,*.zip,*/.git/*,*/tmp/*,*.swp
" Always show current position
set ruler
" When searching try to be smart about cases
set smartcase
" Highlight search results
set hlsearch
" Find words as typing out search
set incsearch
" Enable extended % matching
runtime macros/matchit.vim
" Start scrolling before cursor hits top/bottom
set scrolloff=5
" Number of lines to jump when scrolling off screen
" -# = percentage
set scrolljump=-10

" Set background dark
set background=dark

" Use system clipboard
nnoremap <leader>ys "+yy
nnoremap <leader>ps "+p
nnoremap <leader>all :%y+<cr>

" escape
inoremap jj <Esc>
tmap jj <Esc>

" Quick funtion that will
" highlight over 80 columns
autocmd FileType cpp :autocmd! BufWritePre * :match ErrorMsg '\%>80v.\+'

autocmd Filetype javascript setlocal ts=2 sw=2 sts=0
autocmd Filetype vue setlocal ts=2 sw=2 sts=0
autocmd Filetype ts setlocal ts=2 sw=2 sts=0

" Use Unix as the standard file type
set ffs=unix,mac,dos

set updatetime=500

set wildoptions +=pum

""""""""""""""""""""""""""""
" => Files, backups and undo
""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc.
set nobackup
set nowb
set noswapfile

set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000

" Source and Edit nvim/init
nnoremap <leader>src :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>erc :vsp ~/.config/nvim/init.vim<cr>

""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Do not expand tab for Makefiles
autocmd FileType make set noexpandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=2
set tabstop=2

" Auto indent and wrap lines
set ai
set wrap

" Set the backspace to work as expected
set backspace=2

" Auto remove trailing whitespace on write
autocmd BufWritePre * :%s/\s\+$//e


"""""""""""""""""""""""""""""""""""
" Neovim terminal support
"""""""""""""""""""""""""""""""""""
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
endif



""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug setup
""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/nvim/plugged')

""""""""""""""""""""""""""""""""""""""""""""" Visuals
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

let g:airline#extensions#tabline#enabled = 1
let airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1

" Shows the indentation levels with lines
Plug 'Yggdroot/indentLine'
" Highlights extra whitespace in bright red
Plug 'ntpeters/vim-better-whitespace'
""""""""""""""""""""""""""""""""""""""""""""" End Visuals



""""""""""""""""""""""""""""""""""""""""""""" Colorschemes
Plug 'morhetz/gruvbox'

nnoremap <leader>light :set background=light<cr>
nnoremap <leader>dark :set background=dark<cr>
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'
"let g:gruvbox_improved_strings=1
let g:gruvbox_improved_warnings=1


"""""""""""""""""""""""""""""""""""""""""""""" Navigation
" Use ripgrep if ya got it!
if executable("rg")
    set grepprg=rg\ --vimgrep
    set grepformat^=%f:%l:%c:%m
    " Recursively search for word under cursor
    nnoremap <leader>f :silent grep <C-R><C-W><CR>:cw<CR>
    " Recursively search for visually selected phrase
    vnoremap <leader>f y:silent grep '<C-R>"'<CR>:cw<CR>
endif

"""""""""""""""""""""""""""""""""""""""""""""" End Navigation

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

"""""""""""""""""""""""""""""""""""""""""""""" Languages & Files
Plug 'plasticboy/vim-markdown', { 'for' : ['md'] }
Plug 'ajorgensen/vim-markdown-toc'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

Plug 'elzr/vim-json', {'for': ['json']}
let g:vim_json_syntax_conceal = 0
autocmd FileType json setlocal foldmethod=syntax

Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'cespare/vim-toml'

"" For Jenkinsfiles
au BufNewFile,BufRead Jenkinsfile set filetype=groovy

Plug 'ekalinin/Dockerfile.vim', {'for': ['dockerfile']}
" Set Dockefile filetype if name contains Dockerfile
au BufRead,BufNewFile Dockerfile set filetype=dockerfile
au BufRead,BufNewFile Dockerfile* set filetype=dockerfile

" Neovim LSP configs
Plug 'neovim/nvim-lsp'

" Completion plugins
Plug 'nvim-lua/completion-nvim'

" Get the current buffer for completion
Plug 'steelsojka/completion-buffers'

" Diagnostic navigation and settings for built-in LSP
Plug 'nvim-lua/diagnostic-nvim'

"""""""""""""""""""""""""""""""""""""""""""""" Languages & Files

call plug#end()

colorscheme gruvbox

nnoremap <leader>PI :PlugInstall<cr>
nnoremap <leader>PU :PlugUpdate<cr>
nnoremap <leader>PR :PlugUpgrade<cr>
nnoremap <leader>PUR :UpdateRemotePlugins<cr>
nnoremap <leader>fz :Files<cr>

"""
" Completion configuration
"""

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
" " :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()

" configure the completion-buffers, as a secondary source
let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp', 'snippet' ]},
    \{'complete_items': ['buffer']},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'}
\]

" use <c-j> and <c-k> to move between sources ^
let g:completion_auto_change_source = 1
imap <c-j> <Plug>(completion_prev_source)
imap <c-k> <Plug>(completion_next_source)

" Code navigation shortcuts
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>

"""
" inccommand!
"""
if exists('&inccommand')
      set inccommand=split
endif

"""
" Neovim LSP Configuration
"""
lua << EOF

local nvim_lsp = require'nvim_lsp'

-- function to attach completion and diagnostics
-- when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
    require'diagnostic'.on_attach(client)
end


nvim_lsp.pyls.setup{
    cmd = { "/Users/kchau/venv/python3/neovim/bin/pyls" };
    on_attach= on_attach=on_attach;
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
                    enabled = true;
                };
                yapf = {
                    enabled = true;
                };
            }
        }
    }
}

nvim_lsp.bashls.setup{
    root_dir = nvim_lsp.util.root_pattern('.git');
}

nvim_lsp.gopls.setup{on_attach = on_attach}
nvim_lsp.sumneko_lua.setup{on_attach = on_attach}
nvim_lsp.rust_analyzer.setup{on_attach = on_attach}
nvim_lsp.metals.setup{on_attach = on_attach}
EOF
