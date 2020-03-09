" TODO: 改掉Leader插件那里安装的特定tag(之前因为最新版会报错才指定了特定版本)
" 只考虑NeoVim，不一定兼容Vim
"
" 我所理解的Vim哲学:
"   1. 抓住主要问题, 用相对简单和有意义的按键映射出现频率高的操作, 而非常冷门的操作不设置快捷键，可以考虑用别的方式替代
"   2. 最小表达力原则: 用尽可能简单的方式组合来完成复杂的需求, 比如easy-motion插件有很多功能，
"      但其实<Plug>(easymotion-bd-f)就足以胜任日常快速移动所需要的绝大部分功能, 过多的快捷键及功能反而会是干扰
"
" 键位设计原则:
"   1. 有意义，容易记忆.
"   2. 每个指令均衡左右手指击键, 如果都在同一手上则尽量用不同的手指击键，尽量减小手指移动距离
"
"  推荐使用appimage来安装neovim，这样在每个平台都很方便使用
"==========================================
" 【依赖说明】{{{
"  coc.nvim补全插件需要安装node.js和npm LeaderF依赖Python3, vista依赖global-ctags
"}}}
"==========================================
" 【必做事项】{{{
"  1. :PlugInstall
"  2. 提供python和系统剪切板支持 sudo pip3 install pynvim && apt install xsel
"  3. rm -rf ~/.viminfo 这样可以使自动回到上次编辑的地方功能生效, 然后重新打开vim(注意要以当前用户打开),vim会自动重建该文件.
"  4. :CocInstall coc-snippets coc-json coc-html coc-css coc-tsserver coc-python coc-tabnine coc-lists coc-explorer coc-yank
"  5. ubuntu下用snap包管理器安装ccls, 作为C、C++的LSP (推荐用snap安装, 因为ccls作者提供的编译安装方式似乎有问题, 反正Ubuntu18.04不行)
"  6. 安装Sauce Code Pro Nerd Font Complete字体(coc-explorer要用到), 然后设置终端字体为这个, 注意不是原始的Source Code Pro), 最简单的安装方法就是下载ttf文件然后双击安装
"  7. 需要在/etc/crontab设置以下定时任务，定期清理undofile
"{{{
"     # m h  dom mon dow   command
"     43 00 *   *   3     find /home/{username}/.vim/undo-dir -type f -mtime +90 -delete
"}}}
"  8. 安装gtags(需要>6.63(需要>6.63)) 并用 pygments扩展语言类型
"           在官网下载最新的tar.gz 解压后进入 执行 sudo apt install ncurses-dev && ./configure && make && sudo make install && sudo pip3 install pygments
"  9. ctags(插件vista依赖):
        " sudo apt install software-properties-common && sudo add-apt-repository ppa:hnakamur/universal-ctags && sudo apt update && sudo apt install universal-ctags
"
"  10. 在:CocConfig 写入下面的JSON设置
"{{{
" {
"     // 补全启动时自动选择第一项
"     "suggest.noselect": false,
"     // 补全触发的最少字数
"     "suggest.minTriggerInputLength": 1,
"     "explorer.icon.enableNerdfont": true,
"     "python.jediEnabled": false,
"     // 只显示ale的lint信息, 不显示Coc的
"     "diagnostic.displayByAle": true,
"     "languageserver": {
"         "ccls": {
"             "command": "ccls",
"             "filetypes": ["c", "cpp", "objc", "objcpp"],
"             "rootPatterns": [".ccls", "compile_commands.json", ".git/", ".hg/"],
"             "initializationOptions": {
"                 "cache": {
"                     "directory": "/tmp/ccls"
"                 }
"             }
"         }
"     }
" }
"}}}
"}}}
"==========================================
" 【可选项】{{{
"  1. 终端设置cursor不闪烁, <c-a>全选, <c-c>复制，<m-i>粘贴系统剪切板， 而Vim里面的<m-i>会被终端拦截，所以有相同的效果，
"          然后在Vim映射<m-p>是粘贴0寄存器的内容. 设置透明终端, 用<leader>tt可以切换透明模式, 设置开启时窗口大小来达到启动max-size的目的
"  2. 然后终端设置General-勾消Show menubar by default in new terminals
"  3. 只能稍微调快一点键盘响应速度，调太快会导致一次按键多次响应
"  4. 静态代码检查linter与排版器formatter（记得先换源）:
"        for javascript
"            sudo npm install -g eslint && sudo npm install -g prettier
"        for python
"            sudo pip install pylint && sudo pip install autopep8
"        for C,CPP
"            sudo apt install cppcheck -y && sudo npm install -g clang-format
"  5. 安装riggrep 配合Leaderf rg使用, 快速搜索文本行:
"            curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb && sudo dpkg -i ripgrep_11.0.2_amd64.deb
"            FIXME: 如果在Leaderf里调用rg出现~/.config文件夹permission deny的情况 就需要 sudo chown -R $USER:$GROUP ~/.config
"  6. 使用vim-signify显示diff，必须要注册好git账户，比如git config --global user.name "username" && git config --global user.email "useremail@qq.com"
"  7.  "coc-tabnine需要设置'ignore_all_lsp': true来加强补全效果
"}}}
" ========================================
" 【必看】配置文件的坑:{{{
"   1. 映射<Plug>(...)必须用递归映射, 否则不生效
"   2. 映射ex命令的时候不能用noremap, 因为这会导致按键出现奇奇怪怪的结果, 应该改成nnoremap
"   3. vimrc文件let语句的等号两边不能写空格, 写了不生效!
"   4. 单引号是raw String 而双引号才可以转义， 所以设置unicode字体的时候应该用双引号比如"\ue0b0"
"}}}
" ========================================

" ==========================================
" 【可自行调整的重要参数】
let s:enable_file_autosave = 1  " 是否自动保存
set updatetime=400  " 检测CursorHold事件的时间间隔,影响性能的主要因素


let mapleader=' '  " 此条命令的位置应在插件之前
let g:mapleader=' '

" =========================================
" 插件管理
" =========================================
" vim-plug 自动安装
" {{{
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl --insecure -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}

call plug#begin('~/.vim/plugged')

" {{{插件

" 极大增强f和t查找能力 , f<cr>会重复上次搜索的字母, f会自动重复搜索
Plug 'rhysd/clever-f.vim'
let g:clever_f_smart_case = 1  " smart case
let g:clever_f_chars_match_any_signs = 1  " 可以搜索所有的字符,比如;,.
let g:clever_f_repeat_last_char_inputs = ["\<CR>", "\<Tab>"]  " 使用上次的输入
let g:clever_f_mark_char_color = 'MyHack'


