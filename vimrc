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
set encoding=utf8

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Enable filetype plugins
filetype plugin on
filetype indent on


" Interface "
"""""""""""""

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

" Always show the status line
set laststatus=2

" Format the status line
set statusline=%<%f\ [%Y%R%W]%1*%{(&modified)?'\ +\ ':''}%*\ encoding\:\ %{&fileencoding}%=%c%V,%l\ %P\ [%n]

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

" Autocomplete options"
set complete=""
set complete+=.
set complete+=b
set complete+=t
set completeopt=menu

" Autocomplete on Tab
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

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

" ignore spell checking in single quote
syntax match quotesingleblock /'[^']\+'/ contains=@NoSpell


" Colors "
""""""""""

" Enable syntax highlighting
syntax enable

" Enable 256 colors palette in Gnome Terminal
set t_Co=256

color wombat256mod

" Highlight 80 column
set colorcolumn=80
highlight ColorColumn ctermbg=8

" change spellcheck highlight
hi SpellLocal ctermfg=black guifg=black

" highlight trailing spaces
au BufNewFile,BufRead * let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)


" Helper functions "
""""""""""""""""""""
function! NumbersToggle()
    set number!
    set relativenumber!
endfunction

function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction

function! ChangePaste(type, ...)
    silent exe "normal! `[v`]\"_c"
    silent exe "normal! p"
endfunction


" Plugins "
"""""""""""

" ctrlp settings
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': [],
  \ 'AcceptSelection("t")': ['<cr>', '<c-m>'],
  \ }
let g:ctrlp_cmd = 'CtrlPMixed'

" nerdtree settings
let NERDTreeIgnore = ['\.pyc$']
nmap <leader>b :NERDTreeToggle %:p:h<CR>

" ALE settings
let g:ale_linters = {
\   'python': ['pyls'],
\   'go': ['gopls', 'gofmt', 'golint', 'govet'],
\   'rust': ['analyzer', 'rls'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black'],
\   'rust': ['rustfmt'],
\}

let g:ale_fix_on_save = 1
let g:ale_open_list = 'on_save'

let g:ale_python_pyls_config = {
\   'pyls': {
\     'plugins': {
\       'pylint': {
\         'enabled': 0
\       }
\     }
\   },
\}

nmap <C-c>g :ALEGoToDefinition<CR>
nmap <C-c><C-c>g :tab split<CR>:ALEGoToDefinition<CR>
