" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

let mapleader = '\'

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

let g:Tex_TreatMacViewerAsUNIX = 1
let g:Tex_ViewRule_pdf = 'open -a Preview'

" It is important ot have utf-8 as encoding, right?
set encoding=utf-8

" Now, something really important as well, autoidentation!
set autoindent
" It is good to know where you are in the file, right? Let's to it!
set ruler
" Numerating lines...
set number
" Sets the title of the terminal as the name of the file
set title
" Highlight the search cases
set hlsearch
" Syntax highlighting 
syntax on
" What if vim can access the system clipboard? Great!
set clipboard=unnamed
"set clipboard=unnmaedplus

" Just for safety, let us deactivate the arrows, ok? ;)
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
vnoremap <Left> :echoe "Use h"<CR>
vnoremap <Right> :echoe "Use l"<CR>
vnoremap <Up> :echoe "Use k"<CR>
vnoremap <Down> :echoe "Use j"<CR>
inoremap <Left> <Esc>:echoe "Use h"<CR>i
inoremap <Right> <Esc>:echoe "Use l"<CR>i
inoremap <Up> <Esc>:echoe "Use k"<CR>i
inoremap <Down> <Esc>:echoe "Use j"<CR>i

" Let's toggle the insert mode with ctrl+space 
nnoremap <C-space> i
imap <C-space> <Esc>


set wildmenu
set showcmd
set backspace=indent,eol,start

hi Search cterm=NONE ctermfg=white ctermbg=gray

" No backup files
set nobackup
" Only in case you don't want a backup file while editing
set nowritebackup
" No swap files
set noswapfile

" The key C will open the selected text at visual mode in a bash, so it will be possible to copy it without copying the line numbers etc. ;)
vnoremap C :w ! bash -c cat<CR>


augroup nonvim
   au!
   au BufRead *.png,*.jpg,*.pdf,*.gif,*.xls*,*.ppt*,*.doc*,*.rtf sil exe "!open " . shellescape(expand("%:p")) | bd | let &ft=&ft
augroup end