" 快速移动
Plug 'easymotion/vim-easymotion'
map <silent> <leader>f <Plug>(easymotion-bd-f)

" 主题配色
Plug 'joshdick/onedark.vim'
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'KeitaNakamura/neodark.vim'
Plug 'trevordmiller/nova-vim'
Plug 'sainnhe/forest-night'

" 快速注释
Plug 'preservim/nerdcommenter'
"{{{
let g:NERDSpaceDelims = 1  " Add spaces after commeqt delimiters by default
let g:NERDDefaultAlign = 'left'  " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDAltDelims_java = 1  " Set a language to use its alternate delimiters by default
let g:NERDTrimTrailingWhitespace = 1  " Enable trimming of trailing whitespace when uncommenting
let g:NERDCommentEmptyLines = 1  " Allow commenting and inverting empty lines (useful when commenting a region)
"}}}
map <c-_> <leader>c<space>
imap <c-_> <esc><c-_>

" 文件树 (现在用的是coc-explorer)
nmap <leader>er :CocCommand explorer<CR>

" COC自动补全框架
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"{{{
set hidden  " 隐藏buff非关闭它, TextEdit might fail if hidden is not set.
set cmdheight=2  " NOTE: 如果不设置为2，每次进入新buffer都需要回车确认...
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set shortmess+=c  " Don't pass messages to ins-completion-menu.
set signcolumn=yes  " Always show the signcolumn, otherwise it would shift the text each time

" Make <tab> used for trigger completion, completion confirm, snippet expand and jump like VSCode.
inoremap <silent> <expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
    " Use `complete_info` if your (Neo)Vim version supports it.
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" NOTE: 这段代码和后面的ScrollAnotherWindow函数耦合性很高,
" 效果是在补全的时候<c-j>是向下，<c-k>是向上, 而之后又设置了在有多个窗口的时候<c-k/j>控制另一个窗口的移动
augroup coc_completion_keybindings
    autocmd!
    autocmd VimEnter * inoremap <silent><expr> <c-j>
        \ pumvisible() ? "\<down>" :
        \ <SID>check_back_space() ? "ScrollAnotherWindow(2)" :
        \ coc#refresh()
    autocmd VimEnter * inoremap <expr> <c-k> pumvisible() ? "\<up>" : "ScrollAnotherWindow(1)"
augroup end

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'


" 展示文档
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"}}}
" 跳转Placeholder的时候自动显示函数签名
" autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" 触发鼠标悬浮事件
nnoremap <silent> gh :call CocActionAsync('doHover')<cr>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap gl :CocList --normal locationlist<cr>
nnoremap gq :CocList --normal quickfix<cr>
nnoremap gm :CocList --normal marks<cr>
" 查看文档
nnoremap <silent> <m-q> :call <SID>show_documentation()<CR>zz
" 打开鼠标位置下的链接
nmap <silent> <leader>re <Plug>(coc-rename)

" coc-translator
nmap ,t <Plug>(coc-translator-p)
vmap ,t <Plug>(coc-translator-pv)

" keymap提示
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
nnoremap <silent> <leader> :WhichKey '<space>'<cr>
nnoremap <silent> , :WhichKey ','<cr>
nnoremap <silent> g :WhichKey 'g'<cr>

" git
Plug 'tpope/vim-fugitive'
nnoremap ,ga :Git add %:p<CR><CR>
nnoremap ,gc :Gcommit --all<cr>
nnoremap ,gd :vert Gdiff<cr>
nnoremap ,gs :vert Gstatus<cr>
nnoremap ,gl :Glog<cr>
nnoremap ,gps :Gpush<cr>
nnoremap ,gpl :Gpull<cr>
nnoremap ,gf :Gfetch<cr>
nnoremap ,gp :Ggrep<Space>
nnoremap ,gm :Gmove<Space>
nnoremap ,gb :Git branch<Space>
nnoremap .go :Git checkout<Space>
nnoremap ,ge :Gedit<CR>
nnoremap ,gr :Gread<CR>
nnoremap ,gw :Gwrite<CR><CR>

" 模糊搜索 弹窗后按<c-r>进行正则搜索模式
Plug 'Yggdroot/LeaderF', { 'tag': 'd6a2c7b94df2e7b65a2009fee01b999004aa9076','do': './install.sh' }
"{{{
let g:Lf_WildIgnore = {
            \ 'dir': ['.svn','.git','.hg','.vscode','.wine','.deepinwine','.oh-my-zsh'],
            \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
            \}

let g:Lf_RgConfig = [
    \ "--max-columns=150",
    \ "--type-add web:*.{html,css,js}*",
    \ "--glob=!git/*",
    \ "--hidden",
    \
\ ]
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2"  }
let g:Lf_PreviewInPopup = 1  " <c-p>预览弹出窗口
let g:Lf_CursorBlink = 0  " 取消光标闪烁
let g:Lf_ShowHidden = 1  " 搜索结果包含隐藏文件
let g:Lf_PopupHeight = 0.7
let g:Lf_HistoryNumber = 200  " default 100
let g:Lf_GtagsAutoGenerate = 1  " 有['.git', '.hg', '.svn']之中的文件时自动生成gtags
let g:Lf_RecurseSubmodules = 1  " show the files in submodules of git repository
let g:Lf_Gtagslabel =  "native-pygments"  " 如果不是gtags支持的文件类型，就用pygments
let g:Lf_WorkingDirectoryMode = 'a'  " the nearest ancestor of current directory that contains one of directories
                                     " or files defined in |g:Lf_RootMarkers|. Fall back to 'c' if no such
                                     " ancestor directory found.
"}}}
let g:Lf_ShortcutF = '<leader>gf'  " 这两项是为了覆盖默认设置的键位
let g:Lf_ShortcutB = '<leader>gb'
let g:Lf_CommandMap = {'<C-]>':['<C-L>']}  " 搜索后<c-h>在右侧窗口打开文件
nnoremap <silent> <leader>gr :Leaderf mru<cr>
nnoremap <leader>gc :Leaderf cmdHistory<cr>
nnoremap <leader>gs :Leaderf searchHistory<cr>
" 当前buffer搜索文本行
" nnoremap <leader>gl :Leaderf line<cr>
"
nnoremap <c-p> :Leaderf command<cr>
" search word under cursor literally in all listed buffers
nnoremap <leader>sb :<C-U><C-R>=printf("Leaderf! rg -F --all-buffers -e %s ", expand("<cword>"))<CR><cr>
" search word under cursor in *.h and *.cpp *.c files.
nnoremap <leader>sc :<C-U><C-R>=printf("Leaderf! rg -e %s -g *.{h,cpp,c}", expand("<cword>"))<CR><cr>

