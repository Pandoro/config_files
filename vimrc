""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline setup
set laststatus=2
set t_Co=256
let g:airline_powerline_fonts = 0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Gitgutter config
let g:gitgutter_sign_column_always = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle setup
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required!
Plugin 'gmarik/vundle'

" The bundles to be installed:

" Status bar
Plugin 'bling/vim-airline'
"Git plugin
Plugin 'tpope/vim-fugitive'
"Directory tree
Plugin 'scrooloose/nerdtree'
"Maps autocompletion to the tab key
"Plugin 'ervandew/supertab'
"Shows git diff in the sidebar.
Plugin 'airblade/vim-gitgutter'
"Markdown support
Plugin 'plasticboy/vim-markdown'
    

"Jedi vim for auto completion... it's not the best but what can one do.
"Plugin 'davidhalter/jedi-vim'
"Some python specific things. It includes a lot but here it is only configured
"for syntax highlighting and pylint.
"Plugin 'klen/python-mode'

call vundle#end()
filetype plugin indent on
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Error indication at 80
2mat ErrorMsg '\%81v.'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings
"Nerd tree on F2
map <F2> :NERDTreeToggle <CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Replace tabs with 4 spaces
set expandtab
set tabstop=4
set shiftwidth=4
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python-mode
" Disable rope as jedi mode is used for auto completetion
let g:pymode_rope = 0

" Documentation
" Again jedi mode is used.
let g:pymode_doc = 0

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" Auto check on save
let g:pymode_lint_write = 1
" Ignore certain errors
let g:pymode_lint_ignore = "C0110"

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = 'b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" automatically change window's cwd to file's dir
set autochdir
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Allow mouse clicks in all modes and make it copyable with ctrl+c
set mouse=a
set paste
vmap <C-C> "+y
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use relative line numbers per default 
set relativenumber

"Allow to change using <C-l>
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

nnoremap <C-l> :call NumberToggle()<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Markdown plugin settings. 
" No folding. 
let g:vim_markdown_initial_foldlevel=5
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
