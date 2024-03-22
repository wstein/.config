" nvim config based on https://betterprogramming.pub/setting-up-neovim-for-web-development-in-2020-d800de3efacd

call plug#begin("~/.vim/plugged")
  " Plugin Section
  Plug 'editorconfig/editorconfig-vim'
  Plug 'github/copilot.vim'
  Plug 'ryanoasis/vim-devicons'
  Plug 'scrooloose/nerdtree'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'wstein/dracula-vim'
  Plug 'yegappan/taglist'
call plug#end()


" -------- Config dracula ----------
if (has("termguicolors"))
 set termguicolors
endif
syntax enable
colorscheme dracula
" ----------------------------------


" -------- Config tree -------------
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>
" ----------------------------------


" -------- Config terminal ---------
" open new split panes to right and below
set splitright
set splitbelow
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
" open terminal on ctrl+n
function! OpenTerminal()
  split term://zsh
  resize 10
endfunction
nnoremap <c-n> :call OpenTerminal()<CR>
" ----------------------------------


" -------- General config ----------
set number
set mouse=inv
set encoding=utf-8


" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" --- Copy and Paste via System Clipboard ----
set clipboard+=unnamedplus