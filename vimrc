let g:airline_powerline_fonts = 0
let g:airline_left_sep=''
let g:airline_right_sep=''

set encoding=utf-8

set nocompatible              " be iMproved, required

if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'VundleVim/Vundle.vim' " Required by Vundle, must be first
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'ervandew/supertab'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
if has('macunix')
  Plug 'zerowidth/vim-copy-as-rtf'
endif
Plug 'joukevandermaas/vim-ember-hbs'
Plug 'dense-analysis/ale'
Plug 'yegappan/lsp'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
Plug 'danielwe/base16-vim'
Plug 'tpope/vim-fugitive'
Plug 'ruanyl/vim-gh-line'
Plug 'tpope/vim-surround'
Plug 'alvan/vim-closetag'
" Use leader-cc to comment out visual selected blocks
Plug 'scrooloose/nerdcommenter'
" see https://github.com/easymotion/vim-easymotion
Plug 'easymotion/vim-easymotion'

" see https://github.com/christoomey/vim-tmux-navigator
Plug 'christoomey/vim-tmux-navigator'
" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

call plug#end()

" --- ALE (linting and fixing) ---
" ALE handles eslint, prettier, and ember-template-lint.
" LSP diagnostics are forwarded from yegappan/lsp via aleSupport.
let g:ale_linters = {
\   'typescript': ['eslint'],
\   'typescriptreact': ['eslint'],
\   'javascript': ['eslint'],
\   'javascriptreact': ['eslint'],
\   'handlebars': ['ember-template-lint'],
\ }
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'typescript': ['prettier', 'eslint'],
\   'typescriptreact': ['prettier', 'eslint'],
\   'javascript': ['prettier', 'eslint'],
\   'javascriptreact': ['prettier', 'eslint'],
\ }
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_skip_empty_sections = 1

" --- yegappan/lsp (LSP client for tsserver) ---
let lspOpts = #{
\   autoHighlightDiags: v:true,
\   aleSupport: v:true,
\ }
autocmd User LspSetup call LspOptionsSet(lspOpts)

let lspServers = [#{
\     name: 'typescript-language-server',
\     filetype: ['typescript', 'typescriptreact', 'javascriptreact'],
\     path: exepath('typescript-language-server'),
\     args: ['--stdio'],
\   },
\ ]

autocmd User LspSetup call LspAddServer(lspServers)

" Glimmer TypeScript/JavaScript (.gts/.gjs) filetype detection
" Uses typescriptreact/javascriptreact so tsserver provides LSP features
" (hover, go-to-def, etc.). Glint V2's language server uses custom Volar.js
" protocol extensions incompatible with generic LSP clients.
" tsserver doesn't understand <template> blocks so it produces many false
" positive diagnostics. ALE is disabled for these buffers; use ember-tsc
" (below) for type checking instead.
autocmd BufNewFile,BufRead *.gts set filetype=typescriptreact | let b:ale_enabled = 0
autocmd BufNewFile,BufRead *.gjs set filetype=javascriptreact | let b:ale_enabled = 0

" Pre-save type check for .gts/.gjs files using ember-tsc.
" ember-tsc understands <template> blocks; regular tsc does not.
" Errors go to the location list (per-window, not the global quickfix).
" Use :lopen to view errors, :lnext/:lprev to navigate.
function! s:EmberTscCheck()
  let l:dir = expand('%:p:h')
  let l:ember_tsc = findfile('node_modules/.bin/ember-tsc', l:dir . ';')
  if empty(l:ember_tsc)
    return
  endif
  let l:ember_tsc = fnamemodify(l:ember_tsc, ':p')
  let l:output = system(l:ember_tsc . ' --noEmit 2>&1')
  if v:shell_error
    lexpr l:output
    echo 'ember-tsc: errors found (:lopen to view)'
  else
    lclose
    call setloclist(0, [])
    echo 'ember-tsc: ok'
  endif
endfunction
autocmd BufWritePost *.gts,*.gjs call s:EmberTscCheck()

" center the cursor in the screen vertically
set scrolloff=10000

let mapleader = ";"

" Mitch setting, in normal mode , is valid leader
" nmap , ;

" inoremap <leader>j <Esc>
" vnoremap <leader>j <Esc>
" nnoremap <leader>j <Nop>
inoremap <leader>w <Esc>:w<CR>
vnoremap <leader>w <Esc>:w<CR>

noremap <leader>q :q<CR>
noremap <leader>!q :q!<CR>
noremap <leader>w :w<CR>
noremap <leader>!w :w!<CR>

noremap <C-h> <C-W>h
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-l> <C-W>l

" prev buffer
noremap <leader>s :b#<CR>

" ctrl-p
" noremap <leader>t :CtrlP<CR>

" Open buffers
" noremap <leader>b :CtrlPBuffer<CR>

