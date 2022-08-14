set shell=/bin/bash
let mapleader = "\<Space>"

" =============================================================================
" # PLUGINS
" =============================================================================

set nocompatible
filetype off
" set rtp+=~/github.com/base16/templates/vim/

call plug#begin('~/.config/nvim/plugged')

" VIM enhancements
Plug 'ciaranm/securemodelines'
" Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-sneak'

" GUI enhancements
Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'kyazdani42/nvim-web-devicons'
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-fugitive'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Semantic language support
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'

Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
Plug 'hrsh7th/cmp-cmdline', {'branch': 'main'}
Plug 'hrsh7th/cmp-path', {'branch': 'main'}
Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}
Plug 'ray-x/lsp_signature.nvim'

" Only because nvim-cmp _requires_ snippets
Plug 'hrsh7th/cmp-vsnip', {'branch': 'main'}
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" Add some colors and icons to nvim-cmp.
Plug 'onsails/lspkind-nvim'

" Syntatic lauguage support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'rhysd/vim-clang-format'
Plug 'plasticboy/vim-markdown'
Plug 'dag/vim-fish'
Plug 'lervag/vimtex'
Plug 'udalov/kotlin-vim'

" Indentlines to see visual tabs/spaces.
Plug 'yggdroot/indentline'
call plug#end()
" Colors
"
set termguicolors
let base16colorspace=256
set background=dark
colorscheme base16-gruvbox-dark-hard
call Base16hi("Comment", g:base16_gui09, "", g:base16_cterm09, "", "", "")
hi Normal ctermbg=NONE
syntax on

" LSP configuration

lua <<END
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  -- Get signatures (and _only_ signatures) when in argument lists.
  require "lsp_signature".on_attach({
    doc_lines = 0,
    handler_opts = {
      border = "none"
    },
  })
end

local lspkind = require'lspkind'
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    -- Navigate suggestions
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },

    -- Navigate the docs being shown for a selected suggestion
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),

    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  }),
  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[api]",
        -- path = "[path]",
        luasnip = "[snip]",
      },
    },
  },
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['rust_analyzer'].setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  cmd = {
    "ra-multiplex"
  },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
  capabilities = capabilities
}

-- vim.lsp.callbacks["testDocument/publishDiagnostics"] = vim.lsp.with(
-- vim.lsp.diagnostic.on_publish_diagnostics, {
--   virtual_text = true,
--	signs = true,
--	update_in_insert = true,
--   }
-- )

require('lualine').setup {
    options = { theme = 'gruvbox-material' }
}
END

" inlay hints don't work for some reason.
" autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }

" Completion
" Disable rainbow brackets by default
let g:rainbow_active = 0

" Lightline
let g:lightline = {
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\	          [ 'readonly', 'filename', 'modified' ] ],
	\   'right': [ [ 'lineinfo' ],
	\              [ 'percent' ],
	\              [ 'fileencoding', 'filetype' ] ],
	\ },
	\ 'component_function': {
	\   'filename': 'LightlineFilename',
	\ },
	\ }

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

" let g:lightline.component_expand = {
"	\ 'linter_checking': 'lightline#lsc#checking',
"	\ 'linter_warnings': 'lightline#lsc#warnings',
"	\ 'linter_errors': 'lightline#lsc#errors',
"	\ 'linter_ok': 'lightline#lsc#ok'
"	\ }

" let g:lightline.component_type = {
"	\ 'linter_checking': 'left',
"	\ 'linter_warnings': 'warning',
"	\ 'linter_errors': 'error',
"	\ 'linter_ok': 'left',
"	\ }

" let g:lightline.active = { 'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]] }

if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep\ --ignore-file\ /home/theodor/.config/nvim/rg.ignore
	set grepformat=%f:%l:%c:%m
endif


" Open hotkeys
map <C-p> :Files<CR>
nmap <leader>; :Buffers<CR>

" Quick-save
nmap <leader>w :w<CR>

" Rust

