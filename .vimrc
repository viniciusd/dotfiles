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