" leader-f opens Ag searching
let g:ackprg = 'ag --vimgrep --ignore bower_components --ignore node_modules --ignore tmp --ignore dist'
noremap <leader>f :Ack! 

" mappings for fugitive
" leader-gs opens git status
noremap <leader>gs :Git status<CR>
" leader-gc opens git commit
noremap <leader>gc :Git commit<CR>
" leader-gb opens git blame
noremap <leader>gb :Git blame<CR>

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! CheckIfCurrentBufferIsFile()
  return strlen(expand('%')) > 0
endfunction

function! ToggleTree()
  if CheckIfCurrentBufferIsFile()
    if IsNERDTreeOpen()
      NERDTreeClose
    else
      NERDTreeFind
    endif
  else
    NERDTree
  endif
endfunction

" leader-d toggles NERDTree drawer
noremap <leader>d :call ToggleTree()<CR>
noremap <leader>x :NERDTreeFind<CR>

" redraw the screen
noremap <leader>r :redraw!<CR>

" vertical bar
" set cc=81

" Taken from unimpaired paste plugin
" Type "yo" or "yO" to switch to insert mode with "paste" set on the line below/above
" Exiting insert mode exits paste mode
" See https://github.com/tpope/vim-unimpaired/blob/master/plugin/unimpaired.vim#L239-L260
function! s:setup_paste() abort
  let s:paste = &paste
  let s:mouse = &mouse
  set paste
  set mouse=
  augroup unimpaired_paste
    autocmd!
    autocmd InsertLeave *
          \ if exists('s:paste') |
          \   let &paste = s:paste |
          \   let &mouse = s:mouse |
          \   unlet s:paste |
          \   unlet s:mouse |
          \ endif |
          \ autocmd! unimpaired_paste
  augroup END
endfunction

nnoremap <silent> <Plug>unimpairedPaste :call <SID>setup_paste()<CR>
nnoremap <silent> yo  :call <SID>setup_paste()<CR>o
nnoremap <silent> yO  :call <SID>setup_paste()<CR>O

" 2-space indentation and filetype for for less
au BufNewFile,BufReadPost *.less setl shiftwidth=2 filetype=css expandtab

" md wrap at 80 chars
au BufRead,BufNewFile *.md setlocal textwidth=80

" Highlight matched search teams
:set hlsearch
" Clear highlighted search terms by hitting return
:nnoremap <CR> :nohlsearch<cr>
" Restore default <CR> and add 'o' in quickfix/location list windows
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
autocmd BufReadPost quickfix nnoremap <buffer> o <CR>

" Better case searching
" http://linuxcommando.blogspot.com/2008/06/smart-case-insensitive-incremental.html
set ignorecase
set smartcase
set incsearch

" Make sure cursorlines appear when swapping buffers
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END
highlight  CursorLine cterm=None ctermbg=236

" Drop the underline on current line number
hi CursorLineNR cterm=none
augroup CLNRSet
    autocmd! ColorScheme * hi CursorLineNR cterm=none
augroup END


" use ag instead of ack https://github.com/ggreer/the_silver_searcher
" let g:ackprg = 'ag --nogroup --nocolor --column'

set guifont=Inconsolata\ 16
set modelines=1

set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab
set ruler
set number
set signcolumn=yes
set numberwidth=3
set backspace=2
set vb t_vb=
set guioptions-=T

set undofile

syn on
" Stop vim trying to syntax highlight long lines, typically found in minified
" files. This greatly reduces lag yet is still wide enough for large
" displays
set synmaxcol=500

" With :set hidden, opening a new file when the current buffer has unsaved
" changes causes files to be hidden instead of closed
set hidden
set autoread
au FocusGained,BufEnter * :checktime

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-p>"
    endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

set laststatus=2

" set wildignore+=*/tmp/*,*/node_modules/*,*/bower_components/*,*.so,*.swp,*.zip
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " Linux/MacOSX"

" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" viminfo stores the the state of your previous editing session
set viminfo+=n~/.vim/viminfo

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif


let g:airline#extensions#branch#enabled = 0
let g:airline_theme='base16'

" Enable mouse, option-click for normal clicks
set mouse=a

" LSP keybindings
autocmd FileType typescript,typescriptreact,javascriptreact nmap <buffer> t :LspHover<CR>
autocmd FileType typescript,typescriptreact,javascriptreact noremap <buffer> <C-]>d :LspGotoDefinition<CR>
autocmd FileType typescript,typescriptreact,javascriptreact noremap <buffer> <C-]>t :LspGotoTypeDef<CR>
autocmd FileType typescript,typescriptreact,javascriptreact noremap <buffer> <C-]>r :LspShowReferences<CR>

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

if exists('$BASE16_THEME')
    \ && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
  let base16colorspace=256
  colorscheme base16-$BASE16_THEME
