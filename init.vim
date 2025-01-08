" Set internal encoding of vim
set encoding=utf-8

" Automatic installation vim plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" Wombat : Dark gray color scheme sharing some similarities with Desert
Plug 'vim-scripts/wombat256.vim'

if has('nvim')
    " One dark and light colorscheme for neovim 
    Plug 'navarasu/onedark.nvim'
endif

" Dark color scheme for Vim and vim-airline, inspired by Dark+ in Visual Studio Code
Plug 'tomasiser/vim-code-dark'

" Highlight several words in different colors simultaneously
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'

" A Git wrapper so awesome, it should be illegal
Plug 'tpope/vim-fugitive'

" abolish.vim: easily search for, substitute, and abbreviate multiple variants of a word
Plug 'tpope/vim-abolish'

" A tree explorer plugin for vim
Plug 'scrooloose/nerdtree'

" Vim plugin for intensely orgasmic commenting
Plug 'scrooloose/nerdcommenter'

" quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" Fuzzy file, buffer, mru, tag, etc finder
Plug 'ctrlpvim/ctrlp.vim'

" Vim plugin for the CLI script 'ack
Plug 'mileszs/ack.vim'

" A nicer Python indentation style for vim.
Plug 'Vimjas/vim-python-pep8-indent'

" Adds file type icons to Vim plugins such as: NERDTree, vim-airline, CtrlP, ...
Plug 'ryanoasis/vim-devicons'

" lsp plugins for NeoVim
if has("nvim")
    " Quickstart configs for Nvim LSP
    Plug 'neovim/nvim-lspconfig'
    " A completion plugin for neovim coded in Lua.
    Plug 'hrsh7th/nvim-cmp'
    " nvim-cmp source for neovim builtin LSP client
    Plug 'hrsh7th/cmp-nvim-lsp'
    " luasnip completion source for nvim-cmp 
    Plug 'saadparwaiz1/cmp_luasnip'
    " Snippet Engine for Neovim written in Lua. 
    Plug 'L3MON4D3/LuaSnip'

    Plug 'TabbyML/vim-tabby'
endif

Plug 'puremourning/vimspector'

call plug#end()

" Text "
""""""""

" Use spaces instead of tabs
set expandtab

" 1 tab == 4 spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 expandtab

" Set utf8 as standard encoding
set encoding=UTF-8

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Enable filetype plugins
filetype plugin on
filetype indent on


" Interface "
"""""""""""""

" disable mouse
set mouse=

" We’re telling Vim that we can have unsaved worked that’s not displayed on your screen
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

set nobackup
set nowritebackup

" Turn on the Wild menu
set wildmenu

" Completion mode like bash
set wildmode=longest,list,full

" Set 3 lines to the cursor - when moving vertically using j/k
set scrolloff=3

" Show line numbers
set number
set relativenumber

" Toggle line numbers
nnoremap <F12> :call NumbersToggle()<CR>

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Always show the status line
set laststatus=2

" Format the status line
set statusline=%<%f\ [%Y%R%W]%1*%{(&modified)?'\ +\ ':''}%*\ encoding\:\ %{&fileencoding}%=%c%V,%l\ %P\ [%n]

" Give more space for displaying messages.
set cmdheight=2

" Always show the tabs line
set showtabline=2

" Ignore some files
set wildignore=*.pyc,*.aux

" Smart way to move between windows
map <C-l> <C-W><Right>
map <C-h> <C-W><Left>
map <C-k> <C-W><Up>
map <C-j> <C-W><Down>

" Key layout
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

" Hotkeys for open tab
cnoreabbrev nt tabnew
cnoreabbrev tn tabnew
" previous tab
nmap gr gT
" last tab
nmap 0gt :tablast<cr>

" Hotkeys for switching buffers
nmap gn :bnext<cr>
nmap gp :bprevious<cr>
nmap gd :bdelete<cr>

" Autocomplete options"
set complete=""
set complete+=.
set complete+=b
set complete+=t
set completeopt=menu

" Autocomplete on Tab
" inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

" This allows for change paste motion cp{motion}
nmap <silent> cp :set opfunc=ChangePaste<CR>g@

" Hotkey for paste option
set pastetoggle=<F2>

" This command will allow us to save a file we don't have permission to save
" *after* we have already opened it. Super useful.
cnoremap w!! w !sudo tee % >/dev/null

"
augroup XML
    autocmd!
    autocmd FileType xml setlocal foldmethod=indent foldlevelstart=999 foldminlines=0
augroup END


" Searching "
"""""""""""""

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch


" Spell checking "
""""""""""""""""""
set spell spelllang=ru_yo,en_us
map <leader>ss :setlocal spell!<cr>

autocmd FileType list setlocal nospell

" Colors "
""""""""""

" Enable syntax highlighting
syntax enable

" Enable 256 colors palette in Gnome Terminal
set t_Co=256

color wombat256mod
" let g:onedark_config = {'style': 'warmer'}
" colorscheme onedark

" Highlight 80 column
set colorcolumn=80
highlight ColorColumn ctermbg=8

" highlight trailing spaces
au BufNewFile,BufRead * let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)


" Helper functions "
""""""""""""""""""""
function! NumbersToggle()
    set number!
    set relativenumber!
endfunction

function! ChangePaste(type, ...)
    silent exe "normal! `[v`]\"_c"
    silent exe "normal! p"
endfunction

" python "
""""""""""
let g:python3_host_prog = '/usr/bin/python3'


" Plugins "
"""""""""""

" ctrlp settings
let g:ctrlp_cmd = 'CtrlPMixed'

" ==============================================================================
" NERDTree settings
let NERDTreeIgnore = ['\.pyc$']
nmap <leader>b :NERDTreeToggle %:p:h<CR>

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" calls NERDTreeFind if NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff && bufname('%') !~# 'NERD_tree'
    try
      NERDTreeFind
      if bufname('%') =~# 'NERD_tree'
        setlocal cursorline
        wincmd p
      endif
    endtry
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * silent! call SyncTree()
" ==============================================================================

" vimspector
" https://github.com/puremourning/vimspector/blob/master/support/custom_ui_vimrc"
nnoremap <Leader>dd :call vimspector#Launch()<CR>
nnoremap <Leader>dr :call vimspector#Reset()<CR>
nnoremap <Leader>dt :call vimspector#Reset()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>

nnoremap <Leader>db :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dB :call vimspector#ClearBreakpoints()<CR>

nmap <Leader>dk <Plug>VimspectorRestart
nmap <Leader>dh <Plug>VimspectorStepOut
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver

if has('nvim')
    " lsp
    lua require('lsp_setup')
    let g:tabby_inline_completion_keybinding_accept = '<C-l>'
endif