" search visually selected text literally
nnoremap <leader>sw :<C-U><C-R>=printf("Leaderf! rg -F -e %s", expand("<cword>"))<CR><cr>
vnoremap <leader>sv :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR><cr>
nnoremap <leader>rg :<C-U><C-R>=printf("Leaderf! rg -S -e")<CR><space>

" 缩进虚线
Plug 'Yggdroot/indentLine', {'for': 'python'}

" 高亮书签marker
" 取消默认的快捷键{{{
let g:SignatureMap = {
\ 'Leader'             :  "m", 'PlaceNextMark'     :  "",  'ToggleMarkAtLine'   :  "",
\ 'PurgeMarksAtLine'   :  "", 'DeleteMark'         :  "",  'PurgeMarks'         :  "",
\ 'PurgeMarkers'       :  "", 'GotoNextLineAlpha'  :  "",  'GotoPrevLineAlpha'  :  "",
\ 'GotoNextSpotAlpha'  :  "", 'GotoPrevSpotAlpha'  :  "",  'GotoNextLineByPos'  :  "",
\ 'GotoPrevLineByPos'  :  "", 'GotoNextSpotByPos'  :  "",  'GotoPrevSpotByPos'  :  "",
\ 'GotoNextMarker'     :  "", 'GotoPrevMarker'     :  "",  'GotoNextMarkerAny'  :  "",
\ 'GotoPrevMarkerAny'  :  "", 'ListBufferMarks'    :  "",  'ListBufferMarkers'  :  ""
\ }
"}}}
Plug 'kshenoy/vim-signature'

" 实时显示HEX颜色，比如#245984
Plug 'ap/vim-css-color', {'for': ['css']}

" Vim-Surround快捷操作
Plug 'tpope/vim-surround'

" 让. 可以重复插件的操作, 和surround是绝配
Plug 'tpope/vim-repeat'

" uodo历史及持久化
Plug 'simnalamburt/vim-mundo'
" reference: https://vi.stackexchange.com/questions/6/how-can-i-use-the-undofile
" {{{
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile
"}}}
nnoremap <leader>ut :MundoToggle<cr>

" Undo到上次保存前的历史操作(使用undofile时)就发警告来提醒
Plug 'arp242/undofile_warn.vim'

" 拼写检查
Plug 'kamykn/spelunker.vim'
"{{{
highlight SpelunkerComplexOrCompoundWord cterm=underline ctermfg=247 gui=underline guifg=#9e9e9e
" let g:spelunker_check_type = 2  " FIXME 如果打开大文件很慢就尝试开启此项 Spellcheck displayed words in buffer. Fast and dynamic
"}}}

" 使用coc-yank
nnoremap <silent> gy :<C-u>CocList --normal yank<cr>


" 140+种语言的语法高亮包
Plug 'sheerun/vim-polyglot'

" ALE静态代码检查和自动排版
Plug 'dense-analysis/ale'
"{{{
" 不需要指定linters

" 自动排版, 保存时自动删除末尾空白行和行末空格
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\   'javascript': ['prettier'],
\   'python': ['autopep8'],
\}
let g:ale_lint_on_text_changed = 'normal'
" let g:ale_lint_delay = 3000  " 这个配置似乎不生效
" 保存时自动排版
let g:ale_fix_on_save = 1
" 配置状态栏信息
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Note that the C options are also used for C++.
" let g:ale_c_clangformat_options = '-style=google'
" 设置ccls的缓存目录
let g:ale_cpp_ccls_init_options = {
\   'cache': {
\       'directory': '/tmp/ccls/cache'
\   }
\ }
"}}}
" 如果你觉得默认的 ale 提示符不好看，可以修改 ale 提示符使用 emoji 符号，换成萌萌的 emoji 表情
let g:ale_set_highlights = 0  " 不要显示红色下划线
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'
" 切换到normal模式才更新lint信息
nmap <silent> ge <Plug>(ale_next_wrap)
nmap <silent> gE <Plug>(ale_previous_wrap)

" 状态栏
Plug 'itchyny/lightline.vim'
"{{{
" functions
"{{{
function! Sy_stats_wrapper()
  let symbols = ['+', '-', '~']
  let [added, modified, removed] = sy#repo#get_stats()
  let stats = [added, removed, modified]  " reorder
  let hunkline = ''
  for i in range(3)
    if stats[i] > 0
      let hunkline .= printf('%s%s ', symbols[i], stats[i])
    endif
  endfor
  if !empty(hunkline)
    let hunkline = printf('[%s]', hunkline[:-2])
  endif
  return hunkline
endfunction

function! LightlineFugitive()
    if &ft !~? 'vimfiler' && exists('*FugitiveHead')
        return FugitiveHead()
    endif
    return ''
endfunction

function! LightlineFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFileencoding()
    return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

function! Tab_num(n) abort
  return a:n
endfunction

function! RemoveLabelOnTopRight() abort
    " return "\ue61b"
    return ""
endfunction
"}}}

let g:lightline = {'colorscheme' : 'quantum'}
let g:lightline.separator = { 'left': "\ue0b8", 'right': "\ue0be" }
" let g:lightline.subseparator = { 'left': "\ue0b9", 'right': "\ue0b9" }
let g:lightline.tabline_separator = { 'left': "\ue0bc", 'right': "\ue0ba" }
let g:lightline.tabline_subseparator = { 'left': "\ue0bb", 'right': "\ue0bb" }
let g:lightline#ale#indicator_checking = "\uf110 "
let g:lightline#ale#indicator_warnings = "\uf529 "
let g:lightline#ale#indicator_errors = "\uf00d "
let g:lightline#ale#indicator_ok = "\uf00c "
let g:lightline#asyncrun#indicator_none = ''
let g:lightline#asyncrun#indicator_run = 'Running...'
let g:lightline.active = {
        \ 'left': [ [ 'mode', 'paste' ],
        \           [  'filename', 'readonly', 'gitbranch', 'modified'] ,
        \
        \],
        \ 'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
        \            [ 'lineinfo' ],
        \            [ 'asyncrun_status', 'filetype', 'fileformat']
        \          ]
        \ }
