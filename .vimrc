" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" It is important to have utf-8 as encoding, right?
set encoding=utf-8

" Now, something really important as well, autoidentation!
set autoindent
" It is good to know where you are in the file, right? Let's to it!
set ruler
" First, let us enable absolute line numbers
set number
" Relative line numbers 
set relativenumber
" Let us have a function to alternate between relative and absolute numbering
function! NumberToggle()
    set relativenumber!
endfunc

" Ctrl+n is our mapping for this function!
nnoremap <C-n> :call NumberToggle()<cr>

autocmd FocusLost * :set norelativenumber 
autocmd FocusGained * :set relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

" Sets the title of the terminal as the name of the file
set title
" Highlight the search cases
set hlsearch
" Syntax highlighting 
syntax on
" What if vim can access the system clipboard? Great!
set clipboard=unnamed
"set clipboard=unnmaedplus

" Set folding based on indentation
set foldmethod=indent
autocmd Syntax * normal zR

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

" Open some files in its respective reader 
augroup nonvim
   au!
   au BufRead *.png,*.jpg,*.pdf,*.gif,*.xls*,*.ppt*,*.doc*,*.rtf sil exe "!open " . shellescape(expand("%:p")) | bd | let &ft=&ft
augroup end

" The width of a TAB is set to 4. Still it is a \t. It is just that Vim will
" interpret it to be having a width of 4.
set tabstop=4

" Indents will have a width of 4
set shiftwidth=4

" A combination of spaces and tabs are used to simulate tab stops at a width
" other than the (hard)tabstop. Sets the number of columns for a TAB
set softtabstop=4

" Expand TABs to spaces
set expandtab

" Make TAB insert indents instead of tabs at the beginning of a line
set smarttab

" Commenting blocks of code.
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

"Turns off the highlighting of the current search result by hitting return
nnoremap <CR> :noh<CR><CR>

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
    set undolevels=1000
    set undoreload=10000
endif
