colorscheme vividchalk
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'heartsentwined/vim-emblem'
Plugin 'kien/ctrlp.vim'
Plugin 'mortice/pbcopy.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'sheerun/vim-polyglot'
Plugin 'tpope/vim-fugitive'
Plugin 'elzr/vim-json'
Plugin 'tpope/vim-surround'
Plugin 'airblade/vim-gitgutter'

call vundle#end()            " required
filetype plugin indent on    " required

syntax on
""""""""""""""""""""""
" General Vim Config
""""""""""""""""""""""
set clipboard=unnamed
let mapleader = ','
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
" allow unsaved background buffers and remember marks/undo for them
set hidden
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set incsearch
set showmatch
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
set cmdheight=1
set switchbuf=useopen
" prevent vim from clobbering the scrollback buffer. see
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" don't make backups at all
set nobackup
set nowritebackup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
"line numbers
set nu
set nowrap

" reselect block after indent
"vnoremap < <gv
"vnoremap > >gv

" Move around splits with <c-hjkl>
"nnoremap <c-j> <c-w>j
"nnoremap <c-k> <c-w>k
"nnoremap <c-h> <c-w>h
"nnoremap <c-l> <c-w>l

set pastetoggle=<F6>

" Natural Splits
set splitbelow
set splitright

""""""""""""""""""""""
" Ctrl-P
""""""""""""""""""""""
map <leader>k :CtrlP<cr>
let g:ctrlp_custom_ignore = '\v(vendor|node_modules|target)$'

""""""""""""""""""""""
" NERDTree
""""""""""""""""""""""
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <leader>nt :NERDTreeToggle<cr>
map <leader>ns :NERDTreeFind<cr>

""""""""""""""""""""""
" Airline
""""""""""""""""""""""
let g:airline_powerline_fonts = 1
let g:airline_section_z = "%p%% %l:%c"
let g:airline_section_warning = ''

" taken from: http://stackoverflow.com/questions/356126/how-can-you-automatically-remove-trailing-whitespace-in-vim/1618401#1618401
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
autocmd BufWritePre *.rb,*.clj :call <SID>StripTrailingWhitespaces()


" Toggle word wrap
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function! ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
  endif
endfunction
