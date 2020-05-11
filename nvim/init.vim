set shell=/bin/bash
let mapleader = "\<Space>"

" =============================================================================
" # PLUGINS
" =============================================================================

set nocompatible
filetype off

call plug#begin('~/.local/share/nvim/plugged')
Plug 'chriskempson/base16-vim'

Plug 'w0rp/ale'
Plug 'itchyny/lightline.vim'

Plug 'palpatineli/lightline-lsc-nvim'

Plug 'chriskempson/base16-vim'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Semantic language support
Plug 'phildawes/racer'
Plug 'racer-rust/vim-racer'
Plug 'ncm2/ncm2-racer'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'

" Completion plugins
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-pyclang'

" Syntatic lauguage support
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'
Plug 'plasticboy/vim-markdown'

Plug 'tpope/vim-fugitive'

Plug 'Yggdroot/indentLine'

" Rainbow brackets
Plug 'luochen1990/rainbow'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'

call plug#end()
" Colors
"
set termguicolors
set background=dark
colorscheme base16-mexico-light
hi Normal ctermbg=NONE
syntax on

" # Base16
let base16colorspace=256

let g:LanguageClient_serverCommands = {
\ 'rust': ['rust-analyzer'],
\ }

let g:LanguageClient_usePopupHover = 0
let g:LanguageClient_useFloatingHover = 0

noremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> A :call LanguageClient#textDocument_codeAction()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gt :call LanguageClient#textDocument_typeDefinition()<CR>
nnoremap <silent> gi :call LanguageClient#textDocument_implementation()<CR>
nnoremap <silent> gs :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
nnoremap <silent> gv :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
nnoremap <silent> gl :call LanguageClient#handleCodeLensAction()<CR>
" TODO: this should run automatically on file open
nnoremap <silent> gb :call LanguageClient#textDocument_codeLens()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <C-l> :call LanguageClient#explainErrorAtPoint()<CR>

" Disable rainbow brackets by default
let g:rainbow_active = 0

let g:lightline = {
	\ 'component_function': {
	\   'filename': 'LightlineFilename',
	\ }
	\ }

function! LightlineFilename()
	let root = fnamemodify(get(b:, 'git_dir'), ':h')
	let path = expand('%:p')
	if path[:len(root)-1] ==# root
		return path[len(root)+1:]
	endif
	return expand('%')
endfunction

let g:lightline.component_expand = {
	\ 'linter_checking': 'lightline#lsc#checking',
	\ 'linter_warnings': 'lightline#lsc#warnings',
	\ 'linter_errors': 'lightline#lsc#errors',
	\ 'linter_ok': 'lightline#lsc#ok'
	\ }

let g:lightline.component_type = {
	\ 'linter_checking': 'left',
	\ 'linter_warnings': 'warning',
	\ 'linter_errors': 'error',
	\ 'linter_ok': 'left',
	\ }

let g:lightline.active = { 'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]] }

if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep\ --ignore-file\ /home/theodor/.config/nvim/rg.ignore
	set grepformat=%f:%l:%c:%m
endif


" Rust
"
highlight link ALEWarningSign Todo
highlight link ALEErrorSign WarningMsg
highlight link ALEVirtualTextWarning Todo
highlight link ALEVirtualTextInfo Todo
highlight link ALEVirtualTextError WarningMsg
" show the exact spot for the error or the warning
highlight ALEError guibg=None gui=underline
highlight ALEWarning guibg=None gui=underline
let g:ale_sign_error = "✖"
let g:ale_sign_warning = "⚠"
let g:ale_sign_info = "i"
let g:ale_sign_hint = "➤"
" let g:rustfmt_autosave = 1
" let g:rustfmt_emit_files = 1
" let g:rustfmt_fail_silently = 1
let g:rustfmt_options = "--edition 2018"

let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/lib/rustlib/src/rust/src"

au FileType rust set tabstop=4 shiftwidth=4 expandtab
"au FileType rust set tabstop=4 shiftwidth=4 noexpandtab
set tabstop=4 shiftwidth=4 expandtab

" Completion
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect

inoremap <expr><Tab> (pumvisible()?(empty(v:completed_item)?"\<C-n>":"\<C-y>"):"\<Tab>")
inoremap <expr><CR> (pumvisible()?(empty(v:completed_item)?"\<CR>":"\<C-y>"):"\<CR>")

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

let g:rust_recommended_style = 0

" Rust
"
" Go
au FileType go set noexpandtab
let g:go_play_open_browser = 0
let g:go_fmt_fail_silently = 0
let g:go_fmt_autosave = 1
let g:go_fmt_emit_files = 1
let g:go_bin_path = "/usr/local/go/bin"

" C/C++
let g:ncm2_pyclang#library_path = '/usr/lib/llvm-6.0/lib'

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
set colorcolumn=120

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
