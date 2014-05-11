""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline setup
set laststatus=2
set t_Co=256
let g:airline_powerline_fonts = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Gitgutter config
let g:gitgutter_sign_column_always = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set my colorscheme
colorscheme basic
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle setup
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" The bundles to be installed:

" Status bar
Bundle 'bling/vim-airline'
"Git plugin
Bundle 'tpope/vim-fugitive'
"Directory tree
Bundle 'scrooloose/nerdtree'
"Maps autocompletion to the tab key
"Bundle 'ervandew/supertab'
"Shows git diff in the sidebar.
Bundle 'airblade/vim-gitgutter'
"Markdown support
Bundle 'plasticboy/vim-markdown'
    

"Jedi vim for auto completion... it's not the best but what can one do.
"Bundle 'davidhalter/jedi-vim'
"Some python specific things. It includes a lot but here it is only configured
"for syntax highlighting and pylint.
"Bundle 'klen/python-mode'

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

"Copy to X11 buffer on F3
map <F3> "+y

"Paste from X11 buffer on F4
map <F4> "+p
imap <F4> <C-o>"+p
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
"Allow mouse clicks in all modes
set mouse=a
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
