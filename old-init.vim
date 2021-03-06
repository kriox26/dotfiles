" .nvimrc configuration by Matias Pan - <matias.pan26@gmail.com>
" Github account: https://github.com/kriox26
"=======================================================================
"     Index
" 1 -- Vim-plug
" 2 -- General settings
" 3 -- Graphical configs
" 4 -- Search configs
" 5 -- Statusbar
" 6 -- Helpers and functions
" 7 -- Navigation keymaps
" 8 -- Other keymaps and abbrev
" 9 -- Plugins configs
"
"=========================================================
"         Vim-plug 					 "
"=========================================================

" Vim-plug list of plugins - {{{
filetype off
call plug#begin('~/.local/share/nvim/plugged')

Plug 'kaicataldo/material.vim'
Plug 'Valloric/ListToggle'
Plug 'KeitaNakamura/neodark.vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'arcticicestudio/nord-vim'
Plug 'ryanoasis/vim-devicons'
Plug 'jiangmiao/auto-pairs'
Plug 'neomake/neomake'
Plug 'fatih/vim-go'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'mattn/gist-vim'
Plug 'tpope/vim-surround'
Plug 'vim-ruby/vim-ruby'
Plug 'kien/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'sebdah/vim-delve'
Plug 'janko-m/vim-test'
Plug 'terryma/vim-multiple-cursors'
Plug 'Shougo/neoyank.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'SirVer/ultisnips'
Plug 'rhysd/nyaovim-mini-browser'
Plug 'honza/vim-snippets'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'mattn/webapi-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'vimlab/split-term.vim'
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'Shougo/denite.nvim', { 'do': function('DoRemote') }

call plug#end()
" }}}

"=========================================================
"         General settings           "
"=========================================================

" Enable pipe shape cursor when in insert mode
  set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor


"Map leader key to ,
  let mapleader = ","

"Open your .nvimrc with this key map
  nnoremap <leader>en :vsplit $MYVIMRC<return>

"Basic configs
  set number
  set hidden
  set ttimeout
  set ttimeoutlen=20
  set notimeout
  set backspace=indent,eol,start
  set completeopt=menu,menuone,noinsert,noselect
  set nobackup
  set noswapfile
  set scrolljump=20
  set autoread
  set mouse=a
  set clipboard+=unnamedplus

"Set tab indent, 2 spaces
  set autoindent
  set smartindent
  set softtabstop=0
  set tabstop=8
  set shiftwidth=8
  set noexpandtab
  set smarttab
  filetype on
  filetype plugin indent on
  set inccommand=split


" Autocmd sections for specific filetypes and buffer events -------- {{{
" Only do this part when compiled with support for autocommands.
  if has("autocmd")
    " Enable file type detection.
    syntax enable
    " Also load indent files, to automatically do language-dependent indenting.
    autocmd BufWritePost,BufNewFile * Neomake
    augroup filetypes
      autocmd!
      autocmd FileType vim setlocal foldmethod=marker
    augroup END
    augroup sourcing_and_buffers
      autocmd!
      "Source .nvimrc after writing it, reloads nvim
      autocmd FileType java setlocal omnifunc=javacomplete#Complete
      autocmd FileType html set ft=eruby
      autocmd BufWritePost .nvimrc source %
      au! BufNewFile,BufRead *.applescript   setf applescript
      autocmd BufRead,BufNewFile *.scss set filetype=scss.css
      autocmd BufNewFile,BufRead *.json set ft=javascript
      autocmd BufRead,BufNewFile *.rb,*.json,*.yml,*.html setlocal tabstop=2|setlocal shiftwidth=2
      autocmd BufRead,BufNewFile *.tmpl set filetype=html
      autocmd BufRead,BufNewFile *.js,*.jsx,*.sh setlocal tabstop=4|setlocal shiftwidth=4
      autocmd BufNewFile,BufRead *.pas,*.pascal set syntax=pascal|setlocal shiftwidth=4|setlocal tabstop=4
      " jump to last known position of each buf
      autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
    augroup END
  endif " has("autocmd")
" }}}

"=========================================================
"         Graphical configs          "
"=========================================================

" colorscheme hlsearch ---- {{{
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
  if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
  endif

  if (has("termguicolors"))
    set termguicolors
  endif
  set background=dark
  colorscheme material
  let g:material_terminal_italics = 1
  " let g:deepspace_italics = 1