let g:lightline.inactive = {
    \ 'left': [ [ 'filename' , 'modified' ] ],
    \ 'right': [ [ 'lineinfo' , 'fileformat', 'filetype'] ]
    \ }
let g:lightline.tabline = {
    \ 'left': [ [ 'vim_logo', 'tabs' ] ],
    \ 'right': [['RemoveLabelOnTopRight']]}
let g:lightline.tab = {
    \ 'active': [ 'filename', 'modified' ],
    \ 'inactive': [ 'filename', 'modified' ] }

let g:lightline.tab_component = {
      \ }
let g:lightline.tab_component_function = {
      \ 'artify_activetabnum': 'Artify_active_tab_num',
      \ 'artify_inactivetabnum': 'Artify_inactive_tab_num',
      \ 'artify_filename': 'Artify_lightline_tab_filename',
      \ 'filename': 'lightline#tab#filename',
      \ 'readonly': 'lightline#tab#readonly',
      \ 'tabnum': 'Tab_num'
      \ }

let g:lightline.component = {
      \ 'artify_mode': '%{Artify_lightline_mode()}',
      \ 'artify_lineinfo': "%2{Artify_line_percent()}\uf295",
      \ 'bufinfo': '%{bufname("%")}:%{bufnr("%")}',
      \ 'vim_logo': "\ue7c5",
      \ 'mode': '%{lightline#mode()}',
      \ 'absolutepath': '%F',
      \ 'relativepath': '%f',
      \ 'filename': ' %t',
      \ 'filesize': "%{HumanSize(line2byte('$') + len(getline('$')))}",
      \ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
      \ 'fileformat': '%{&fenc!=#""?&fenc:&enc}[%{&ff}]',
      \ 'filetype': '%{&ft!=#""?&ft:"no ft"}',
      \ 'paste': '%{&paste?"PASTE":""}',
      \ 'readonly': '%R',
      \ 'charvalue': '%b',
      \ 'charvaluehex': '%B',
      \ 'lineinfo': '%2p%%',
      \ 'percent': '%2p%%',
      \ 'percentwin': '%P',
      \ 'spell': '%{&spell?&spelllang:""}',
      \ 'winnr': '%{winnr()}',
      \ 'close': '%999X X ',
      \ }
let g:lightline.component_function = {
      \   'gitbranch': 'LightlineFugitive',
      \   'modified': 'Sy_stats_wrapper',
      \   'fileencoding': "LightlineFileencoding",
      \   'method': 'NearestMethodOrFunction',
      \ }
let g:lightline.component_expand = {
      \ 'linter_checking': 'lightline#ale#checking',
      \ 'linter_warnings': 'lightline#ale#warnings',
      \ 'linter_errors': 'lightline#ale#errors',
      \ 'linter_ok': 'lightline#ale#ok',
      \ 'RemoveLabelOnTopRight': 'RemoveLabelOnTopRight',
      \ 'asyncrun_status': 'lightline#asyncrun#status',
      \ }

let g:lightline.component_type = {
      \ 'linter_warnings': 'warning',
      \ 'linter_errors': 'error'
      \ }
let g:lightline.component_visible_condition = {
      \ }

"}}}

" ale和lightline插件适配器
Plug 'maximbaz/lightline-ale'

" 启动页面
Plug 'mhinz/vim-startify'
"{{{
let g:startify_lists = [
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ { 'type': 'files',     'header': ['   MRU']            },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ ]
let g:startify_session_persistence = 1  " 持久化session
let g:startify_fortune_use_unicode = 1  " 首页banner使用utf-8字符编码
let g:startify_enable_special = 0  " 不显示<empty buffer> 和 <quit>
let g:startify_session_sort = 1  " Sort sessions by modification time (when the session files were written) rather than alphabetically.
let g:startify_custom_indices = map(range(1,100), 'string(v:val)')  " index从1开始数起
let g:utf8_image = [
            \ '(っ＾▿＾)۶🍸🌟🍺٩(˘◡˘  )',
            \ '',
            \]

let g:utf8_middle_finger = [
            \ '░░░░░░░░░░░░░░░▄▄░░░░░░░░░░░',
            \ '░░░░░░░░░░░░░░█░░█░░░░░░░░░░',
            \ '░░░░░░░░░░░░░░█░░█░░░░░░░░░░',
            \ '░░░░░░░░░░░░░░█░░█░░░░░░░░░░',
            \ '░░░░░░░░░░░░░░█░░█░░░░░░░░░░',
            \ '██████▄███▄████░░███▄░░░░░░░',
            \ '▓▓▓▓▓▓█░░░█░░░█░░█░░░███░░░░',
            \ '▓▓▓▓▓▓█░░░█░░░█░░█░░░█░░█░░░',
            \ '▓▓▓▓▓▓█░░░░░░░░░░░░░░█░░█░░░',
            \ '▓▓▓▓▓▓█░░░░░░░░░░░░░░░░█░░░░',
            \ '▓▓▓▓▓▓█░░░░░░░░░░░░░░██░░░░░',
            \ '▓▓▓▓▓▓█████░░░░░░░░░██░░░░░░',
            \ ]

" I get it from https://fsymbols.com/text-art/
let g:utf8_double_moon = [
            \ '┊┊┊┊      ' . '███████╗██╗     ██╗ ██████╗ ██████╗ ███████╗██████╗ ',
            \ '┊┊┊☆      ' . '██╔════╝██║     ██║ ██╔══██╗██╔══██╗██╔════╝██╔══██╗',
            \ '┊┊🌙  *   ' . '█████╗  ██║     ██║ ██████╔╝██████╔╝█████╗  ██║  ██║',
            \ '┊┊        ' . '██╔══╝  ██║     ██║ ██╔═══╝ ██╔═══╝ ██╔══╝  ██║  ██║',
            \ '┊☆ °      ' . '██║     ███████╗██║ ██║     ██║     ███████╗██████╔╝',
            \ '🌙        ' . '╚═╝     ╚══════╝╚═╝ ╚═╝     ╚═╝     ╚══════╝╚═════╝ ',
            \ ]


let g:startify_custom_header =
            \ 'startify#pad(g:utf8_double_moon)'
