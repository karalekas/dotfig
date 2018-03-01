""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim configuration file
"
" author: Peter Karalekas (2018)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" tabbing and indentation rules
set tabstop=4
set shiftwidth=4
set softtabstop=4

" indent automatically
set autoindent

" use spaces instead of tabs
set expandtab

" enable syntax highlighting
if has("syntax")
  syntax on
endif

" have Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" load indentation rules and plugins according to the detected filetype
if has("autocmd")
  filetype plugin indent on
endif