" }}}

"=========================================================
"         Search configs             "
"=========================================================

" do incremental searching
  set incsearch

"Ag global configs, ctrlp also --- {{{

"PyMatcher for CtrlP
  if has("python")
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
  endif

"Ag for searching files
  if executable('ag')
    "Use ag over grep
    set grepprg=ag\ --nogroup
    let g:grep_cmd_opts = '--line-numbers --noheading'
    " let g:ctrlp_user_command = 'ag %s -l -g \""'
    "Use ag in CtrlP for listing files. Faster than grep and respects
    ".gitignore
    let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --ignore ''.git'' --ignore ''.DS_Store'' --ignore ''node_modules'' --ignore ''log'' --hidden -g ""'
  endif

"bind K to search word under cursor
  nnoremap <leader>K :Ag! <C-R><C-W><CR>

" Do not clear filenames cache, to improve CtrlP startup
" You can manualy clear it by <F5>
  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_max_files = 0
  let g:ctrlp_max_height =  25
  let g:ctrlp_match_window = 'results:100' " overcome limit imposed by max height
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](node_modules|vendor)|(\.(git|hg|svn|log))$',
    \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
     \}
  " Use the nearest .git directory as the cwd
  let g:ctrlp_working_path_mode = 'ra'
  nnoremap <leader>. :CtrlPTag<cr>

"This makes CtrlP faster
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip
" }}}

"=========================================================
"         Statusbar config           "
"=========================================================

"Always show statusline
  set laststatus=2
  if has("gui_running")
	  set laststatus=0
  endif

"Airline and neomake global variables setup ------------------ {{{
"airline configurations
  let g:airline_powerline_fonts = 1
  let g:airline_theme= 'neodark'
  let g:airline#extensions#tabline#enabled=0 "Show line of opened buffers at top of screen
  let g:airline#extensions#neomake#enabled = 1  "Enable syntastic
  let g:airline#extensions#whitespace#enabled = 0
  let g:airline#extensions#neomake#error_symbol='✖ '
  let g:airline#extensions#neomake#warning_symbol="⚠ "
" }}}

"=========================================================
"         Functions and helpers        "
"=========================================================

"functions to show highligting groups for current word, underline current line, and bring a shell command output to a buffer - {{{
"Show highlighting groups for current word with leader + f + s, usefull when having miss syntax highlight
  nmap <leader>hg :call <SID>SynStack()<CR>
  function! <SID>SynStack()
    if !exists("*synstack")
      return
    endif
    echo map(synstack(line('.'),col('.')),'synIDattr(v:val, "name")')
  endfunc

