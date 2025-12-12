" ----------------------------------------------------------
" Colors and Display
" ----------------------------------------------------------
highlight Comment ctermfg=magenta
set background=dark
set number
set spell
set noswapfile

" ----------------------------------------------------------
" Indentation and Formatting
" ----------------------------------------------------------
set expandtab
set ai
set tabstop=4
set shiftwidth=4

" ----------------------------------------------------------
" Search Behavior
" ----------------------------------------------------------
set ignorecase
set smartcase
set wildmenu
set wildignore=*.exe,*.dll,*.pdb
set hlsearch

" ----------------------------------------------------------
" Syntax and Filetype
" ----------------------------------------------------------
syntax on
filetype plugin indent on

" ----------------------------------------------------------
" Leader Key
" ----------------------------------------------------------
let mapleader = ' '

" ----------------------------------------------------------
" Remove Trailing Whitespace on Save
" ----------------------------------------------------------
autocmd BufWritePre * %s/\s\+$//e

" ----------------------------------------------------------
" Plugin Manager (vim-plug)
" ----------------------------------------------------------
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs ' .
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ----------------------------------------------------------
" Plugins
" ----------------------------------------------------------
call plug#begin('~/vimplugins')

" LSP + Completion
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'

" Tools
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'

call plug#end()

" ----------------------------------------------------------
" Auto-Completion Mappings
" ----------------------------------------------------------
imap <C-Space> <Plug>(asyncomplete_force_refresh)
inoremap <expr> <Tab>    pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab>  pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>     pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" ----------------------------------------------------------
" LSP Configuration
" ----------------------------------------------------------
let g:lsp_semantic_enabled = 1      " Enable semantic highlighting

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> gi <Plug>(lsp-definition)
    nmap <buffer> gd <Plug>(lsp-declaration)
    nmap <buffer> gr <Plug>(lsp-references)
    nmap <buffer> gl <Plug>(lsp-document-diagnostics)
    nmap <buffer> <F2> <Plug>(lsp-rename)
    nmap <buffer> <F3> <Plug>(lsp-hover)
endfunction

augroup lsp_config
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    let g:asyncomplete_auto_popup_delay = 300
augroup END

" ----------------------------------------------------------
" FZF Keybindings
" ----------------------------------------------------------
nnoremap <silent> <leader>/ :Rg<CR>
nnoremap <silent> <leader><space> :Files<CR>