"}}}
" Project(Session) index
nnoremap <leader>pi :Startify<cr>
nnoremap <leader>ps :SSave<cr>
nnoremap <leader>pl :SLoad<cr>
nnoremap <leader>pc :SClose<cr>
nnoremap <leader>pd :SDelete<cr>

" 括号配对优化
Plug 'jiangmiao/auto-pairs'
"{{{
" 取消自动在括号内自动加一个空格
let g:AutoPairsMapSpace=0
" 不要在插入模式下映射<c-h>为<backspace>
let g:AutoPairsMapCh=0
" 取消自带快捷键
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutBackInsert = ''

"}}}

" 多彩括号
Plug 'luochen1990/rainbow'
"{{{
let g:rainbow_active = 1
"}}}

" 【可能影响性能】侧栏显示git diff情况(要求vim8+)
Plug 'mhinz/vim-signify'

" coc-snippets是框架,这个是内容
Plug 'honza/vim-snippets'
"
" 自动进入粘贴模式
Plug 'ConradIrwin/vim-bracketed-paste'

" 为内置终端提供方便接口
Plug 'kassio/neoterm'
"{{{
let g:neoterm_use_relative_path = 1
let g:neoterm_autoscroll = 1
let g:neoterm_size = 10  " 调整terminal的大小

function! AutoCompileAndRun() abort
    execute 'botright Topen'
    execute 'Tclear'
    if &filetype == 'python'
        execute 'T python3 %'
    elseif &filetype == 'c'
        execute 'T gcc -Wall -g % -o %.out && ./%.out'
    elseif &filetype == 'cpp'
        execute 'T g++ -Wall -g -std=c++11 % -o %.out && ./%.out'
    elseif &filetype == 'javascript'
        execute 'T node %'
    elseif &filetype == 'java'
        execute 'T javac % && java -enableassertions %:p'
    elseif &ifletype == 'go'
        execute 'T go build % && ./%:p'
    endif
endfunction
"}}}
" 一键运行
nnoremap <leader>rn :call AutoCompileAndRun()<cr>
nnoremap <silent> <m-m> :botright Ttoggle<cr><c-w>w<c-\><c-n>i
" 任何时候进入neoterm都是插入模式
nnoremap <silent> <m-j> :botright Topen<cr><c-w>w<c-\><c-n>i
inoremap <silent> <m-j> <esc>:botright Topen<cr>
" 内置终端
tnoremap <c-d> <c-\><c-n>:Tclose<cr>
tnoremap <m-h> <c-\><c-n><c-w>h
tnoremap <m-l> <c-\><c-n><c-w>l
tnoremap <m-j> <c-\><c-n><c-w>j
tnoremap <m-k> <c-\><c-n><c-w>k<esc>
tnoremap <m-n> <c-\><c-n>
" 粘贴寄存器0的内容到终端
tnoremap <expr> <m-p> '<C-\><C-n>"0pi'
tnoremap <silent> <m-m> <c-\><c-n>:Ttoggle<cr>

" 多光标
Plug 'mg979/vim-visual-multi'

" 异步自动生成tags
Plug 'jsfaint/gen_tags.vim'
let g:loaded_gentags#gtags = 1  " 设1关闭gtags功能, 这样可以关闭警告
let g:loaded_gentags#ctags = 1
let $GTAGSLABEL = 'native-pygments'  " FIXME: 当项目文件的路径包含非ASCII字符时，使用pygments会报UnicodeEncodeError
" let $GTAGSCONF = '/path/to/share/gtags/gtags.conf'

" 浏览tags, 函数，类
Plug 'liuchengxu/vista.vim'
"{{{
let g:vista_default_executive = 'ctags'  " Executive used when opening vista sidebar without specifying it.
let g:vista#renderer#enable_icon = 1  " Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
"}}}
nnoremap <leader>ot :Vista<cr>


" 似乎是vim唯一的test插件, 支持CI
" Plug 'janko/vim-test'

" 新增文本对象
" Plug 'targets.vim'
"
" %匹配对象增强, 建议把%改成m
"Plug 'andymass/vim-matchup'
"
" 类似VSCode的编译/测试/部署 任务工具
"Plug 'skywind3000/asynctasks.vim'

" 异步运行，测试
Plug 'skywind3000/asyncrun.vim', { 'on': ['AsyncRun', 'AsyncStop', '<plug>(asyncrun-qftoggle)'] }
" {{{lazy load
augroup asyncrun
    au!
    au User asyncrun.vim nnoremap <silent> <plug>(asyncrun-qftoggle) :call asyncrun#quickfix_toggle(10)<cr>
augroup end
" 整合fugitive
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
"}}}
" 任务完成自动打开qf{{{
augroup auto_open_quickfix
    autocmd!
    " autocmd QuickFixCmdPost * botright copen 8 | nnoremap <c-j> :cnext<cr> | nnoremap <c-k> :cprevious<cr>
    " autocmd QuickFixCmdPost * execute 'CocList --normal quickfix' | nnoremap <c-j> :cnext<cr> | nnoremap <c-k> :cprevious<cr>
augroup end
"}}}
" nmap gq <plug>(asyncrun-qftoggle)
nnoremap <leader>ma :AsyncRun -mode=term -pos=bottom -rows=10 python "$(VIM_FILEPATH)"

" 插件适配
Plug 'albertomontesg/lightline-asyncrun'

" sudo for neovim  (原来的tee trick只对vim有用，对neovim无效)
Plug 'lambdalisue/suda.vim'
"{{{suda.vim-usage
" :E filename  sudo edit
" :W       sudo edit
"}}}
command! -nargs=1 E  edit  suda://<args>
command! W w suda://%

" 用vim看man
Plug 'lambdalisue/vim-manpager'

" FIXME: this source invode vim function that could be quite slow, so make sure your coc.preferences.timeout is not too low, otherwise it may timeout.
Plug 'Shougo/neoinclude.vim' | Plug 'jsfaint/coc-neoinclude'

" 像gitlens一样每行显示gitblame
Plug 'APZelos/blamer.nvim'
"{{{
" 自动开启
let g:blamer_enabled = 1
"}}}
"
"working directory跳转到project目录
"Plug 'airblade/vim-rooter'
"
" 自动解决绝大部分编码问题
Plug 'mbbill/fencview', { 'on': [ 'FencAutoDetect', 'FencView' ] }
"
" 查看各个插件启动时间
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
" Emmet支持
Plug 'mattn/emmet-vim'
"{{{
" 只在特定文件加载
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
"}}}