"Underlines current line with =, ", or *
  function! s:Underline(chars)
    let chars = empty(a:chars) ? '=' : a:chars
    let nr_columns = virtcol('$') - 1
    let uline = repeat(chars, (nr_columns / len(chars)) + 1)
    put =strpart(uline, 0, nr_columns)
  endfunction
  command! -nargs=? Underline call s:Underline(<q-args>)

  command! -nargs=* -complete=file -bang Rename call Rename(<q-args>, '<bang>')

  function! Rename(name, bang)
    let l:name    = a:name
    let l:oldfile = expand('%:p')

    if bufexists(fnamemodify(l:name, ':p'))
      if (a:bang ==# '!')
        silent exe bufnr(fnamemodify(l:name, ':p')) . 'bwipe!'
      else
        echohl ErrorMsg
        echomsg 'A buffer with that name already exists (use ! to override).'
        echohl None
        return 0
      endif
    endif

    let l:status = 1

    let v:errmsg = ''
    silent! exe 'saveas' . a:bang . ' ' . l:name

    if v:errmsg =~# '^$\|^E329'
      let l:lastbufnr = bufnr('$')

      if expand('%:p') !=# l:oldfile && filewritable(expand('%:p'))
        if fnamemodify(bufname(l:lastbufnr), ':p') ==# l:oldfile
          silent exe l:lastbufnr . 'bwipe!'
        else
          echohl ErrorMsg
          echomsg 'Could not wipe out the old buffer for some reason.'
          echohl None
          let l:status = 0
        endif

        if delete(l:oldfile) != 0
          echohl ErrorMsg
          echomsg 'Could not delete the old file: ' . l:oldfile
          echohl None
          let l:status = 0
        endif
      else
        echohl ErrorMsg
        echomsg 'Rename failed for some reason.'
        echohl None
        let l:status = 0
      endif
    else
      echoerr v:errmsg
      let l:status = 0
    endif

    return l:status
  endfunction
" }}}

"=========================================================
"         Navigation keymaps           "
"=========================================================

" Windows resizing, tab-buffer navigation and some other stuffs --- {{{
"Visual mode pressing * or # searches for the current selection
  vnoremap <silent> *:call VisualSelection('f')<CR>
  vnoremap <silent> #:call VisualSelection('b')<CR>

"; instead of : for command mode
  nnoremap ; :

"Leader + ct is :checktime for updating current buffer
  nnoremap <leader>ct :checktime<return>

"Maps for windows resize
  nnoremap <silent> <leader>= :exe "resize " . (winheight(0) * 3/2)<CR>
  nnoremap <silent> <leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
  nnoremap <silent> <leader>] :vertical resize +5<CR>
  nnoremap <silent> <leader>[ :vertical resize -5<CR>

"For terminal mode and window navigation
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
  map <C-h> <C-w>h

"set tt for entering Terminal mode, tv for vertical split, and th for
"horizontal split
  nnoremap tt :terminal<return>
  nnoremap tv :VTerm<return>
  nnoremap th :Term<return>

"Tabs and buffer manipulation
  nnoremap }t :tabn<return>
  nnoremap {t :tabp<return>
  nnoremap }b :bn<return>
  nnoremap {b :bp<return>
  nnoremap <leader>v :b#<CR><return>
  nnoremap <leader>bd :bd!<return>
  nnoremap <leader>bc :close<return>

" }}}

"=========================================================
"         Other keymaps and abbrev       "
"=========================================================

" Keymaps for simple things ---- {{{

  set tags=.git/tags

"Focus on the current pane
  nnoremap <silent> <leader>o :on<return>

"some mappings
  inoremap jk <esc>
  nnoremap <silent> <esc>k :noh<return>
  inoremap <Down> <NOP>
  inoremap <Up> <NOP>
  inoremap <Left> <NOP>
  inoremap <Right> <NOP>
  noremap <Down> ddp
  noremap <Up> ddkP
  noremap <Left> <<<esc>
  noremap <Right> >><esc>

"Upcase inner word in normal or insert mode with control + u
  inoremap <c-u> <Esc>gUiw
  nnoremap <c-u> gUiw
" }}}

"=========================================================
"         Plugins config             "
"=========================================================

"keymaps, global variables definition for plugins(Fugitive, ultisnips, CtrlP, gist, multicursor, startify, etc) -- {{{
"✖
  let g:neomake_error_sign   = {'text': '✖', 'texthl': 'airline_x_red'}
  let g:neomake_warning_sign = {'text': '⚠ ', 'texthl': 'GitGutterChange'}
  let g:neomake_message_sign = {'text': '➤', 'texthl': 'airline_c_bold'}
  let g:neomake_info_sign    = {'text': 'ℹ', 'texthl': 'VisualNC'}
  let g:neomake_open_list=2
  let g:neomake_go_enabled_makers = [ 'go', 'gometalinter' ]
  let g:neomake_go_gometalinter_maker = {
    \ 'args': [
    \   '--enable-gc',
    \   '--concurrency=3',
    \   '--fast',
    \   '-D', 'aligncheck',
    \   '-D', 'test',
    \   '-D', 'dupl',
    \   '-D', 'gocyclo',
    \   '-D', 'gotype',
    \   '-E', 'errcheck',
    \   '-E', 'unused',
    \   '-E', 'vet',
    \   '%:p:h',
    \ ],
    \ 'append_file': 0,
    \ 'errorformat':
    \   '%E%f:%l:%c:%trror: %m,' .
    \   '%W%f:%l:%c:%tarning: %m,' .
    \   '%E%f:%l::%trror: %m,' .
    \   '%W%f:%l::%tarning: %m'
    \ }
  nnoremap <leader>lo :lopen<CR>
  nnoremap <leader>lc :l<CR>

"Deoplete stuff
  set runtimepath+=~/.local/share/nvim/plugged/deoplete.nvim
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#disable_auto_complete = 0
  let g:deoplete#max_list = 100
  let g:deoplete#max_menu_width = 20
  " Disable deoplete when in multi cursor mode
  function! Multiple_cursors_before()
      let b:deoplete_disable_auto_complete = 1
  endfunction
  function! Multiple_cursors_after()
      let b:deoplete_disable_auto_complete = 0
  endfunction


"Fugitive plugin keymaps for basic git operations:
  nnoremap <leader>ls :Gstatus<return>
  nnoremap <leader>lc :Gcommit<return>
  nnoremap <leader>ll :Git log --oneline --abbrev-commit --graph --decorate --all<return>
  nnoremap <leader>lw :Gwrite<return>

"Call :StripWhitespace with <leader>sw
  nnoremap <leader>sw :StripWhitespace<return>

"Gist plugin configs
  let g:gist_clip_command = 'pbcopy'
  let g:gist_detect_filetype = 1
  let g:gist_open_browser_after_post = 1
  let g:gist_update_on_write = 1
  nnoremap <leader>hg :Gist<return>

"Maps for vim-multiple cursor
  let g:multi_cursor_next_key='<C-n>'
  let g:multi_cursor_skip_key='<C-x>'
  let g:multi_cursor_quit_key='<Esc>'
  let g:multi_cursor_select_all_word_key='<C-w><C-n>'

"Set control + e to sparkup completion
  let g:sparkupExecuteMapping='<C-e>'
  let g:sparkupMappingInsertModeOnly='1'

"Disable hunks
  nmap ]h <Plug>GitGutterNextHunk
  nmap [h <Plug>GitGutterPrevHunk
  let g:airline#extensions#hunks#enabled = 0
  let g:gitgutter_override_sign_column_highlight = 0
  let g:gitgutter_map_keys = 0
  let g:gitgutter_sign_added = '│'
  let g:gitgutter_sign_modified = '│'
  let g:gitgutter_sign_removed = '│'
  let g:gitgutter_sign_removed_first_line = '│'
  let g:gitgutter_sign_modified_removed = '│'

"vim-test
  let g:test#strategy = 'neovim'
  nmap <silent> <leader>tn :TestNearest<CR>
  nmap <silent> <leader>tf :TestFile<CR>
  nmap <silent> <leader>ts :TestSuite<CR>
  nmap <silent> <leader>tl :TestLast<CR>

"NERDTree
  nnoremap <F7> :NERDTreeToggle<CR>

"Go configs
  let g:go_addtags_transform = "snakecase"
  let g:go_auto_sameids = 0
  let g:go_highlight_extra_types = 1
  let g:go_highlight_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_build_constraints = 1
  let g:go_highlight_function_calls = 1
  let g:go_fmt_command = "goimports"
  let g:go_term_mode = "split"
  let g:go_term_enabled = 1
  let g:go_test_timout = 40
  let g:go_auto_type_info = 1
  let g:go_info_mode = 'gocode'
  let g:deoplete#sources#go#use_cache = 1
  au FileType go nmap gd <Plug>(go-def-split)
  au FileType go nmap <leader>gd <Plug>(go-doc)
  au FileType go nmap <leader>gi <Plug>(go-implements)
  au FileType go nmap <leader>gf <Plug>(go-info)
  au FileType go nmap <leader>gn <Plug>(go-rename)
  au FileType go nmap <leader>gv <Plug>(go-run-vertical)
  au FileType go nmap <leader>gt <Plug>(go-test)
  au FileType go nmap <leader>gb <Plug>(go-describe)
  au FileType go nmap <leader>gr <Plug>(go-referrers)
  au FileType go nmap <leader>ge <Plug>(go-whicherrs)
  au FileType go nmap <Leader>gg <Plug>(go-coverage-toggle)
  nnoremap <leader>gd :GoDeclsDir<CR>
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

"Denite
  nnoremap <space>y :Denite neoyank<cr>
  nnoremap <space>/ :Denite grep<cr>
  nnoremap <space>p :Denite file_rec<cr>
  nnoremap <space>s :Denite buffer<cr>

  "NERDcommenter
  let g:NERDSpaceDelims = 1
  let g:NERDCompactSexyComs = 1
  nnoremap gc <plug>NERDCommenterToggle

"split-term
  set splitright

"Ultisnips
  let g:UltiSnipsExpandTrigger="<c-j>"
  let g:UltiSnipsJumpForwardTrigger="<c-l>"
  let g:UltiSnipsJumpBackwardTrigger="<c-z>"

  let g:lt_location_list_toggle_map = '<leader>lt'
  let g:lt_quickfix_list_toggle_map = '<leader>q'
" }}}
