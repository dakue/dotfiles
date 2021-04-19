set termguicolors

call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'sbdchd/neoformat'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'

call plug#end()

set background=dark
" silent! is needed because the theme is not available at the first startup
" and for the error to be acknowledged we would need a keyboard input
" https://stackoverflow.com/questions/54606581/ignore-all-errors-in-vimrc-at-vim-startup
silent! colorscheme solarized8
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'


let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

let g:deoplete#enable_at_startup = 1

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'terraform': ['terraform-lsp'],
    \ 'sh': ['bash-language-server', 'start'],
    \ 'yaml': ['yaml-language-server', '--stdio']
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>

autocmd BufNewFile,BufRead *.tf set ft=terraform syntax=terraform
autocmd BufNewFile,BufRead *.tfvars set ft=terraform syntax=terraform
autocmd BufNewFile,BufRead *.hcl set ft=terraform syntax=terraform

" nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

nnoremap <C-p> :Files<CR>

augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

" taken from https://github.com/vim/vim/blob/master/runtime/defaults.vim
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