let g:rustfmt_autosave = 1
" let g:rustfmt_emit_files = 1
" let g:rustfmt_fail_silently = 1
" let g:rustfmt_options = "--edition 2018"
" let g: rust_clip_command = 'xclip -selection clipboard'


au FileType rust set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent


filetype plugin indent on


" let g:rust_recommended_style = 1

" Completion
" Better completion
" menuone: popup even when there's only one match
" noinsert: Do not insert test until a selection is made
" noselect: Do not select, force user to select one from menu
set completeopt=noinsert,menuone,noselect
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300


" =============================================================================
" # Editor settings
" =============================================================================
"set autoindent
set encoding=utf-8
set scrolloff=2
set number
set hidden
set nowrap
set nojoinspaces

set splitright
set splitbelow

" Permanent undo history
set undodir=~/.vimundo
set undofile

" =============================================================================
" # Snippets
" =============================================================================
"
" NOTE: You can use other key to expand snippet.

" Expand
" imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
" smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
" imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
" smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <C-l>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
" smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
" imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
" smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

" =============================================================================
" # GUI settings
" =============================================================================

map <F1> <Esc>
imap <F1> <Esc>
set foldlevel=99

if has('nvim')
	runtime! plugin/python_setup.vim
endif

" A color column
set colorcolumn=100

" =============================================================================
" # Stuff done with <leader>* mappings
" =============================================================================

" Clipboard integration
" ,p paste clipboard into buffer
" ,c copy buffer into clipboard
if has('macunix')
    noremap <leader>p :read !pbpaste<cr>
    noremap <leader>c :w !pbcopy<cr><cr>
else
    noremap <leader>p :read !xsel --clipboard --output<cr>
    noremap <leader>c :w !xsel -ib<cr><cr>
endif


" Quick-save
nmap <leader>w :w<CR>

" Ripgrep
noremap <leader>s :Rg

" Toggle tab/space indent lines
nmap <silent> <leader>t :call ToggleIndents()<CR>

" Call git blame from vim-fugitive
nmap <leader>b :Git blame<CR>

" Toggle rainbow brackets with leader+r
nmap <leader>r :RainbowToggle<CR>

" =============================================================================

let g:fzf_preview_window = ['up:70%', 'ctrl-/']
let g:fzf_layout = { 'window': 'enew' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --ignore-file /home/theodor/.config/nvim/rg.ignore '.shellescape(<q-args>).strpart(0, 25), 1,
  \   fzf#vim#with_preview(), <bang>0)

function! s:list_cmd()
  let base = fnamemodify(expand('%'), ':h:.:S')
  return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')).strpart(0, 25))
endfunction

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': s:list_cmd(),
  \                               'options': '--tiebreak=index'}), <bang>0)

" =============================================================================
" # Errors bindings
" =============================================================================
nmap <silent> <C-h> :close<cr>

" =============================================================================
" # Toggle on|off tabs identation
" =============================================================================

let g:indentLine_enabled = 0
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

function! ToggleIndents()
  if !exists("b:showIndents")
    let b:showIndents = 0
  endif

  if b:showIndents == 0
    let b:showIndents = 1

    set list lcs=tab:\|\ 
    :IndentLinesToggle
  else
    let b:showIndents = 0

    set list!
    :IndentLinesToggle
  endif
endfunction

" =============================================================================
" # Work with long lines
" =============================================================================

"set columns=100
autocmd VimResized * | set columns=120
set showbreak=⤷
set linebreak
set wrap
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
noremap  <buffer> <silent> <Up>   gk
noremap  <buffer> <silent> <Down> gj


" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" =============================================================================
" # Watch changes to config and reaload
" =============================================================================

if has ('autocmd')
 augroup vimrc
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif


" =============================================================================
" # Press F2 to show tabs vs spaces
" =============================================================================
set lcs+=space:·
nmap <F3> :set invlist<CR>
imap <F3> <ESC>:set invlist<CR>a

" =============================================================================
" # LaTeX configuration.
" =============================================================================
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=2
let g:tex_conceal='abdmg'
