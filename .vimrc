call pathogen#runtime_append_all_bundles() 
set nocompatible
set dictionary+=/usr/share/dict/words
:au BufNewFile * silent! 0r  ~/.vim/templates/%:e.tpl
let $PAGER=''
:set t_Co=256
":colo jellyx
:colo solarized
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set cursorline
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
filetype plugin on
filetype indent on

"turn on syntax highlighting
syntax on
set wildmode=longest,list,full
set wildmenu
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