" 内嵌代码辅助缩进
" Plug 'AndrewRadev/inline_edit.vim'

" 自动关闭标签
Plug 'alvan/vim-closetag'

" markdown代码内高亮
Plug 'tpope/vim-markdown'
" TODO: 不知道还能不能用其他语言的高亮
let g:markdown_fenced_languages = ['html', 'css', 'js=javascript', 'python', 'bash=sh']
" MarkDown预览
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

" Todo List 和 笔记，文档管理
Plug 'vimwiki/vimwiki', {'on': ['VimwikiIndex']}
"{{{
" 使用markdown而不是vimwiki的语法
"let g:vimwiki_list = [{'path': '~/vimwiki/',
            \ 'syntax': 'markdown', 'ext': '.md'}]
"}}}

" }}}

call plug#end()

"==========================================
" HotKey Settings  自定义快捷键设置
"==========================================
"
" 如果需要覆盖插件定义的映射，可用如下方式
" autocmd VimEnter * noremap <leader>cc echo "my purpose"

" 主要按键重定义
inoremap kj <esc>
noremap ; :
nnoremap zo zazz
noremap ,; ;
nnoremap ,w :w<cr>zMzz
vnoremap v <esc>
" 我喜欢使用分号作为插入模式的 leader 键，因为分号后面除了空格和换行之外几乎不会接任何其他字符
" 快速在行末写分号并换行
inoremap ;; <c-o>A;<cr>
" NOTE: 这里用imap是因为要借用auto-pairs插件提供的{}自动配对
imap [[ <esc>A<space>{<cr>
" 重复上次执行的寄存器的命令
nnoremap <leader>r; @:
" 执行宏r
nnoremap <leader>rr @r
" 快速在括号间跳转
nnoremap gb %zz
" 查找当前单词
nnoremap gi gi<esc>zzi
nnoremap '' ''zz
nnoremap '. '.zz

" 替换模式串用法: 先用 / 查找, 然后再按下面的快捷键, subtitute查找域为空时会默认使用上次查找的内容
nnoremap <leader>su :%s///gc<left><left><left>
vnoremap <leader>su :s///gc<left><left><left>
" 退出系列
noremap <silent> <leader>q <esc>:q<cr>
noremap <silent> <leader><leader>q <esc>:qa!<cr>

"Treat long lines as break lines (useful when moving around in them)
"se swap之后，同物理行上线直接跳
noremap j gjzz
noremap k gkzz
noremap zj zjzz
noremap zk zkzz
noremap J <C-f>zz
noremap K <C-b>zz
noremap H ^
noremap L $
nnoremap dh d0
nnoremap dl d$
nnoremap ch c0
nnoremap cl c$

" Keep search pattern at the center of the screen.
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap G Gzz
" 定义这个是为了让which-key查询的时候不报错
nnoremap gg gg
nnoremap gv gvzz
" 去掉搜索高亮
nnoremap <silent> <leader>/ :nohls<cr>zz

" Buffer操作
" Close current buffer
nnoremap <silent> <leader>bd :bd<cr>
" 命令行模式增强
" 上下相比于<c-n> <c-p>更智能的地方:  可以根据已输入的字符补全历史命令
cnoremap <c-k> <up>
cnoremap <c-j> <down>
cnoremap <c-h> <home>
cnoremap <c-l> <end>
cnoremap <c-d> <delete>
inoremap <c-d> <delete>
cnoremap <m-p> <c-r>0
inoremap <m-p> <c-r>0
nnoremap <m-p> "0p

inoremap <c-h> <esc>I
inoremap <c-l> <esc>A
nnoremap <silent> <m-l> :bp<cr>
nnoremap <silent> <m-h> :bn<cr>

" Window操作
" flip two windows
nnoremap <leader>wf <c-w><c-r>
" split bottom window
nnoremap <leader>ss <c-w>s<c-w>w
" 窗口最大化 leaving only the help window open/maximized
nnoremap <leader>wo <c-w>ozz
noremap <silent> <leader>v :wincmd v<cr>:wincmd w<cr>
noremap <silent> <leader>j :wincmd j<cr>
noremap <silent> <leader>k :wincmd k<cr>
noremap <silent> <leader>h :wincmd h<cr>
noremap <silent> <leader>l :wincmd l<cr>

" Tab操作
nnoremap <leader><leader>h gT
nnoremap <leader><leader>l gt
nnoremap gxo :tabonly<cr>
nnoremap <c-t> :tab split<cr>
nnoremap <c-w> :tab close<cr>
inoremap <c-t> <esc>:tab split<cr>

" normal模式下切换到确切的tab
nnoremap <leader>1 1gt
" {{{
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
" }}}

" 调整缩进后自动选中，方便再次操作
vnoremap < <gv
vnoremap > >gv
nnoremap < <<
nnoremap > >>

noremap Y y$
" select all
noremap <c-a> ggVG
inoremap <c-a> <esc>ggVG
" 保存后全部折叠
cnoremap w<cr> w<cr>zMzz
" 交换 ' `, 使得可以快速使用'跳到marked相同的位置
noremap ' `
noremap ` '

"==========================================
" Theme Settings  主题设置
"==========================================
set termguicolors  " 使用真色彩
" NOTE: quantum主题是必开的, 用来提供lightline主题
colorscheme quantum
" colorscheme onedark

" let g:neodark#use_256color = 1
" colorscheme neodark

" colorscheme nova
" colorscheme forest-night

"==========================================
" 基础设置{{{
set background=dark
set t_Co=256
set tags=./.tags;,.tags  " 让ctags改名为.tags，不污染工作区
set confirm
" set nowrap  " 取消换行
set linebreak  " 一行文本超过window宽度会wrap，设置此项会让单词按语义分隔而不是按字母分隔
set guicursor+=a:blinkon0  " 仅在gvim生效, 取消cursor的闪烁, 终端下的vim需要自行修改终端cursor设置
set history=2000  " history存储容量
filetype on  " 检测文件类型
filetype indent on  " 针对不同的文件类型采用不同的缩进格式
set noswapfile
set autoread  " 文件在外界被修改之后自动载入
set autowriteall  " edit, next等动作时自动写入
set timeout ttimeoutlen=50  " 连续识别按键的延迟
set clipboard+=unnamedplus
set shortmess=atI  " 启动的时候不显示那个援助乌干达儿童的提示
set nobackup nowritebackup  " 取消备份文件
set updatecount =100  " FIXME:如果编辑大文件很慢那么考虑调大这个值 After typing this many characters the swap file will be written to disk
set cursorline  " 突出显示当前行
set synmaxcol=200  " 每次只渲染200行而不是整个文件
set t_ti= t_te=  " 设置 退出vim后，内容显示在终端屏幕, 可以用于查看和复制, 不需要可以去掉, 好处：误删什么的，如果以前屏幕打开，可以找回
set mouse=r  " 启用鼠标, 可以用右键使用系统剪切板来复制粘贴
set title  " change the terminal's title
set novisualbell  " 去掉输入错误的提示声音
set noerrorbells
set vb t_vb= " 彻底禁止错误发出bell
set tm=500
set backspace=eol,start,indent  " Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l

set viminfo+=!  " 保存viminfo全局信息
set lazyredraw  " redraw only when we need to.
set nocompatible  " 去掉有关vi一致性模式，避免以前版本的bug和局限
set wildmenu  " 增强模式中的命令行自动完成操作
set wildmode=longest,full
"}}}
" 设置wildmenu忽略的文件{{{
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem  " Disable output and VCS files
set wildignore+=*.dll,*.bak,*.exe,*.pyc,*.jpg,*.gif,*.png  " Disable binary files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz  " Disable archive files
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*  " Ignore bundler and sass cache
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*  " Ignore rails temporary asset caches
set wildignore+=node_modules/*  " Ignore node modules
set wildignore+=*.swp,*~,._*  " Disable temp and backup files
set wildignorecase  " files or directoies auto completion is case insensitive
set completeopt-=menu  " 让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
set completeopt+=longest,menuone
"}}}
" 设置标记一列的背景颜色和数字一行颜色一致{{{
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange
"}}}
" for error highlight，防止错误整行标红导致看不清{{{
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline
"}}}
" FileType Settings  文件类型设置{{{

" 具体编辑文件类型的一般设置，比如不要 tab 等
augroup tab_indent_settings_by_filetype
    autocmd!
    autocmd FileType python,ruby,javascript,html,css,xml,sass,scss set tabstop=4 shiftwidth=4 softtabstop=4 expandtab ai
    autocmd BufRead,BufNewFile *.md,*.mkd,*.markdown set filetype=markdown.mkd
    autocmd BufRead,BufNewFile *.part set filetype=html
    autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
    autocmd BufWinEnter *.php set mps-=<:>  " disable showmatch when use > in php
augroup end
"}}}
"==========================================
" Display Settings 展示/排版等界面格式设置{{{

set ruler  " 显示当前的行号列号
set showmode  " 左下角显示当前vim模式
set number  " 显示行号
set textwidth=0  " 打字超过一定长度也不会自动换行
set relativenumber number  " 相对行号: 行号变成相对，可以用 nj/nk 进行跳转
" set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P  " 命令行（在状态行下）的高度，默认为1，这里是2
set laststatus=2  " Always show the status line - use 2 lines for the status bar
set showmatch  " 括号配对情况, 跳转并高亮一下匹配的括号
set matchtime=2  " How many tenths of a second to blink when matching brackets
set hlsearch  " 高亮search命中的文本
set incsearch  " 打开增量搜索模式,随着键入即时搜索
set ignorecase  " 搜索时忽略大小写
set smartcase  " 有一个或以上大写字母时变成大小写敏感
set foldenable  " 代码折叠
set foldmethod=marker  " marker    使用标记进行折叠, 默认标记是 {{{ 和 }}}
set foldlevelstart=0  " 打开vim时自动折叠
set smartindent  " Smart indent
set autoindent  " never add copyindent, case error   " copy the previous indentation on autoindenting

" tab相关变更
set tabstop=4  " 设置Tab键的宽度        [等同的空格个数]
set shiftwidth=4  " 每一次缩进对应的空格数
set softtabstop=4  " 按退格键时可以一次删掉 4 个空格
set smarttab  " insert tabs on the start of a line according to shiftwidth, not tabstop 按退格键时可以一次删掉 4 个空格
set expandtab  " 将Tab自动转化成空格[需要输入真正的Tab键时，使用 Ctrl+V + Tab]
set shiftround  " 缩进时，取整 use multiple of shiftwidth when indenting with '<' and '>'

" 防止tmux下vim的背景色显示异常
" Refer: http://sunaku.github.io/vim-256color-bce.html
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif
"}}}
"==========================================
" FileEncode Settings 文件编码,格式{{{

set fencs=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
set encoding=utf-8  " 设置新文件的编码为 UTF-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1  " 自动判断编码时，依次尝试以下编码：
set helplang=cn
set termencoding=utf-8  " 下面这句只影响普通模式 (非图形界面) 下的 Vim
set formatoptions+=m  " 如遇Unicode值大于255的文本，不必等到空格再折行
set formatoptions+=B  " 合并两行中文时，不在中间加空格
"}}}
"==========================================
" 自动行为设置
"==========================================

augroup auto_actions_for_better_experience
    autocmd!
    " 自动source VIMRC
    autocmd BufWritePost $MYVIMRC source $MYVIMRC | call lightline#enable()
    " 打开自动定位到最后编辑的位置, 需要确认 .viminfo 当前用户可写
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exec "normal! g'\" \| zz" | endif
    " 在右边窗口打开help
    autocmd BufEnter * if &buftype == 'help' | wincmd L | endif
    " Test插件要求工作目录在project根目录
    " autocmd BufEnter * silent! lcd %:p:h  " 自动切换当前目录为当前文件的目录
    "
    " <c-j><c-k>移动quickfix
    "{{{
    function List_is_opened(type) abort
        if a:type == "quickfix"
            let g:my_check_quickfix_ids = getqflist({"winid" : 1})
        endif
        return get(g:my_check_quickfix_ids, "winid", 0) != 0
    endfunction
    "
    function Change_ctrljk_for_quickfix() abort
        if List_is_opened("quickfix")
            nnoremap <c-j> :cnext<cr>
            nnoremap <c-k> :cprevious<cr>
        else
            nnoremap <c-j> :call ScrollAnotherWindow(2)<CR>
            nnoremap <c-k> :call ScrollAnotherWindow(1)<CR>
        endif
    endfunction
    "}}}
    autocmd WinNew,WinEnter,WinLeave,BufLeave,BufEnter * call Change_ctrljk_for_quickfix()

augroup end

" 开启语法高亮
syntax on  " NOTE: 这条语句放在不同的地方会有不同的效果，经测试,放在这里是最合适的

" 特定标记配色 TODO: FIXME: BUG: NOTE: HACK:
"{{{
highlight MyTodo cterm=NONE ctermbg=180 ctermfg=black gui=bold guifg=#ff8700
highlight MyNote cterm=NONE ctermbg=75 ctermfg=black gui=bold guifg=#19dd9d
highlight MyFixme cterm=NONE ctermbg=189 ctermfg=black gui=bold guifg=#e697e6
highlight MyBug cterm=NONE ctermbg=168 ctermfg=black gui=bold guifg=#dd698c
highlight MyHack cterm=NONE ctermbg=240 ctermfg=black gui=bold guifg=#f4da9a
augroup highlight_my_keywords
    autocmd!
    autocmd Syntax * call matchadd('MyTodo',  '\W\zs\(TODO\|CHANGED\|XXX\|DONE\):')
    autocmd Syntax * call matchadd('MyNote',  '\W\zsNOTE:')
    autocmd Syntax * call matchadd('MyFixme',  '\W\zsFIXME:')
    autocmd Syntax * call matchadd('MyBug',  '\W\zsBUG:')
    autocmd Syntax * call matchadd('MyHack',  '\W\zsHACK:')
augroup end
"}}}

" =============================================
" 新增功能
" =============================================
" F1 - F6 设置
" F1 废弃这个键,防止调出系统帮助
noremap <F1> <nop>
inoremap <F1> <nop>
cnoremap <F1> <nop>

" F2 行号开关，用于鼠标复制代码用, 为方便复制，用<F2>开启/关闭行号显示:
" {{{
function! HideNumber()
  if(&relativenumber == &number)
    set relativenumber! number!
  elseif(&number)
    set number!
  else
    set relativenumber!
  endif
  set number?
endfunc
" }}}
nnoremap <F2> :call HideNumber()<cr>

" F6 语法开关，关闭语法可以加快大文件的展示
nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<cr>

" 当有两个窗口时, Scroll另一个窗口
"{{{
function! ScrollAnotherWindow(mode)
    if winnr('$') <= 1
        return
    endif
    noautocmd silent! wincmd p
    if a:mode == 1
        exec "normal! kzz"
    elseif a:mode == 2
        exec "normal! jzz"
    elseif a:mode == 3
        exec "normal! \<c-b>zz"
    elseif a:mode == 4
        exec "normal! \<c-f>zz"
    elseif a:mode == 5
        exec "normal! gg"
    elseif a:mode == 6
        exec "normal! Gzz"
    endif
    noautocmd silent! wincmd p
endfunc
"}}}
nnoremap <c-k> :call ScrollAnotherWindow(1)<CR>
nnoremap <c-j> :call ScrollAnotherWindow(2)<CR>
nnoremap <c-e> :call ScrollAnotherWindow(3)<CR>
nnoremap <c-d> :call ScrollAnotherWindow(4)<CR>
nnoremap <c-g><c-g> :call ScrollAnotherWindow(5)<CR>
nnoremap <c-s-g> :call ScrollAnotherWindow(6)<CR>

" 切换透明模式, 需要预先设置好终端的透明度
"{{{
let t:is_transparent = 0
function! Toggle_transparent_background()
  if t:is_transparent == 1
    windo set cursorline
    syn off | syn on
    let t:is_transparent = 0
  else
    windo set nocursorline  " 对所有窗口
    hi Normal guibg=NONE ctermbg=NONE
    let t:is_transparent = 1
  endif
endfunction
"}}}
nnoremap <leader>tt :call Toggle_transparent_background()<CR>
" 快速编辑init.vim
nnoremap <leader>en :e $MYVIMRC<CR>
" 删除隐藏的buffer
"{{{
function! DeleteHiddenBuffers()
    let tpbl=[]
    let closed = 0
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
        let closed += 1
    endfor
    echo "Closed ".closed." hidden buffers"
endfunction
"}}}
nnoremap <leader>bc :call DeleteHiddenBuffers()<cr>
" 查看highlighting group
" Print stack of syntax highlighting groups for word under the cursor{{{
function! s:synstack()
    echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), ' -> ')
endfunction
"}}}
nnoremap <F8> :<C-u>call <SID>synstack()<CR>
"自动保存
" {{{
function! s:Autosave(timed)
    if &readonly || mode() == 'c' || pumvisible()
        return
    endif
    let current_time = localtime()
    let s:last_update = get(s:, 'last_update', 0)
    let s:time_delta = current_time - s:last_update

    if a:timed == 0 || s:time_delta >= 1
        let s:last_update = current_time
        checktime  " checktime with autoread will sync files on a last-writer-wins basis.
        silent! doautocmd BufWritePre %  " needed for soft checks
        silent! update  " only updates if there are changes to the file.
        if a:timed == 0 || s:time_delta >= 4
            silent! doautocmd BufWritePost %  " Periodically trigger BufWritePost.
        endif
    endif
endfunction

if s:enable_file_autosave
    augroup WorkspaceToggle
        au! BufLeave,FocusLost,FocusGained * call s:Autosave(0)
        au! CursorHold * call s:Autosave(1)
    augroup END
endif
"}}}
" 让JSONC的注释显色正常
"{{{
augroup enable_comment_highlighting_for_json
    autocmd FileType json syntax match Comment +\/\/.\+$+
augroup end
"}}}

"自动make
augroup my_auto_make
    autocmd!
    autocmd FileType c set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ gcc\ -O2\ -g\ -Wall\ -Wextra\ -o'%<'\ '%'\ -lm;fi
    autocmd FileType cpp set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ g++\ -O2\ -g\ -Wall\ -Wextra\ -o'%<'\ '%'\ -lm;fi
augroup end

" 添加空白行
"{{{
function! s:BlankUp(count) abort
    put!=repeat(nr2char(10), a:count)
    ']+1
    silent! call repeat#set("\<Plug>unimpairedBlankUp", a:count)
endfunction

function! s:BlankDown(count) abort
    put =repeat(nr2char(10), a:count)
    '[-1
    silent! call repeat#set("\<Plug>unimpairedBlankDown", a:count)
endfunction
"}}}
nnoremap [<space> :<c-u>call <sid>BlankDown(v:count1)<cr>
nnoremap ]<space> :<c-u>call <sid>BlankUp(v:count1)<cr>
