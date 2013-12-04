"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
set filetype=off
set mouse=a
set ruler
set ignorecase
set smartcase
set incsearch
set hlsearch
set showcmd
set textwidth=119
set tabstop=5
set shiftwidth=5
set smarttab
set cursorline
set expandtab
set number
set listchars=tab:>·,eol:¬,precedes:«,extends:»
set wildmode=longest,list,full
set wildmenu
set t_Co=256
set pastetoggle=<F2>
set showmode
set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
set statusline=%<%f%h%m%r%=format=%{&fileformat}\ file=%{&fileencoding}\ enc=%{&encoding}\ %b\ 0x%B\ %l,%c%V\ %P
set laststatus=2
set backupdir=/tmp
set errorformat^=%-G%f:%l:\ warning:%m
set noswapfile
set shortmess=aoOtI
set cmdheight=2
set shortmess+=T
set hid
set mat=2

filetype plugin on
filetype indent on
"turn on syntax highlighting
syntax on

"call pathogen#runtime_append_all_bundles() 
execute pathogen#infect()
":colo jellyx
":colo xoria256
:colo solarized
set background=dark
set dictionary+=/usr/share/dict/words
:au BufNewFile * silent! 0r  ~/.vim/templates/%:e.tpl
augroup template-plugin
    autocmd User plugin-template-loaded call s:template_keywords()
augroup END

function! s:template_keywords()
    if search('<+FILE_NAME+>')
        silent %s/<+FILE_NAME+>/\=toupper(expand('%:t:r'))/g
    endif
    if search('<+CURSOR+>')
        execute 'normal! "_da>'
    endif
"    silent %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
endfunction


let $PAGER=''
"<F1> is built-in help
nnoremap <F2> :set invpaste paste?<CR>
nmap <F3> :call ChangeFileencoding()<CR>
"map <F4> :bd<CR>
map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
nnoremap <F5> :buffers<CR>:buffer<Space>
"<F6> is unbound
"<F7> is unbound
nnoremap <silent> <F8> :let notabs=!notabs<Bar>:if notabs<Bar>:tabo<Bar>:else<Bar>:tab ball<Bar>:tabn<Bar>:endif<CR>
nnoremap <F9> :make<CR><CR>
nnoremap <F10> :b <C-Z>
" Buffers - explore/next/previous: Alt-F12, F12, Shift-F12.
nnoremap <silent> <M-F12> :BufExplorer<CR>
nnoremap <silent> <S-F12> :bp<CR>
nnoremap <silent> <F12> :bn<CR>

:nnoremap <M-n> :bnext<CR>
:nnoremap <M-p> :bprevious<CR>
" новая вкладка
"nnoremap <C-T> :tabnew<CR>
"inoremap <C-T> <C-O>:tabnew<CR>
"vnoremap <C-T> <ESC>:tabnew<CR>
" предыдущая вкладка
"nnoremap <silent><A-LEFT> gT
"inoremap <silent><A-LEFT> <C-O>gT
"vnoremap <silent><A-LEFT> <ESC>gT
" следующая вкладка
"nnoremap <silent><A-RIGHT> gt
"inoremap <silent><A-RIGHT> <C-O>gt
"vnoremap <silent><A-RIGHT> <ESC>gt
" Переключение буфера
noremap <C-left> :bprev<CR>
noremap <C-right> :bnext<CR> 

nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-PageDown> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <C-PageUp> :tabnext<CR>
"nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
"nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>
let notabs = 1

" Быстрый вызов команды `set list!` - \l
nmap <leader>l :set list!<CR>
" Настраиваем отображения скрытых символов, при включении их отображения:
" tab - два символа для отображения табуляции (первый символ и заполнитель)
" eol - символ для отображения конца строки
" precedes - индикатор продолжения строки в лево
" extends - индикатор продолжения строки в право
"jump to last cursor position when opening a file
""dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
	if &filetype !~ 'svn\|commit\c'
		if line("'\"") > 0 && line("'\"") <= line("$")
			exe "normal! g`\""
			normal! zz
		endif
	end
endfunction

fun! ReadMan()
  " Assign current word under cursor to a script variable:
  let s:man_word = expand('<cword>')
  " Open a new window:
  :exe ":wincmd n"
  " Read in the manpage for man_word (col -b is for formatting):
  :exe ":r!man " . s:man_word . " | col -b"
  " Goto first line...
  :exe ":goto"
  " and delete it:
  :exe ":delete"
  " finally set file type to 'man':
  " :exe ":set filetype=man"
endfun
" Map the K key to the ReadMan function:
map K :call ReadMan()<CR>

let $GROFF_NO_SGR=1



"set wildmenu
"set wcm=<Tab>
"menu Encoding.koi8-r   :e ++enc=koi8-r<CR>
"menu Encoding.windows-1251 :e ++enc=cp1251<CR>
"menu Encoding.ibm-866      :e ++enc=ibm866<CR>
"menu Encoding.utf-8                :e ++enc=utf-8 <CR>
"map <F6> :emenu Encoding.<TAB>
"nnoremap <silent> <F3> ++enc=cp1251<CR>
let g:autofenc_ext_prog_args = "-i -L ru"
let g:enc_index = 0
function! ChangeFileencoding()
  let encodings = ['cp1251', 'koi8-r', 'cp866', 'utf-8']
  execute 'e ++enc='.encodings[g:enc_index].' %:p'
  if g:enc_index >=3
	  let g:enc_index = 0
  else
	  let g:enc_index = g:enc_index + 1
  endif
endf
"autocmd vimenter * NERDTree
"autocmd vimenter * if !argc() | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>
" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
"
" Note: Must allow nesting of autocmds to enable any customizations for quickfix
" buffers.
" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
" (but not if it's already open). However, as part of the autocmd, this doesn't
" seem to happen.
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
" Uncomment below to prevent 'tilde backup files' (eg. myfile.txt~) from being created
"set nobackup

" Uncomment below to cause 'tilde backup files' to be created in a different dir so as not to clutter up the current file's directory (probably a better idea than disabling them altogether)

" Uncomment below to disable 'swap files' (eg. .myfile.txt.swp) from being created
" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
command! -nargs=0 -bar Update if &modified 
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
nnoremap <silent> <C-S> :<C-u>Update<CR>


