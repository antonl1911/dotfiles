call pathogen#infect()
set nocompatible
set number
set ruler
set hlsearch
set dictionary+=/usr/share/dict/words
:au BufNewFile * silent! 0r  ~/.vim/templates/%:e.tpl
let $PAGER=''
let g:signify_vcs_list = [ 'git', 'svn' ]
let g:vc_browse_cache_all = 1
let g:startify_custom_header =
      \ map(split(system('fortune | cowsay'), '\n'), '"   ". v:val') + ['','']
set t_Co=256
":colo jellyx
"colo solarized
colo xoria256

set smarttab
set smartindent
set cursorline

set ff=dos
set switchbuf=usetab
nnoremap <F8> :sbnext<CR>
nnoremap <F9> :QuickRun<CR>
nnoremap <S-F8> :sbprevious<CR>
nnoremap <F2> :set invpaste paste?<CR>
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
map <C-n> :NERDTreeToggle<CR>
":inoremap <c-s> <Esc>:Update<CR>
:nnoremap <F5> :buffers<CR>:buffer<Space>
set pastetoggle=<F2>
set showmode
filetype off
syntax on
filetype plugin indent on

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
nmap <leader>t :set expandtab<CR>:retab<CR>
"
" Shortcut to switch between win and linux style
" nmae <leader>p :set shiftwidth=
" " Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

"turn on syntax highlighting
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

" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
command -nargs=0 -bar Update if &modified 
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
nnoremap <silent> <C-S> :<C-u>Update<CR>

" virtual tabstops using spaces
let my_tab=8
execute "set shiftwidth=".my_tab
execute "set softtabstop=".my_tab
" allow toggling between local and default mode
function! TabToggle()
  if &shiftwidth == g:my_tab
    set shiftwidth=4
    set softtabstop=4
  else
    execute "set shiftwidth=".g:my_tab
    execute "set softtabstop=".g:my_tab
  endif
endfunction
nmap <F10> mz:execute TabToggle()<CR>'z



set tabstop=8 shiftwidth=8 softtabstop=8 expandtab
set expandtab


"=====================================================
" Python-mode settings
"=====================================================
" отключаем автокомплит по коду (у нас вместо него используется jedi-vim)
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
" проверка кода
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
let g:pymode_lint_ignore="E501,W601,C0110"
" провека кода после сохранения
let g:pymode_lint_write = 0

" поддержка virtualenv
let g:pymode_virtualenv = 1

" установка breakpoints
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = '<leader>b'

" подстветка синтаксиса
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" отключить autofold по коду
let g:pymode_folding = 0


"=====================================================
" Languages support
"=====================================================
" --- Python ---
autocmd FileType python set completeopt-=preview " раскомментируйте, в случае, если не надо, чтобы jedi-vim показывал документацию по методу/классу
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8
\ formatoptions+=croq softtabstop=4 smartindent
\ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
" Disable choose first function/method at autocomplete
let g:jedi#popup_select_first = 0