endif

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

command! -bang -nargs=? -complete=dir 
  \ ProjectFiles call fzf#vim#files(<q-args>, {'source': (executable('fdfind') ? 'fdfind' : 'fd')}, <bang>0)

let g:fzf_action = {
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit'
    \ }
noremap <leader>t :ProjectFiles<CR>
noremap <leader>b :History<CR>
noremap <leader>r :RG<CR>
augroup fzf
  autocmd!
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

let g:prettier#autoformat_config_present = 0
let g:prettier#autoformat_require_pragma = 0
let g:prettier#autoformat_config_files = ['.prettierrc.js']
let g:prettier#quickfix_enabled = 1

" --- Splash Screen ---

function! SplashContent()
  let l:lines = []
  call add(l:lines, '  ╻ ╻   ╻   ┏┳┓')
  call add(l:lines, '  ┃┏┛   ┃   ┃┃┃')
  call add(l:lines, '  ┗┛    ╹   ╹ ╹')
  call add(l:lines, '')
  call add(l:lines, '  FILES & NAVIGATION              SEARCH')
  call add(l:lines, '  ;t  fuzzy find files             ;r  ripgrep search (live)')
  call add(l:lines, '  ;b  recent files/buffers         ;f  Ack (ag) search')
  call add(l:lines, '  ;d  toggle NERDTree at file      Enter  clear search highlight')
  call add(l:lines, '  ;x  NERDTree find current')
  call add(l:lines, '  ;s  swap to previous buffer')
  call add(l:lines, '')
  call add(l:lines, '  SAVE & QUIT                     SPLITS & WINDOWS')
  call add(l:lines, '  ;w  save   ;!w  force save      C-h/j/k/l  move between splits')
  call add(l:lines, '  ;q  quit   ;!q  force quit      C-s  open in split (fzf)')
  call add(l:lines, '                                  C-v  open in vsplit (fzf)')
  call add(l:lines, '')
  call add(l:lines, '  GIT / FUGITIVE                  EASYMOTION')
  call add(l:lines, '  ;gs  git status                  ;;w  jump to word forward')
  call add(l:lines, '  ;gc  git commit                  ;;b  jump to word backward')
  call add(l:lines, '  ;gb  git blame                   ;;f{c}  find char forward')
  call add(l:lines, '                                   ;;j  jump to line below')
  call add(l:lines, '  Status window keys:              ;;k  jump to line above')
  call add(l:lines, '  s stage  u unstage  = toggle')
  call add(l:lines, '  - toggle  cc commit  X discard')
  call add(l:lines, '  g? help  dv diff split')
  call add(l:lines, '')
  call add(l:lines, '  COMMENTS / NERDCommenter         SURROUND')
  call add(l:lines, '  ;cc  comment line/selection       cs({  change surround ( to {')
  call add(l:lines, '  ;cu  uncomment                    ds"   delete surrounding "')
  call add(l:lines, '  ;c<Space>  toggle comment         ysiw] surround word with []')
  call add(l:lines, '  ;ci  invert comments              S" in visual  wrap with "')
  call add(l:lines, '  ;cs  sexy comment (block)')
  call add(l:lines, '')
  call add(l:lines, '  PASTE MODE                       LSP (TS/TSX/JSX)')
  call add(l:lines, '  yo  paste below (auto-unpaste)   t      hover info')
  call add(l:lines, '  yO  paste above (auto-unpaste)   C-]d   go to definition')
  call add(l:lines, '                                   C-]t   go to type def')
  call add(l:lines, '  :CopyRTF  copy buffer as RTF     C-]r   show references')
  call add(l:lines, '  >  auto-close HTML tags')
  call add(l:lines, '')
  call add(l:lines, '              Press any key to dismiss')
  return l:lines
endfunction

function! CheatSheetFilter(winid, key)
  if a:key ==# "\<CursorHold>" || a:key[0] ==# "\x80"
    return 0
  endif
  call popup_close(a:winid)
  return 1
endfunction

function! ShowCheatSheet()
  call popup_create(SplashContent(), #{
    \ title: ' Keybindings ',
    \ pos: 'center',
    \ border: [],
    \ borderchars: ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
    \ padding: [1, 2, 1, 2],
    \ filter: 'CheatSheetFilter',
    \ mapping: 0,
    \ minwidth: 60,
    \ maxheight: &lines - 4,
    \ scrollbar: 1,
    \ highlight: 'Normal',
    \ borderhighlight: ['Comment'],
    \ })
endfunction

augroup SplashScreen
  autocmd!
  autocmd VimEnter * if argc() == 0 && line2byte('$') == -1 | call ShowCheatSheet() | endif
augroup END

nnoremap <silent> <leader> :<C-u>call ShowCheatSheet()<CR>
