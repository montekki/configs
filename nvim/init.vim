set shell=/bin/bash
let mapleader = "\<Space>"

" =============================================================================
" # PLUGINS
" =============================================================================

set nocompatible
filetype off
" set rtp+=~/github.com/base16/templates/vim/

call plug#begin('~/.local/share/nvim/plugged')

" VIM enhancements
Plug 'ciaranm/securemodelines'
Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-sneak'

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Semantic language support
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'

" Syntatic lauguage support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'rhysd/vim-clang-format'
Plug 'plasticboy/vim-markdown'
Plug 'dag/vim-fish'

call plug#end()
" Colors
"
set termguicolors
set background=dark
" colorscheme base16-eighties
hi Normal ctermbg=NONE
syntax on

" # Base16
" let base16colorspace=256

" LSP configuration

lua << END
local lspconfig = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', ops)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  -- Forward to other plugins
  require'completion'.on_attach(client)
end

local servers = { "rust_analyzer" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
	flags = {
	  debounce_test_changes = 150,
	}
  }
end

vim.lsp.handlers["testDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
	signs = true,
	update_in_insert = true,
  }
)
END

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

" let g:rustfmt_autosave = 1
" let g:rustfmt_emit_files = 1
" let g:rustfmt_fail_silently = 1
" let g:rustfmt_options = "--edition 2018"
" let g: rust_clip_command = 'xclip -selection clipboard'

" let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/lib/rustlib/src/rust/src"

"au FileType rust set tabstop=4 shiftwidth=4 expandtab
au FileType rust set tabstop=4 shiftwidth=4 expandtab

" Completion
" Better completion
" menuone: popup even when there's only one match
" noinsert: Do not insert test until a selection is made
" noselect: Do not select, force user to select one from menu
set completeopt=noinsert,menuone,noselect
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

let g:rust_recommended_style = 0

" =============================================================================
" # Editor settings
" =============================================================================
filetype plugin indent on
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
noremap <leader>p :read !xsel --clipboard --output<cr>
noremap <leader>c :w !xsel -ib<cr><cr>

" Quick-save
nmap <leader>w :w<CR>

" Ripgrep
noremap <leader>s :Rg

" Toggle tab/space indent lines
nmap <silent> <leader>t :call ToggleIndents()<CR>

" Call git blame from vim-fugitive
nmap <leader>b :Gblame<CR>

" Toggle rainbow brackets with leader+r
nmap <leader>r :RainbowToggle<CR>

" =============================================================================

let g:fzf_layout = { 'down': '~30%' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --ignore-file /home/theodor/.config/nvim/rg.ignore '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

function! s:list_cmd()
  let base = fnamemodify(expand('%'), ':h:.:S')
  return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')))
endfunction

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
  \                               'options': '--tiebreak=index'}, <bang>0)

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
