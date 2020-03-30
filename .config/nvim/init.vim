" TODO: 去https://github.com/neoclide/coc-tsserver 查看相关的js，ts设置
" 只考虑NeoVim，不一定兼容Vim
"
" 经验之谈:
"   1. 抓住主要问题, 用相对简单和有意义的按键映射出现频率高的操作, 而非常冷门的操作不设置快捷键，可以考虑用别的方式替代
"   2. 最小表达力原则: 用尽可能简单的方式组合来完成复杂的需求, 比如easy-motion插件有很多功能，
"      但其实<Plug>(easymotion-bd-f)就足以胜任日常快速移动所需要的绝大部分功能, 过多的快捷键及功能反而会是干扰
"
" 键位设计原则:
"   1. 有意义，容易记忆.
"   2. 每个指令均衡左右手指击键, 如果都在同一手上则尽量用不同的手指击键，尽量减小手指移动距离
"
"  不建议用appimge安装，因为这样的话将nvim作为manpager会出现奇怪的权限问题
"==========================================
" 【依赖说明】{{{
"  coc.nvim补全插件需要安装node.js和npm LeaderF依赖Python3, vista依赖global-ctags
"  leaderF和far依赖rg
"}}}
" 【必做事项】{{{
"  1. :PlugInstall
"  2. 提供python和系统剪切板支持 pip3 install pynvim && apt install xsel
"  3. rm -rf ~/.viminfo 这样可以使自动回到上次编辑的地方功能生效, 然后重新打开vim(注意要以当前用户打开),vim会自动重建该文件.
"  4. ubuntu下用snap包管理器安装ccls, 作为C、C++的LSP (推荐用snap安装, 因为ccls作者提供的编译安装方式似乎有问题, 反正Ubuntu18.04不行)
"  5. 安装Sauce Code Pro Nerd Font Complete字体(coc-explorer要用到), 然后设置终端字体为这个, 注意不是原始的Source Code Pro),
"     最简单的安装方法就是下载ttf文件然后双击安装
"  6. 需要在/etc/crontab设置以下定时任务，定期清理undofile
"{{{
"     # m h  dom mon dow   command
"     43 00 *   *   3     find /home/{username}/.vim/undo-dir -type f -mtime +90 -delete
"}}}
"  7. 安装gtags(需要>6.63(需要>6.63)) 并用 pygments扩展语言类型
"           在官网下载最新的tar.gz 解压后进入 执行 sudo apt install ncurses-dev && ./configure && make && sudo make install && sudo pip3 install pygments
"  8. ctags(插件vista依赖):
        " sudo apt install software-properties-common && sudo add-apt-repository ppa:hnakamur/universal-ctags && sudo apt update && sudo apt install universal-ctags
"
"  9. 在:CocConfig 写入下面的JSON设置
"}}}
" 【可选项】{{{
"  1. 使用Alacritty终端模拟器 设置cursor不闪烁, <c-c>复制，<m-i>粘贴系统剪切板， 而Vim里面的<m-i>会被终端拦截，所以有相同的效果，
"          然后在Vim映射<m-p>是粘贴0寄存器的内容. 设置透明终端, 用<leader>tt可以切换透明模式, 设置开启时窗口大小来达到启动max-size的目的
"  2. 然后终端设置General-勾消Show menubar by default in new terminals
"  3. 只能稍微调快一点键盘响应速度，调太快会导致一次按键多次响应
"  4. 静态代码检查linter与排版器formatter（记得先换源）:
"        for javascript
"            npm install -g eslint && npm install -g prettier
"        for python
"            pip3 install pylint && pip3 install autopep8
"        for C,CPP
"            sudo apt install cppcheck -y && npm install -g clang-format
"
"  5. 安装riggrep 配合Leaderf rg使用, 快速搜索文本行:
"            curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb && sudo dpkg -i ripgrep_11.0.2_amd64.deb
"            FIXME: 如果在Leaderf里调用rg出现~/.config文件夹permission deny的情况 就需要 sudo chown -R $USER:$GROUP ~/.config
"  6. 使用vim-signify显示diff，必须要注册好git账户，比如git config --global user.name "username" && git config --global user.email "useremail@qq.com"
"  7.  "coc-tabnine需要设置'ignore_all_lsp': true来加强补全效果
"}}}
" 【初次配置Vim必看】配置文件的坑{{{
"   1. 映射<Plug>(...)必须用递归映射, 否则不生效
"   2. 映射ex命令的时候不能用noremap, 因为这会导致按键出现奇奇怪怪的结果, 应该改成nnoremap
"   3. vimrc文件let语句的等号两边不能写空格, 写了不生效!
"   4. 单引号是raw String 而双引号才可以转义， 所以设置unicode字体的时候应该用双引号比如"\ue0b0"
"}}}

" ==========================================
" 【可自行调整的重要参数】
let g:enable_front_end_layer = 1  " 前端Layer, 启动所有前端相关插件
let g:enable_file_autosave = 1  " 是否自动保存
let g:disable_laggy_plugins_for_large_file = 0  " 在启动参数里设置为1就可以加快打开速度
set updatetime=400  " 检测CursorHold事件的时间间隔,影响性能的主要因素
let g:default_colorscheme_mode = 0
let g:all_colorschemes = ['quantum', 'gruvbox-material', 'forest-night']
let s:lightline_schemes = ['quantum', 'gruvbox_material', 'forest_night']


let mapleader=' '  " 此条命令的位置应在插件之前
let g:mapleader=' '

" =========================================
" 插件管理
" =========================================
" {{{ vim-plug 自动安装
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl --insecure -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}
" NOTE: 对于使用了on或for来延迟加载的插件只有在加载了之后才能用 help 查看文档
call plug#begin('~/.vim/plugged')
" {{{没有设置快捷键的，在后台默默运行的插件

" 主题配色
" Plug 'joshdick/onedark.vim'
Plug 'tyrannicaltoucan/vim-quantum'
" Plug 'KeitaNakamura/neodark.vim'
" Plug 'trevordmiller/nova-vim'
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/forest-night'

" =================================
" 在大文件下会影响性能
" =================================
if g:disable_laggy_plugins_for_large_file == 0
    " 拼写检查
    Plug 'kamykn/spelunker.vim'
    "{{{
    set nospell  " 禁用默认的难看的高亮红色
    let g:spelunker_check_type = 2  " 只在window内动态check, 对大文件十分友好
    let g:spelunker_highlight_type = 2  " Highlight only SpellBad.
    augroup my_highlight_spellbad
        autocmd!
        autocmd VimEnter * highlight SpelunkerSpellBad cterm=undercurl ctermfg=247 gui=undercurl guifg=#9e9e9e
        autocmd VimEnter * highlight SpelunkerComplexOrCompoundWord cterm=undercurl ctermfg=247 gui=undercurl guifg=#9e9e9e
        " 下两行 取消在startify中的拼写检查 前提是设置了 g:spelunker_check_type = 2:
        let g:spelunker_disable_auto_group = 1
        " FIXME: 下面这句不能用，不然用--noplugin 开启nvim的时候会一直报错
        if exists('*spelunker#check_displayed_words')  " --noplugin模式不判断函数存在的话会报错
            autocmd CursorHold * if &filetype != 'startify' | call spelunker#check_displayed_words() | endif
        endif
    augroup end
    "}}}
endif
" ==================================
" ==================================

" 缩进虚线
Plug 'Yggdroot/indentLine', {'for': 'python'}

" 极大增强f和t查找能力 , f<cr>会重复上次搜索的字母, f会自动重复搜索
Plug 'rhysd/clever-f.vim'
"{{{
let g:clever_f_smart_case = 1  " smart case
let g:clever_f_chars_match_any_signs = 1  " 可以搜索所有的字符,比如;,.
let g:clever_f_repeat_last_char_inputs = ["\<CR>", "\<Tab>"]  " 使用上次的输入
let g:clever_f_mark_char_color = 'MyHack'
let g:clever_f_across_no_line = 1
"}}}

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

" 让. 可以重复插件的操作, 和surround是绝配
Plug 'tpope/vim-repeat'

" Undo到上次保存前的历史操作(使用undofile时)就发警告来提醒
Plug 'arp242/undofile_warn.vim'

" 140+种语言的语法高亮包
Plug 'sheerun/vim-polyglot'

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

" coc-snippets是框架,这个是资源
Plug 'honza/vim-snippets'
"
" 自动进入粘贴模式
Plug 'ConradIrwin/vim-bracketed-paste'

" FIXME: this source invode vim function that could be quite slow, so make sure your coc.preferences.timeout is not too low, otherwise it may timeout.
Plug 'Shougo/neoinclude.vim' | Plug 'jsfaint/coc-neoinclude'

" 自动解决绝大部分编码问题
Plug 'mbbill/fencview', { 'on': [ 'FencAutoDetect', 'FencView' ] }

" 自动关闭标签
Plug 'alvan/vim-closetag'
"{{{
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.xml,*.jsx,*.tsx'
"}}}

" markdown代码内高亮
Plug 'plasticboy/vim-markdown', {'for': ['markdown', 'vimwiki']}
let g:vim_markdown_fenced_languages = ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'csharp=cs']

" 与tmux整合的插件
"{{{
if executable('tmux') && filereadable(expand('~/.zshrc')) && $TMUX !=# ''
    " 在tmux的pane间也能补全
    Plug 'wellle/tmux-complete.vim'
    let g:tmuxcomplete#trigger = ''
endif
"}}}

" 高亮与光标下单词相同的单词
Plug 'RRethy/vim-illuminate'
"{{{
" 让高亮与visual显色一致
hi link illuminatedWord Visual
" 选择不高亮的文件类型
let g:Illuminate_ftblacklist = [
            \ 'vim', 'text', 'markdown', 'css', 'help',
            \ 'coc-explorer', 'vista', 'qf', 'vimwiki'
            \ ]
"}}}

" 选择模式和行选择模式下可以用I A批量多行写入(修改了可视模式下I和A的映射)
Plug 'kana/vim-niceblock'

" 自定义text-object 是vim-textobj-variable-segment插件的依赖
Plug 'kana/vim-textobj-user'
" 新增很多方便的text object, 比如 , argument in( il( 并且可以计数比如光标在a时 (((a)b)c)  --d2ab--> (c )
Plug 'wellle/targets.vim'
" 新增indent object 在python里很好用 cii cai
Plug 'michaeljsmith/vim-indent-object'
" iv av variabe-text-object 部分删除变量的名字 比如camel case: getJiggyY 以及 snake case: get_jinggyy
Plug 'Julian/vim-textobj-variable-segment'
" if{char} af{char}
Plug 'thinca/vim-textobj-between'

" 自动隐藏搜索的高亮
Plug 'romainl/vim-cool'
"{{{
let g:CoolTotalMatches = 1
"}}}

" 实时预览substitute命令的情况
Plug 'markonm/traces.vim'

" 状态栏
Plug 'itchyny/lightline.vim'
"{{{
" functions
"{{{
function! Sy_stats_wrapper()
  if !exists('*sy#repo#get_stats')  " 大文件模式下signify插件被关闭了，所以这个函数不存在
      return ''
  endif
  let l:symbols = ['+', '-', '~']
  let [added, modified, removed] = sy#repo#get_stats()
  let l:stats = [added, removed, modified]  " reorder
  let hunkline = ''
  for i in range(3)
    if l:stats[i] > 0
      let hunkline .= printf('%s%s ', l:symbols[i], l:stats[i])
    endif
  endfor
  if !empty(hunkline)
    let hunkline = printf('[%s]', hunkline[:-2])
  endif
  return winwidth(0) > 70 ? hunkline : ''
endfunction

function! LightlineFugitive()
    let l:result = ''
    if &ft !~? 'vimfiler' && exists('*FugitiveHead')
        let l:result = FugitiveHead()
    endif
    return winwidth(0) > 45 ? l:result : ''
endfunction

function! LightlineFileformat()
    let l:result = &fenc != "" ? &fenc : &enc
    let l:result = l:result . '[' . &ff . ']'
    return winwidth(0) > 70 ? l:result : ''
endfunction

function LightLineFiletype()
    let l:result = &ft != "" ? &ft : "no ft"
    return winwidth(0) > 70 ? l:result : ''
endfunction


function! NearestMethodOrFunction() abort
  return winwidth(0) > 70 ? get(b:, 'vista_nearest_method_or_function', '') : ''
endfunction

function! Tab_num(n) abort
  return a:n
endfunction

function! RemoveLabelOnTopRight() abort
    return ""
endfunction

function! Get_session_name() abort
    let l:session_name = fnamemodify(v:this_session,':t:r')
    return l:session_name != '' ? '<' . l:session_name . '>' : ''
endfunction

function If_in_merge_or_diff_mode() abort
  if get(g:, 'mergetool_in_merge_mode', 0)  " merge模式
    return 'merge mode'
  endif
  if &diff
    return 'diff mode'  " diff模式
  endif
  return ''
endfunc
"}}}

let g:lightline = {}
let g:lightline.colorscheme = s:lightline_schemes[g:default_colorscheme_mode]
let g:lightline.separator = { 'left': "\ue0b8", 'right': "\ue0be" }
let g:lightline.subseparator = { 'left': "\ue0b9", 'right': "\ue0b9" }
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
        \           [  'filename', 'readonly', 'gitbranch', 'modified', 'session_name' ],
        \         ],
        \ 'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
        \            [ 'diff_or_merge_mode', 'filetype', 'fileformat', 'lineinfo' ],
        \            [ 'asyncrun_status']
        \          ]
        \ }
let g:lightline.inactive = {
    \ 'left': [ [ 'filename' , 'modified', 'session_name' ] ],
    \ 'right': [ [ 'diff_or_merge_mode', 'filetype', 'fileformat', 'lineinfo' ] ]
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
      \ 'filename': 'lightline#tab#filename',
      \ 'readonly': 'lightline#tab#readonly',
      \ 'tabnum': 'Tab_num'
      \ }

let g:lightline.component = {
      \ 'bufinfo': '%{bufname("%")}:%{bufnr("%")}',
      \ 'vim_logo': "\ue7c5",
      \ 'mode': '%{lightline#mode()}',
      \ 'absolutepath': '%F',
      \ 'relativepath': '%f',
      \ 'filename': '%t',
      \ 'filesize': "%{HumanSize(line2byte('$') + len(getline('$')))}",
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
      \   'method': 'NearestMethodOrFunction',
      \   'session_name': 'Get_session_name',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'diff_or_merge_mode': 'If_in_merge_or_diff_mode'
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

" asyncrun和lightline插件适配
Plug 'albertomontesg/lightline-asyncrun'

" python的indent折叠增强, 折叠import，折叠和预览doctring，
Plug 'tmhedberg/SimpylFold', {'for': [ 'python' ]}
"{{{
let g:SimpylFold_docstring_preview = 1
"}}}
"
" 异步自动生成tags
Plug 'jsfaint/gen_tags.vim'
"{{{
let g:gen_tags#verbose = 0  " 不提示信息
let g:gen_tags#gtags_auto_gen = 1
let g:gen_tags#gtags_auto_gen = 1
let g:gen_tags#ctags_opts = ['--c++-kinds=+px', '--c-kinds=+px']
let g:gen_tags#ctags_opts = ['-c', '--verbose']
let $GTAGSLABEL = 'native-pygments'  " FIXME: 当项目文件的路径包含非ASCII字符时，使用pygments会报UnicodeEncodeError
let $GTAGSCONF = '/usr/share/gtags/gtags.conf'
"}}}

" 写作使用的，自动单词折行
Plug 'reedes/vim-pencil', {'for': ['markdown', 'text', 'vimwiki']}
let g:pencil#textwidth = 80  " 默认单行最大长度
augroup pencil
    autocmd!
    if exists('*pencil#init')
        autocmd FileType markdown call pencil#init({'wrap': 'hard', 'autoformat': 1}) | setlocal wrap | setlocal textwidth=80
        autocmd FileType text     call pencil#init({'wrap': 'soft', 'autoformat': 0}) | setlocal wrap | setlocal textwidth=120
    endif
augroup END

"===========================================================================
"===========================================================================
"}}}
" {{{需要知道快捷键的插件

" =======================================
" 开关非常影响打开大文件性能的插件
" =======================================
if g:disable_laggy_plugins_for_large_file == 0
    " 侧栏显示git diff情况
    Plug 'mhinz/vim-signify'
    augroup signify_remapping
        autocmd!
        " 在diff hunk之间跳转
        autocmd VimEnter * nmap [c <plug>(signify-prev-hunk)zz
        autocmd VimEnter * nmap ]c <plug>(signify-next-hunk)zz
    augroup end

    " ALE静态代码检查和自动排版 NOTE: 默认禁用对log文件的fixer
    Plug 'dense-analysis/ale'
    "{{{
    let g:ale_set_highlights = 0  " 不要显示红色下划线
    let g:ale_sign_error = '✗'
    let g:ale_sign_warning = '⚡'

    " 不需要指定linters

    " 自动排版, 保存时自动删除末尾空白行和行末空格
    let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'c': ['clang-format'],
    \   'cpp': ['clang-format'],
    \   'javascript': ['prettier'],
    \   'python': ['autopep8'],
    \}
    " 极大提升打开log 文件的性能
    let g:ale_fix_on_save_ignore = {'log': ['remove_trailing_lines', 'trim_whitespace']}
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
    nmap <silent> ge <Plug>(ale_next_wrap)
    nmap <silent> gE <Plug>(ale_previous_wrap)
endif




" ===============================
" Git相关
" ===============================

" 可视化merge NOTE: 恢复merge前的状态使用: git checkout --conflict=diff3 {file}
Plug 'samoshkin/vim-mergetool', {'on': '<plug>(MergetoolToggle)'}
"{{{
let g:mergetool_layout = 'mr'  " `l`, `b`, `r`, `m`
let g:mergetool_prefer_revision = 'local'  " `local`, `base`, `remote`
" mergetool 模式关闭语法检查和语法高亮 FIXME: 可能是unknown filetype报错的原因
function s:on_mergetool_set_layout(split)
  set syntax=off
endfunction
let g:MergetoolSetLayoutCallback = function('s:on_mergetool_set_layout')

let g:mergetool_layout_custom = 0
function! MergetoolLayoutCustom()
  if g:mergetool_layout_custom == 0
    let g:mergetool_layout_custom = 1
    execute 'MergetoolToggleLayout lbr,m'
  else
    let g:mergetool_layout_custom = 0
    execute 'MergetoolToggleLayout mr'
  endif
endfunction
"}}}
nmap <leader>mt <plug>(MergetoolToggle)
" 切换视图
nnoremap <silent> <leader>cmt :<C-u>call MergetoolLayoutCustom()<CR>

" 显示当前行的commit信息, o下一个commit，O上一个，d打开该commit在当前文件的diff hunks， D打开该commit的所有diff hunks
Plug 'rhysd/git-messenger.vim', {'on': '<Plug>(git-messenger)'}
"{{{
let g:git_messenger_no_default_mappings = v:true
"}}}
" 开启预览后光标始终进入popup window, 否则要再次使用快捷键才能让光标进入popup window
" let g:git_messenger_always_into_popup = v:true
nmap go <Plug>(git-messenger)

" git
Plug 'tpope/vim-fugitive'
" Gread就是清空暂存区 即checkkout %
" 还有diffget和diffput可以使用
nnoremap ,ga :G add %:p<CR><CR>
nnoremap ,gc :G commit --all<cr>
" 定义进入diff的事件，然后当前窗口关闭syntax
autocmd User MyEnterDiffMode echo ''
nnoremap ,gd :Gdiffsplit<cr>:doautocmd User MyEnterDiffMode<cr>
nnoremap <silent> ,gs :vert Git<cr>
" nnoremap ,gl :Glog<cr>  " 由Flog插件替代
nnoremap ,gps :G push<cr>
nnoremap ,gpl :G pull<cr>
nnoremap ,gf :G fetch<cr>
nnoremap ,gg :Ggrep<space>
nnoremap ,gm :GMove<Space>
nnoremap ,gb :Git branch<Space>
nnoremap .go :Git checkout<Space>
" 编辑其他分支的文件 Gedit branchname:path/to/file,  branchname:%表示当前buffer的文件
nnoremap ,ge :Gedit<space>
" 重命名git项目下的文件
" This will:
    " Rename your file on disk.
    " Rename the file in git repo.
    " Reload the file into the current buffer.
    " Preserve undo history.
nnoremap ,gr :Gwrite<cr>:Gmove <c-r>=expand('%:p:h')<cr>/
nnoremap ,gw :Gwrite<CR><CR>

" 更方便的查看commit g?查看键位 enter查看详细信息 <c-n> <c-p> 跳到上下commit
Plug 'rbong/vim-flog', {'on': ['Flog']}
function! Flogdiff()  " {{{
  let first_commit = flog#get_commit_data(line("'<")).short_commit_hash
  let last_commit = flog#get_commit_data(line("'>")).short_commit_hash
  call flog#git('vertical belowright', '!', 'diff ' . first_commit . ' ' . last_commit)
endfunction
"}}}
augroup flog
    " 在FlogGraph中visual模式选中两个commit 再按gd可以diff这两个commit
    autocmd FileType floggraph vnoremap gd :<C-U>call Flogdiff()<CR>
augroup end
let g:flog_default_arguments = { 'max_count': 1000 }  " 约束最大显示的commit数量，防止打开太慢
nnoremap ,gl :Flog<cr>
" 选中多行查看历史
vnoremap ,gl :Flog<cr>




" ===============================
" coc系列
" ===============================

" coc-explorer 文件树
"{{{
function ToggleCocExplorer()
  execute 'CocCommand explorer --toggle --width=35 --sources=buffer+,file+ ' . getcwd()
endfunction
"}}}
nnoremap <silent> <leader>er :Rooter<cr>:call ToggleCocExplorer()<CR>

" 使用coc-yank (自带复制高亮)
nnoremap <silent> gy :<C-u>CocList --normal yank<cr>

" coc-translator  可以先输入再查词, 作为一个简单的英汉词典,
nmap tt <Plug>(coc-translator-p)
vmap tt <Plug>(coc-translator-pv)

" coc-todolist
" 使用方法: 用:CocList todolist打开
" Filter your todo items and perform operations via <Tab>
" Use toggle to toggle todo status between active and completed
" Use edit to edit the description of a todo item
" Use preview to preview a todo item
" Use delete to delete a todo item
nnoremap <leader>tc :CocCommand todolist.create<cr>
nnoremap <leader>tl :CocList todolist<cr>
" clear all notifications
nnoremap <silent> <leader>tx :CocCommand todolist.clearRemind<cr>
nnoremap <leader>tu :CocCommand todolist.upload<cr>
" download todolist from gist
" nnoremap <leader>td :CocCommand todolist.download<cr>
" export todolist as a json/yaml file
" nnoremap <leader>te :CocCommand todolist.export<cr>

" COC自动补全框架
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"{{{

" 部分插件简介
"     coc-syntax coc-marketplace (用于查看所有的coc扩展)
"     coc-todolist (可以同步到gist,具体看github)
"     coc-emoji (仅在markdown里用:触发补全， 查表https://www.webfx.com/tools/emoji-cheat-sheet/)
"     coc-gitignore (按类型添加gitignore, 用法是在已有git初始化的文件夹内CocList gitignore)
"     coc-stylelint 检测css, wxss, scss, less, postcss, sugarss, vue NOTE: 非常建议自己为每个workspace建立配置文件，具体参看vscode对应的配置选项

" vim启动后自动异步安装的插件
let g:coc_global_extensions = [
  \ 'coc-snippets', 'coc-json', 'coc-html', 'coc-css', 'coc-tsserver',
  \ 'coc-python', 'coc-tabnine', 'coc-lists', 'coc-explorer', 'coc-yank',
  \ 'coc-markdownlint', 'coc-stylelint', 'coc-sh', 'coc-dictionary', 'coc-word', 'coc-emmet',
  \ 'coc-syntax', 'coc-marketplace', 'coc-todolist', 'coc-emoji',
  \ 'coc-gitignore'
  \ ]



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
nmap <silent> gd <Plug>(coc-definition)zz
nmap <silent> gm <Plug>(coc-implementation)zz
nmap <silent> gr <Plug>(coc-references)zz
nmap <silent> gf <Plug>(coc-refactor)
nmap <silent> gt <Plug>(coc-type-definition)
" 可以用来import
nmap <leader>do <Plug>(coc-codeaction)
nnoremap <silent> <leader>gm :CocList --normal marks<cr>
nnoremap <silent> <leader>gp :CocList sessions<cr>
" 查看文档,并跳转
nnoremap <silent> <m-q> :call <SID>show_documentation()<CR>zz
" 打开鼠标位置下的链接
nmap <silent> <leader>re <Plug>(coc-rename)
" 重构
imap <silent> <c-m-v> <esc><Plug>(coc-codeaction)
nmap <silent> <c-m-v> <Plug>(coc-codeaction)
vmap <silent> <c-m-v> <Plug>(coc-codeaction-selected)




" ==============================
" 编辑, 跳转功能增强
" ==============================

" 快速移动
Plug 'easymotion/vim-easymotion', {'on': '<Plug>(easymotion-bd-f)'}
map <silent> <leader>f <Plug>(easymotion-bd-f)
" easymotion可以根据中文拼音首字母跳转
Plug 'ZSaberLv0/vim-easymotion-chs'  " (不能延迟加载，否则easymotion不能正常使用)

" 快速注释
Plug 'preservim/nerdcommenter', {'on': '<plug>NERDCommenterToggle'}
"{{{
let g:NERDSpaceDelims = 1  " Add spaces after commeqt delimiters by default
let g:NERDDefaultAlign = 'left'  " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDAltDelims_java = 1  " Set a language to use its alternate delimiters by default
let g:NERDTrimTrailingWhitespace = 1  " Enable trimming of trailing whitespace when uncommenting
let g:NERDCommentEmptyLines = 1  " Allow commenting and inverting empty lines (useful when commenting a region)
"}}}
map <c-_> <plug>NERDCommenterToggle
imap <c-_> <esc><plug>NERDCommenterToggle

" Vim-Surround快捷操作
Plug 'tpope/vim-surround'
nmap ysw ysiw
nmap ysW ysiW
" 快速添加pair
" TIP: cswb == ysiwb, 用于<cword> 而<leader>{?}用于<cWORD>
nnoremap <leader>" :normal ysiW"<cr>gv<esc>
nnoremap <leader>' :normal ysiW'<cr>gv<esc>
nnoremap <leader>* :normal ysiW*<cr>gv<esc>
nnoremap <leader><leader>* :normal ysiW*<cr>:normal ysiW*<cr>gv<esc>
nnoremap <leader>( :normal ysiW)<cr>gv<esc>
nnoremap <leader>[ :normal ysiW]<cr>gv<esc>
nnoremap <leader>{ :normal ysiW}<cr>gv<esc>
" surround with <>
nnoremap <leader>< :normal ysiW><cr>gv<esc>
" surround with <tag></tag>
nnoremap <leader>> :normal ysiW<<cr>gv<esc>
" 这里对|进行了转义
nnoremap <leader>\| :normal ysiW\|<cr>gv<esc>
nnoremap <leader>` :normal ysiW`<cr>gv<esc>

vmap <leader>" S"gv<esc>
"{{{ Visual添加同上
vmap <leader>' S'gv<esc>
vmap <leader>* S*gv<esc>
vmap <leader><leader>* S*gvS*gv<esc>
vmap <leader>( S(gv<esc>
vmap <leader>[ S]gv<esc>
vmap <leader>{ S}gv<esc>
vmap <leader>< S>gv<esc>
vmap <leader>> S<gv<esc>
vmap <leader>\| S\|gv<esc>
vmap <leader>` S`gv<esc>
"}}}

nnoremap ," :normal ds"<cr>
"{{{ 删除同上
nnoremap ,' :normal ds'<cr>
nnoremap ,* :normal ds*<cr>
nnoremap ,,* :normal ds*<cr>:normal ds*<cr>
nnoremap ,( :normal ds(<cr>
nnoremap ,[ :normal ds[<cr>
nnoremap ,{ :normal ds{<cr>
nnoremap ,< :normal ds><cr>
nnoremap ,> :normal dst<cr>
nnoremap ,\| :normal ds\|<cr>
nnoremap ,` :normal ds`<cr>
"}}}



" %匹配对象增强, 也许可以把%改成m
Plug 'andymass/vim-matchup'
"{{{
let loaded_matchit = 1
let g:loaded_matchit = 1  " 禁用vim默认自带插件
let g:loaded_matchparen = 1
augroup matchup_matchparen_highlight
  autocmd!
  autocmd Colorscheme * hi! link MatchParen Visual
augroup END
"}}}

" 快速交换 cx{object} cxx行 可视模式用X  取消用cxc  可以用 . 重复上次命令
Plug 'tommcdo/vim-exchange', {'on': [ '<Plug>(Exchange)', '<Plug>(ExchangeLine)' ]}
nmap cx <Plug>(Exchange)
xmap X <Plug>(Exchange)
nmap cxc <Plug>(ExchangeClear)
nmap cxx <Plug>(ExchangeLine)

" 快速对齐文本
Plug 'junegunn/vim-easy-align', {'on': '<Plug>(EasyAlign)'}
" Start interactive EasyAlign in visual mode (e.g. vipga=)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip=)
nmap ga <Plug>(EasyAlign)

" 快速移动参数，数组里的元素 html, css, js中object属性
Plug 'AndrewRadev/sideways.vim', {'on': ['SidewaysLeft', 'SidewaysRight']}
nnoremap tl :SidewaysRight<cr>
nnoremap th :SidewaysLeft<cr>

" 驼峰跳转 FIXME: 修改了默认的b w e映射
Plug 'bkad/CamelCaseMotion'
let g:camelcasemotion_key = '<C-S-M-F12>'  " 禁用默认快捷键
"{{{
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
omap <silent> iw <Plug>CamelCaseMotion_iw
xmap <silent> iw <Plug>CamelCaseMotion_iw
sunmap w
sunmap b
sunmap e
"}}}

" 支持v:count 块选择模式整列的递增/减数字 <c-a> <c-x> 支持数字，字母，十六进制, 二进制
Plug 'triglav/vim-visual-increment', {'on': ['<Plug>(VisualIncrement)', '<Plug>(VisualDecrement)']}
set nrformats=alpha,hex,bin
vmap <c-a> <Plug>(VisualIncrement)
vmap <c-x> <Plug>(VisualDecrement)

" 移动选中文本, 支持v:count
Plug 'matze/vim-move', {'on': [ '<Plug>MoveBlockDown', '<Plug>MoveBlockUp', '<Plug>MoveBlockLeft', '<Plug>MoveBlockRight']}
"{{{
let g:move_map_keys = 0  " 禁用默认快捷键
"}}}
let g:move_auto_indent = 0  " 禁止移动完成后自动缩进
vmap <m-j> <Plug>MoveBlockDown
vmap <m-k> <Plug>MoveBlockUp
vmap <m-h> <Plug>MoveBlockLeft
vmap <m-l> <Plug>MoveBlockRight


" ============================
" UI相关
" ============================

" 启动页面
Plug 'mhinz/vim-startify'
"{{{
let g:startify_lists = [
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ { 'type': 'files',     'header': ['   MRU']            },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ ]

let g:startify_files_number = 15  " 首页显示的MRU文件数量
let g:startify_update_oldfiles = 1  " 自动更新文件
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
nnoremap <leader>ps :SSave .vim<left><left><left><left>
nnoremap <leader>pl :SLoad<cr>
nnoremap <leader>pc :SClose<cr>
nnoremap <leader>pd :SDelete!<cr>

" Vista浏览tags, 函数，类 大纲
Plug 'liuchengxu/vista.vim', {'on': 'Vista'}
"{{{
let g:vista_default_executive = 'ctags'  " Executive used when opening vista sidebar without specifying it.
let g:vista#renderer#enable_icon = 1  " Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
"}}}
nnoremap <leader>ot :Vista<cr>

" 查看uodo历史及持久化
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}
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

" 更方便地调整window
Plug 'simeji/winresizer', {'on': 'WinResizerStartResize'}
"{{{
let g:winresizer_gui_enable = 1  " gui的vim也能调整窗口大小
let g:winresizer_start_key = ''
let g:winresizer_gui_start_key = ''
let g:winresizer_vert_resize = 3  " 每次移动的步幅
"}}}
" usage: 进入resize模式后，hjkl可以调整窗口大小，enter确认，q取消, m移动模式，
" r调整窗口模式，f选择窗口模式
nnoremap <leader>wr :WinResizerStartResize<cr>
nnoremap <leader>wm :WinResizerStartResize<cr>m

" 为内置终端提供方便接口
Plug 'kassio/neoterm'
"{{{
let g:neoterm_autojump = 1  " 自动进入终端
let g:neoterm_autoinsert = 1  " 进入终端默认插入模式
let g:neoterm_use_relative_path = 1
let g:neoterm_autoscroll = 1
let g:neoterm_size = 10  " 调整terminal的大小
"}}}
nnoremap <silent> <m-m> :botright Ttoggle<cr>
nnoremap <silent> <m-j> :botright Topen<cr>
inoremap <silent> <m-j> <esc>:botright Topen<cr>
" 内置终端
tnoremap <m-h> <c-\><c-n><c-w>h
tnoremap <m-l> <c-\><c-n><c-w>l
tnoremap <m-j> <c-\><c-n><c-w>j
tnoremap <m-k> <c-\><c-n><c-w>k<esc>
tnoremap <m-n> <c-\><c-n>
" 粘贴寄存器0的内容到终端
tnoremap <expr> <m-p> '<C-\><C-n>"0pi'
tnoremap <silent> <m-m> <c-\><c-n>:Ttoggle<cr>

" Todo List 和 笔记，文档管理
Plug 'vimwiki/vimwiki', {'on': ['VimwikiIndex']}
"{{{
" 使用markdown而不是vimwiki的语法
"let g:vimwiki_list = [{'path': '~/vimwiki/',
            \ 'syntax': 'markdown', 'ext': '.md'}]
"}}}

" Sink沉浸写作模式
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
"{{{
nnoremap <silent> ,sn :Goyo<cr>
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  Limelight
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  Limelight!
  call s:Enable_normal_scheme()  " 恢复折叠和column的颜色
endfunction
"}}}
augroup goyo_toggle_callback
    autocmd!
    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup end

" 模糊非视觉中心的字符
Plug 'junegunn/limelight.vim', {'on': 'Limelight'}

" 多语言debug支持 FIXME: 这个插件还在开发阶段，可能会有很多bug
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-c --enable-python', 'on': '<Plug>VimspectorContinue'}
"{{{
sign define vimspectorBP text=🔴 texthl=Normal
sign define vimspectorBPDisabled text=🔵 texthl=Normal
sign define vimspectorPC text=🔶 texthl=SpellBad
"}}}
" nmap <F5> :call vimspector#launch()<cr>
nmap <F5> <Plug>VimspectorContinue
nmap <F6> <Plug>VimspectorStepOver
nmap <F7> <Plug>VimspectorStepInto
nmap <F8> <Plug>VimspectorStepOut
nmap <F9> :call vimspector#ToggleBreakpoint()<cr>
nmap <F10> :VimspectorReset

" nmap <Plug>VimspectorContinue
" nmap <Plug>VimspectorStop
" nmap <Plug>VimspectorRestart
" nmap <Plug>VimspectorPause
" nmap <Plug>VimspectorToggleBreakpoint
" nmap <Plug>VimspectorAddFunctionBreakpoint

" 查看各个插件启动时间
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }

" MarkDown预览
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } , 'for':['markdown', 'vimwiki'] , 'on': '<Plug>MarkdownPreviewToggle'}
let g:mkdp_command_for_global = 0  " 所有文件中可以使用预览markdown命令
nmap <leader>mp <Plug>MarkdownPreviewToggle

" 编辑嵌套的代码，可以有独立的缩进和补全，使用场景: JS, Css在Html里面，
" Markdown内嵌代码，Vue组件，代码内嵌SQL
Plug 'AndrewRadev/inline_edit.vim', {'on': 'InlineEdit'}

" keymap提示
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
nnoremap <silent> <leader> :WhichKey '<space>'<cr>
nnoremap <silent> , :WhichKey ','<cr>
nnoremap <silent> g :WhichKey 'g'<cr>




" ================================
" Project增强
" ================================

" 切换到项目根目录
Plug 'airblade/vim-rooter', {'on': 'Rooter'}
"{{{
let g:rooter_manual_only = 1  " 停止自动目录
let g:rooter_resolve_links = 1  " resolve软硬链接
let g:rooter_silent_chdir = 1  " 静默change dir
"}}}
" 手动切换到项目根目录
nnoremap <leader>rt :Rooter<cr>:echo printf('Rooter to %s', FindRootDirectory())<cr>

" 模糊搜索 弹窗后按<c-r>进行正则搜索模式, visual模式 '*' 查找函数依赖这个插件，所以不要延迟加载
Plug 'Yggdroot/LeaderF', {'do': './install.sh'}
"{{{
let g:Lf_PreviewResult = {
      \ 'File': 0,
      \ 'Buffer': 0,
      \ 'Mru': 0,
      \ 'Tag': 0,
      \ 'BufTag': 0,
      \ 'Function': 0,
      \ 'Line': 0,
      \ 'Colorscheme': 0,
      \ 'Rg': 0,
      \ 'Gtags': 0
      \}
let g:Lf_RgConfig = [
      \ '--glob=!\.git/*',
      \ '--glob=!\.vscode/*',
      \ '--glob=!\.svn/*',
      \ '--glob=!\.hg/*',
      \ '--multiline',
      \ '--hidden',
      \ "-g '!.git'"
      \ ]
let g:Lf_WildIgnore = {
            \ 'dir': ['.svn','.git','.hg','.vscode','.wine','.deepinwine','.oh-my-zsh'],
            \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
            \}

" popup的normal模式是否自动预览
let g:Lf_PreviewResult = {
        \ 'File': 1,
        \ 'Buffer': 1,
        \ 'Mru': 0,
        \ 'Tag': 1,
        \ 'BufTag': 1,
        \ 'Function': 1,
        \ 'Line': 1,
        \ 'Colorscheme': 0,
        \ 'Rg': 1,
        \ 'Gtags': 1
        \}

let g:Lf_WindowPosition = 'popup'
let g:Lf_PopupWidth = 0.66
let g:Lf_PopupHeight = 0.3
let g:Lf_PreviewInPopup = 1  " <c-p>预览弹出窗口
let g:Lf_CursorBlink = 0  " 取消光标闪烁
let g:Lf_ShowHidden = 1  " 搜索结果包含隐藏文件

let g:Lf_WindowHeight = 0.4  " 非popup窗口的高度
let g:Lf_HistoryNumber = 200  " default 100
" let g:Lf_GtagsAutoGenerate = 1  " 有['.git', '.hg', '.svn']之中的文件时自动生成gtags
let g:Lf_GtagsSource = 2  " 从指定地方找
let g:Lf_GtagsfilesCmd = {'default': 'rg --no-messager --files ~/.cache/tags_dir' }
let g:Lf_RecurseSubmodules = 1  " show the files in submodules of git repository
let g:Lf_Gtagslabel =  "native-pygments"  " 如果不是gtags支持的文件类型，就用pygments
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2"  }  " 分隔符样式
" let g:Lf_FollowLinks = 1  " 是否解析本为link的目录
let g:Lf_WorkingDirectoryMode = 'a'  " the nearest ancestor of current directory that contains one of directories
                                     " or files defined in |g:Lf_RootMarkers|. Fall back to 'c' if no such
                                     " ancestor directory found.
let g:Lf_ShortcutF = ''  " 这两项是为了覆盖默认设置的键位
let g:Lf_ShortcutB = ''
"}}}
let g:Lf_CommandMap = {'<C-]>':['<C-l>']}  " 搜索后<c-l>在右侧窗口打开文件
nnoremap <silent> <c-p> :Leaderf command<cr>
nnoremap <silent> <leader>gf :Rooter<cr>:Leaderf file<cr>
nnoremap <silent> <leader>gb :Leaderf buffer<cr>
nnoremap <silent> <leader>gr :Leaderf mru<cr>
nnoremap <silent> <leader>gc :Leaderf cmdHistory<cr>
nnoremap <silent> <leader>gs :Leaderf searchHistory<cr>
" 项目下即时搜索
nnoremap <silent> <leader>rg :Rooter<cr>:<C-U>Leaderf rg<cr>
" 项目下搜索词 -F是fix 即不是正则模式
nnoremap <silent> <Leader>sw :Rooter<cr>:<C-U><C-R>=printf("Leaderf! rg -F %s", expand("<cword>"))<CR><cr>
nnoremap <silent> <Leader>sW :Rooter<cr>:<C-U><C-R>=printf("Leaderf! rg -F %s", expand("<cWORD>"))<CR><cr>
xnoremap <silent> <leader>sw :Rooter<cr>:<C-U><C-R>=printf("Leaderf! rg -F %s", leaderf#Rg#visual())<CR><cr>
" buffer内即时搜索
nnoremap <silent> / :Leaderf rg --current-buffer<cr>
" buffer内搜索词
xnoremap <silent> * :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer %s", leaderf#Rg#visual())<CR><cr>

" Project/buffer内替换 (默认搜索隐藏文件)
Plug 'brooth/far.vim'  " 因为奇怪的遮罩原因，不建议使用on来延迟加载
"{{{
let g:far#mode_open = {'regex': 0, 'case_sensitive': 0, 'word': 0, 'substitute': 1}  " 默认模式,是没有正则的
let g:far#source = 'rgnvim'  " 使用rg + nvim的异步API 作为搜索源 FIXME: 如果以后换了grep工具需要换这个选项
let g:far#enable_undo = 1  " 允许按u进行undo替换
let g:far#auto_write_replaced_buffers = 1  " 自动写入
let g:far#auto_delete_replaced_buffers = 1  " 自动关闭替换完成的buffer

" 自定义快捷键提示样式
let g:far#prompt_mapping = {
    \ 'quit'           : { 'key' : '<esc>', 'prompt' : '<esc>' },
    \ 'regex'          : { 'key' : '<c-x>', 'prompt' : '<c-x>'  },
    \ 'case_sensitive' : { 'key' : '<c-a>', 'prompt' : '<c-a>'  },
    \ 'word'           : { 'key' : '<c-w>', 'prompt' : '<c-w>'  },
    \ 'substitute'     : { 'key' : '<c-f>', 'prompt' : '<c-f>'  },
    \ }
"}}}
" {{{Function: My_get_current_visual_text() 获取当前visual选择的文本
function My_get_current_visual_text() abort
    execute "normal! `<v`>y"
    return @"
endfunction
"}}}
" 定义far buffer的映射, NOTE: 如果自己的vimrc里有对应非递归映射(比如nnoremap zo)，则这个插件的映射会失效, 此外由于 插件bug导致不能映射zo  到za
" 快捷键r表示执行替换 q快速退出 x取消当前行 i激活当前行 t是toggle  他们的大写形式(X I T)表示全部行
let g:far#mapping = {
            \ 'replace_do': 'r',
            \ 'expand_all': ['zm', 'zM'],
            \ 'collapse_all': ['zr', 'zR'],
            \ }
let g:far#default_file_mask = '%'  " 命令行默认遮罩(搜索的范围)
" buffer内替换
" 其他用法: Farr交互式查找，并且可以转换成正则模式
" FIXME: 如果出现Error: File in current buffer is not readable，可以尝试修改该文件的拥有者和权限, chown和chmod重置一遍
" TIP: 已经预先复制好了要替换的内容，可以在命令行用<m-p>粘贴
nnoremap <leader>su :let @0=expand('<cword>')<cr>:Far <c-r>=expand('<cword>')<cr>  %<left><left><c-f>i
nnoremap <leader>sU :let @0=expand('<cWORD>')<cr>:Far <c-r>=expand('<cWORD>')<cr>  %<left><left><c-f>i
xnoremap <leader>su :<c-u>Far <c-r>=My_get_current_visual_text()<cr>  %<left><left><c-f>i
" Project内替换
nnoremap <leader>Su :let @0=expand('<cword>')<cr>:Rooter<cr>:Far <c-r>=expand('<cword>')<cr>  *<left><left><c-f>i
nnoremap <leader>SU :let @0=expand('<cWORD>')<cr>:Rooter<cr>:Far <c-r>=expand('<cWORD>')<cr>  *<left><left><c-f>i
xnoremap <leader>Su :Rooter<cr><c-u>:Far <c-r>=My_get_current_visual_text()<cr>  *<left><left><c-f>i

" 在quickfix窗口里编辑  " FIXME: 和quickr-preview有冲突
" Plug 'stefandtw/quickfix-reflector.vim'
let g:qf_join_changes = 1  " 允许在同一个quickfix里undo多个文件

" 自动预览quickfix  FIXME: 和quickfix-reflector.vim有冲突
Plug 'ronakg/quickr-preview.vim', {'for': 'qf'}
let g:quickr_preview_keymaps = 0  " 禁用默认映射
let g:quickr_preview_on_cursor = 1  " 自动预览

" 类似VSCode的编译/测试/部署 任务工具
Plug 'skywind3000/asynctasks.vim', {'on': 'AsyncTask'}
"{{{
let g:asyncrun_open = 6
let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg']
let g:asynctasks_term_pos = 'bottom' " tab
let g:asynctasks_term_rows = 10
let g:asynctasks_term_reuse = 1  " 如果用tab模式打开终端，则会复用
let g:asynctasks_config_name = '.git/tasks.ini'
"}}}
noremap <silent> <leader><leader>e :AsyncTaskEdit<cr>
" 触发UIEnter事件方便自动修改mapping{{{
function Async_build_file() abort
    execute 'AsyncTask file-build'
    doautocmd UIEnter
endfunc

function Async_run_file() abort
    execute 'AsyncTask file-run'
    doautocmd UIEnter
endfunc

function Async_build_project() abort
    execute 'AsyncTask project-build'
    doautocmd UIEnter
endfunc

function Async_run_project() abort
    execute 'AsyncTask project-run'
    doautocmd UIEnter
endfunc
"}}}
noremap <silent> <leader>bf :call Async_build_file()<cr>
noremap <silent> <leader>rf :call Async_run_file()<cr>
noremap <silent> <leader>bp :call Async_build_project<cr>
noremap <silent> <leader>rp :call Async_run_project<cr>

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
nmap gq <plug>(asyncrun-qftoggle)
nnoremap <leader>ma :AsyncRun -mode=term -pos=bottom -rows=10 python "$(VIM_FILEPATH)"




" ===============================
" 杂项, 优化使用体验
" ===============================

" sudo for neovim  (原来的tee trick只对vim有用，对neovim无效)
Plug 'lambdalisue/suda.vim', {'on': ['W', 'E']}
"{{{suda.vim-usage
" :E filename  sudo edit
" :W       sudo edit
"}}}
command! -nargs=1 E  edit  suda://<args>
command! W w suda://%

" 用vim看man
Plug 'lambdalisue/vim-manpager', {'on': 'Man'}
augroup temporar_change_manpager_mapping
    autocmd!
    autocmd FileType man nmap <silent> <buffer> <C-j> ]t
    autocmd FileType man nmap <silent> <buffer> <C-k> [t
augroup end

" 显示搜索的的数量以及当前位置
Plug 'osyo-manga/vim-anzu'
nmap n <Plug>(anzu-n-with-echo)zz
nmap N <Plug>(anzu-N-with-echo)zz
nmap * <Plug>(anzu-star-with-echo)zz
nmap # <Plug>(anzu-sharp-with-echo)zz

" 优化bd体验，关闭buffer但是不关闭窗口
Plug 'mhinz/vim-sayonara', {'on': [ 'Sayonara','Sayonara!' ]}
nnoremap <silent> <leader>bd :Sayonara!<cr>

" 一键生成注释（15+种语言）NOTE: C、C++的注释依赖clang 但是似乎有bug 暂时不建议踩这个坑，c++随便注释下就好了
Plug 'kkoomen/vim-doge', {'on': 'DogeGenerate'}
let g:doge_enable_mappings = 0  " 取消默认映射
let g:doge_mapping = ''
let g:doge_filetype_aliases = {
\  'javascript': ['vue']
\}
nnoremap <leader>cc :DogeGenerate<cr>




" ================== Layer ====================
" =============================================
" 前端 和 coc系列
" =============================================
if g:enable_front_end_layer == 1

    " coc-import-cost (仅用于JS和TS)
    " coc-github
    " coc-css-block-comments
    " coc-sql (lint和format, format似乎要手动, 看ale能不能自动调用这个插件自带的sql-formatter把)

    " Node.js支持
    " Plug 'moll/vim-node', {'for': [ 'javascript', 'typescript', '*jsx', '*tsx' ]}

    " 实时预览html,css,js
    Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server', 'on': 'Bracey'}
    nnoremap <leader>pv :Bracey<cr>

    " 具体的snippets见 https://github.com/mlaursen/vim-react-snippets
    Plug 'mlaursen/vim-react-snippets'

    " plug 模板引擎
    Plug 'digitaltoad/vim-pug'

    " 选择，插入，修改css颜色,配合取色器, NOTE: 可能不支持nvim
    Plug 'kabbamine/vCoolor.vim', {'on': ['VCoolor', 'VCoolIns']}
    let g:vcoolor_disable_mappings = 1  " 取消默认快捷键

    " ix ax XML/HTML属性文本对象
    Plug 'whatyouhide/vim-textobj-xmlattr'

endif













" 打算以后再体验的插件

" 多光标插件有bug 用不了

" 似乎是vim唯一的test插件, 支持CI
" Plug 'janko/vim-test'
"
" SQL Wrapper (不建议使用另一个插件vim-sql-workbench 因为太麻烦了)
" Plug 'joereynolds/SQHell.vim'

" 数据库接口(似乎只能查询)
" Plug 'tpope/vim-dadbod'
" 数据库接口的ui
" Plug 'kristijanhusak/vim-dadbod-ui'

" 让代码在一行和多行之间转换
" Plug 'AndrewRadev/splitjoin.vim'

" Github支持
"Plug 'junegunn/vim-github-dashboard'

" 为不同的文件类型设置不同的tab expand 编码 EOF
"Plug 'editorconfig/editorconfig-vim'

" 快速创建表格
"Plug 'dhruvasagar/vim-table-mode'


" 以下插件可能用不到，作为备用吧

" Vue支持
" neoclide/coc-vetur
"

" React NOTE: 因为有coc-tsserver了 不确定需不需要
" coc作者早期的插件，高亮以及缩进, js对jsx的适配
" Plug 'neoclide/vim-jsx-improve'

" 最新的 Stylus 语法高亮，可能被polyglot替代了
" Plug 'iloginow/vim-stylus'

" }}}
call plug#end()

"==========================================
" 自定义命令
"==========================================
"{{{ Ctabs: Open all files in quickfix window in tabs
command! Ctabs call s:Ctabs()
function! s:Ctabs()
  let files = {}
  for entry in getqflist()
    let filename = bufname(entry.bufnr)
    let files[filename] = 1
  endfor

  for file in keys(files)
    silent exe "tabedit ".file
  endfor
endfunction
"}}}
"{{{ Gfiles: Open all git-modified files in tabs
command! Gfiles call s:Gfiles()
function! s:Gfiles()
  let files = split(system('git status -s -uall | cut -b 4-'), '\n')

  for file in files
    silent exe "tabedit ".file
  endfor
endfunction
"}}}
"{{{ Repeatable: Make the given command repeatable using repeat.vim
command! -nargs=* Repeatable call s:Repeatable(<q-args>)
function! s:Repeatable(command)
  exe a:command
  call repeat#set(':Repeatable '.a:command."\<cr>")
endfunction
"}}}
command! Chmodx :!chmod a+x %  " make current buffer executable
command! FixSyntax :syntax sync fromstart  " fix syntax highlighting



"==========================================
" HotKey Settings  自定义快捷键设置
"==========================================
" 如果需要覆盖插件定义的映射，可用如下方式
" autocmd VimEnter * noremap <leader>cc echo "my purpose"

" 主要按键重定义
inoremap kj <esc>
cnoremap kj <c-c>
nnoremap ? /
noremap ; :
nmap zo zazz
noremap ,; ;
nnoremap ,w :w<cr>
" 解决通过命令let @" = {text}设置的@" 不能被p正确粘贴的问题
nnoremap p ""p
vnoremap v <esc>
" 我喜欢使用分号作为插入模式的 leader 键，因为分号后面除了空格和换行之外几乎不会接任何其他字符
" 快速在行末写分号并换行
inoremap ;j <c-o>A;<cr>
inoremap ;; <c-o>A;<esc>jo
" NOTE: 这里用imap是因为要借用auto-pairs插件提供的{}自动配对
imap [[ <esc>A<space>{<cr>
" 重复上次执行的寄存器的命令
nnoremap <leader>r; @:
" {{{ Quickly make a macro and use it with "."
let s:simple_macro_active = 0
function! s:my_simple_macro()
    if s:simple_macro_active == 0
        normal! qr
        let s:simple_macro_active = 1
    elseif s:simple_macro_active == 1
        normal! q
        let s:simple_macro_active = 0
    endif
endfunction
"}}}
nnoremap <silent> M :call <SID>my_simple_macro()<cr>
nnoremap R @r
" xnoremap <expr> <leader>@ ":norm! @".nr2char(getchar())."<CR>"
xnoremap <expr> R ":norm! @r<CR>"

" 替换模式串 NOTE: 目前被Far.vim插件替代, 但是由于那个插件有bug，有时候不能替换，所以留着这个备用了
nnoremap ,su :let @0=expand('<cword>')<cr>:%s/<c-r>=expand('<cword>')<cr>//gc<left><left><left><c-f>i
nnoremap ,sU :let @0=expand('<cword>')<cr>:%s/<c-r>=expand('<cWORD>')<cr>//gc<left><left><left><c-f>i
xnoremap  ,su :<c-u>%s/<c-r>=My_get_current_visual_text()<cr>//gc<left><left><left><c-f>i

" 退出系列
noremap <silent> <leader>q <esc>:q<cr>
"{{{ 自动保存会话
function s:auto_save_session() abort
    let session_name = fnamemodify(v:this_session,':t')
    let session_name = session_name == '' ? 'default.vim' : session_name
    execute 'SSave! ' . session_name
    execute 'qa'
endfunction
"}}}
noremap <silent> Q <esc>:call <SID>auto_save_session()<cr>

"Treat long lines as break lines (useful when moving around in them)
"se swap之后，同物理行上线直接跳
noremap j gjzz
noremap k gkzz
nnoremap zj zjzz
nnoremap zk zkzz
" 在同一个折叠的首位跳转
nnoremap zzj ]zzz
nnoremap zzk [zzz
noremap J <C-f>zz
noremap K <C-b>zz
nmap gb %zz
" 去上次修改的地方
nnoremap gi gi<esc>zzi
" goto previous/next change positon
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap gv gvzz
" 定义这个是为了让which-key查询的时候不报错
nnoremap gg gg
" 切换大小写
nnoremap gu viw~
nnoremap gU viW~
vnoremap gu ~
nnoremap '' ``zz
nnoremap '. `.zz
nnoremap <c-o> <c-o>zz
nnoremap <c-i> <c-i>zz
nnoremap u uzz
nnoremap <c-r> <c-r>zz
nnoremap G Gzz
nnoremap [z [zzz
nnoremap ]z ]zzz

nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $h
noremap Y y$
nnoremap yh y^
nnoremap yl y$
nnoremap dh d0
nnoremap dl d$
nnoremap ch c0
nnoremap cl c$

" 去掉搜索高亮
" nnoremap <silent> <leader>/ :nohls<cr>zz

" 命令行和插入模式增强
" 上下相比于<c-n> <c-p>更智能的地方:  可以根据已输入的字符补全历史命令
cnoremap ' ''<left>
cnoremap " ""<left>
cnoremap ( ()<left>
cnoremap <c-k> <up>
cnoremap <c-j> <down>
cnoremap <c-h> <left>
cnoremap <c-l> <right>
cnoremap <c-e> <delete>
cnoremap <m-p> <c-r>0

inoremap <c-h> <esc>I
inoremap <c-l> <esc>A
nnoremap <c-h> ^
nnoremap <c-l> $
inoremap <c-e> <delete>
inoremap <m-p> <c-r>0
nnoremap <m-p> "0p

" Buffer操作
nnoremap <silent> <m-l> :bp<cr>
nnoremap <silent> <m-h> :bn<cr>
"{{{删除隐藏的buffer
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

" Window操作
nnoremap <leader>wh <c-w>wH
nnoremap <leader>wj <c-w>wJ
nnoremap <leader>wk <c-w>wK
nnoremap <leader>wl <c-w>wL
nnoremap <leader>wf <c-w><c-r>
nnoremap <leader>ws <c-w>s<c-w>w
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
" {{{Quit tab, even if it's just one
function! s:my_quit_tab()
  for bufnr in tabpagebuflist()
    if bufexists(bufnr)
      let winnr = bufwinnr(bufnr)
      exe winnr.'wincmd w'
      quit
    endif
  endfor
endfunction
"}}}
" nnoremap <c-w> :call <SID>my_quit_tab()<cr>
nnoremap <c-w> :tabclose<cr>
inoremap <c-t> <esc>:tab split<cr>
" normal模式下切换到确切的tab
for s:count_num in [1,2,3,4,5,6,7,8,9]
    exec 'nnoremap <leader>' . s:count_num . ' ' . s:count_num . 'gt'
endfor

" 调整缩进后自动选中，方便再次操作
vnoremap < <gv
vnoremap > >gv
nnoremap < <<
nnoremap > >>

" 选择全部
nnoremap <leader>so ggVG
" 交换 ' `, 使得可以快速使用'跳到marked相同的位置
noremap ' `
noremap ` '
" 让y复制后光标仍在原位
vnoremap y ygv<Esc>
" 让normal模式的s和x不要污染无名寄存器, 因为一个字母没有必要覆盖之前的寄存器内容
nnoremap s "_s
nnoremap x "_x

"==========================================
" Theme Settings  主题设置
"==========================================
set termguicolors  " 使用真色彩
exec 'colorscheme ' . g:all_colorschemes[g:default_colorscheme_mode]
" colorscheme quantum
" colorscheme onedark
" colorscheme gruvbox-material
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
set autoread  " 文件在外界被修改之后自动载入
set autowriteall  " edit, next等动作时自动写入
set timeout ttimeoutlen=50  " 连续识别按键的延迟
set clipboard+=unnamedplus
set shortmess=atI  " 启动的时候不显示那个援助乌干达儿童的提示
set noswapfile
set nobackup nowritebackup  " 取消备份文件
set updatecount =100  " FIXME:如果编辑大文件很慢那么考虑调大这个值 After typing this many characters the swap file will be written to disk
set cursorline  " 突出显示当前行
set diffopt+=vertical,algorithm:patience
set sessionoptions+=tabpages,globals,localoptions
set synmaxcol=200  " 每次只渲染200行而不是整个文件
" set t_ti= t_te=  " 设置 退出vim后，内容显示在终端屏幕, 可以用于查看和复制, 不需要可以去掉, 好处：误删什么的，如果以前屏幕打开，可以找回
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
set showbreak=⤷▶  " 显示wrapline
set backupcopy=yes  " Does not break hard/symbolic links on file save

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
" FileType Settings  文件类型设置{{{

" 具体编辑文件类型的一般设置，比如不要 tab 等
augroup tab_indent_settings_by_filetype
    autocmd!
    autocmd FileType python,ruby,javascript,html,css,xml,sass,scss set tabstop=4 shiftwidth=4 softtabstop=4 expandtab ai
    autocmd BufRead,BufNewFile *.md,*.mkd,*.markdown set filetype=markdown
    autocmd BufRead,BufNewFile *.part set filetype=html
    autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
    autocmd BufWinEnter *.php set mps-=<:>  " disable showmatch when use > in php
    autocmd FileType make setlocal noexpandtab shiftwidth=4 softtabstop=0
    " 下两行是coc-tsserver这么要求的
    autocmd BufRead,BufNewFile *.jsx set filetype=javascript.jsx
    autocmd BufRead,BufNewFile *.tsx set filetype=typescript.tsx
    " NOTE: 如果js之类的大文件高亮渲染不同步 可以开启这两个可能影响性能的选项
    " autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
    " autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear"

augroup end
"}}}
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
set foldenable  " 代码折叠 zM全部折叠 zR全部打开 zo开关一个折叠

function Change_fold_method_by_filetype()
    set foldlevel=99  " 第一次进入时不折叠
    let s:marker_fold_list = ['vim', 'txt', 'zsh', 'tmux']  " 根据文件类型选择不同的折叠模式
    let s:indent_fold_list = ['python']
    let s:expression_fold_list = ['markdown', 'rust']
    if index(s:marker_fold_list, &filetype) >= 0
        set foldmethod=marker  " marker    使用标记进行折叠, 默认标记是 { { { 和 } } }
        set foldlevel=0  " 第一次进入时全部自动折叠
    elseif index(s:indent_fold_list, &filetype) >= 0
        set foldmethod=indent
    elseif index(s:expression_fold_list, &filetype) >= 0
        set foldmethod=expr
    else
        set foldmethod=syntax
    endif
endfunction

augroup auto_change_fold_method
   autocmd!
   autocmd BufWinEnter * call Change_fold_method_by_filetype()
augroup end
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
augroup auto_actions_for_better_experience
    autocmd!
    " 自动source VIMRC
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
    " 打开自动定位到最后编辑的位置, FIXME: 需要确认 .viminfo 当前用户有可写权限
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exec "normal! g'\" \| zz" | endif
    " 进入新窗口始终让viewport居中
    autocmd BufWinEnter * exec 'normal! zz'
    " 在右边窗口打开help,man
    autocmd filetype man,help wincmd L
    "{{{ <c-j><c-k>移动quickfix
    function List_is_opened(type) abort
        if a:type == "quickfix"
            let g:my_check_quickfix_ids = getqflist({"winid" : 1})
        endif
        return get(g:my_check_quickfix_ids, "winid", 0) != 0
    endfunction
    "
    function Change_mapping_for_quickfix() abort
        if List_is_opened("quickfix")
            nnoremap <silent> <c-j> :cnext<cr>
            nnoremap <silent> <c-k> :cprevious<cr>
            nnoremap <silent> q :cclose<cr>:normal! zz<cr>:doautocmd UILeave<cr>
        else
            nnoremap <c-j> :call ScrollAnotherWindow(2)<CR>
            nnoremap <c-k> :call ScrollAnotherWindow(1)<CR>
            nmap q q
        endif
    endfunction
    "}}}
    autocmd UIEnter,UILeave,WinEnter,WinLeave,BufLeave,BufEnter * call Change_mapping_for_quickfix()
    " 进入diff模式关闭语法高亮，离开时恢复语法高亮 FIXME: 不确定会不会有性能问题
    autocmd User MyEnterDiffMode if &diff | windo setlocal syntax=off | wincmd w
    " FIXME: 这里的set syntax=on可能会影响某些特殊的文件类型的高亮渲染
    autocmd WinEnter,WinLeave * if (&filetype != '' && &filetype != 'far' && !&diff) | set syntax=on | endif
augroup end

" 开启语法高亮
syntax on  " NOTE: 这条语句放在不同的地方会有不同的效果，经测试,放在这里是比较合适的

" 特定标记配色 TODO: FIXME: BUG: NOTE: HACK:
"{{{
function Custom_sign_highlighting()
    highlight MyTodo cterm=bold ctermbg=180 ctermfg=black gui=bold guifg=#ff8700
    highlight MyNote cterm=bold ctermbg=75 ctermfg=black gui=bold guifg=#19dd9d
    highlight MyFixme cterm=bold ctermbg=189 ctermfg=black gui=bold guifg=#e697e6
    highlight MyBug cterm=bold ctermbg=168 ctermfg=black gui=bold guifg=#dd698c
    highlight MyHack cterm=bold ctermbg=240 ctermfg=black gui=bold guifg=#f4da9a
    highlight link MyTip MyHack
endf

augroup highlight_my_keywords
    autocmd!
    autocmd Syntax * call matchadd('MyTodo',  '\W\zs\(TODO\|CHANGED\|XXX\|DONE\):')
    autocmd Syntax * call matchadd('MyNote',  '\W\zsNOTE:')
    autocmd Syntax * call matchadd('MyFixme',  '\W\zsFIXME:')
    autocmd Syntax * call matchadd('MyBug',  '\W\zsBUG:')
    autocmd Syntax * call matchadd('MyHack',  '\W\zsHACK:')
    autocmd Syntax * call matchadd('MyTip',  '\W\zsTIP:')
augroup end
"}}}

"{{{startify启动页面的颜色
highlight! StartifyHeader cterm=bold ctermbg=black ctermfg=75 gui=bold guifg=#87bb7c
highlight! StartifyFile cterm=None ctermfg=75 gui=None guifg=#d8b98a
highlight! StartifyNumber cterm=None ctermfg=75 gui=None guifg=#7daea3
"}}}

" =============================================
" 新增功能
" =============================================
" {{{自动保存
function! s:Autosave(timed)
    if &readonly || mode() == 'c' || pumvisible()
        return
    endif
    let current_time = localtime()
    let s:last_update = get(s:, 'last_update', 0)
    let s:time_delta = current_time - s:last_update

    if a:timed == 0 || s:time_delta >= 1
        let s:last_update = current_time
        if &buftype != 'nofile'  " 不对非文件的buffer进行检测
            checktime  " checktime with autoread will sync files on a last-writer-wins basis. FIXME: 但是在命令行按<c-f>进入normal-command编辑模式会报错的
        endif
        silent! doautocmd BufWritePre %  " needed for soft checks
        silent! update  " only updates if there are changes to the file.
        if a:timed == 0 || s:time_delta >= 4
            silent! doautocmd BufWritePost %  " Periodically trigger BufWritePost.
        endif
    endif
endfunction

if g:enable_file_autosave
    augroup WorkspaceToggle
        au! BufLeave,FocusLost,FocusGained * call s:Autosave(0)
        au! CursorHold * call s:Autosave(1)
    augroup END
endif
"}}}
"{{{让JSONC的注释显色正常
augroup enable_comment_highlighting_for_json
    autocmd FileType json syntax match Comment +\/\/.\+$+
augroup end
"}}}
"{{{ 更方便的跳转标记
let s:alphabet =['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
            \'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
            \'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
            \'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',]
for single_char in s:alphabet
    exec "nnoremap '" . single_char . ' `' . single_char . 'zz'
endfor
"}}}

" 废弃ZZ退出
noremap ZZ <nop>

" {{{ <F2> 行号开关，用于鼠标复制代码用, 为方便复制
function! ToggleColumnNumber()
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
nnoremap <F2> :call ToggleColumnNumber()<cr>

"{{{ <F4> 部分插件开关，提升大文件编辑体验
function Faster_mode_for_large_file()
    " 开关spelunker拼写检查插件
    execute 'normal ZT'
    execute 'SignifyToggle'
endfunction
"}}}
nnoremap <F4> :call Faster_mode_for_large_file()<cr>

" 代码高亮开关
" nnoremap <F4> :exec exists('syntax_on') ? 'syn off' : 'syn on'<cr>

"{{{当有两个窗口时, 滚动另一个窗口
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

" {{{切换透明模式, 需要预先设置好终端的透明度
let s:palette = {
              \ 'bg0':        ['#282828',   '235',  'Black'],
              \ 'bg1':        ['#302f2e',   '236',  'DarkGrey'],
              \ 'bg2':        ['#32302f',   '236',  'DarkGrey'],
              \ 'fg0':        ['#d4be98',   '223',  'White'],
              \ 'fg1':        ['#ddc7a1',   '223',  'White'],
              \ 'red':        ['#ea6962',   '167',  'Red'],
              \ 'orange':     ['#e78a4e',   '208',  'DarkYellow'],
              \ 'yellow':     ['#d8a657',   '214',  'Yellow'],
              \ 'green':      ['#a9b665',   '142',  'Green'],
              \ 'aqua':       ['#89b482',   '108',  'Cyan'],
              \ 'grey':       ['#868d80',   '109',  'Blue'],
              \ 'purple':     ['#d3869b',   '175',  'Magenta'],
              \ 'none':       ['NONE',      'NONE', 'NONE']
              \ }

function! s:HL(group, fg, bg, ...)
    let hl_string = [
          \ 'highlight', a:group,
          \ 'guifg=' . a:fg[0],
          \ 'guibg=' . a:bg[0],
          \ ]
    if a:0 >= 1
      if a:1 ==# 'undercurl'
        call add(hl_string, 'gui=undercurl')
        call add(hl_string, 'cterm=underline')
      else
        call add(hl_string, 'gui=' . a:1)
        call add(hl_string, 'cterm=' . a:1)
      endif
    else
      call add(hl_string, 'gui=NONE')
      call add(hl_string, 'cterm=NONE')
    endif
    if a:0 >= 2
      call add(hl_string, 'guisp=' . a:2[0])
    endif
    execute join(hl_string, ' ')
endfunction

function s:Enable_normal_scheme() abort
    call s:HL('FoldColumn', s:palette.grey, s:palette.bg2)
    call s:HL('Folded', s:palette.grey, s:palette.none)
    call s:HL('SignColumn', s:palette.fg0, s:palette.none)
    call s:HL('OrangeSign', s:palette.orange, s:palette.none)
    call s:HL('PurpleSign', s:palette.purple, s:palette.none)
    " kshenoy/vim-signature 标记的配色
    highlight! link SignatureMarkText OrangeSign
    highlight! link SignatureMarkerText PurpleSign
    " highlight! LineNr guifg=#717172
    highlight! LineNr guifg=#9d9d9d

    call Custom_sign_highlighting()  " TODO: TIP: NOTE: 等的高亮
endfunction

function s:Enable_transparent_scheme() abort
    call s:HL('FoldColumn', s:palette.grey, s:palette.none)
    call s:HL('Folded', s:palette.grey, s:palette.none)
    call s:HL('SignColumn', s:palette.none, s:palette.none)
    call s:HL('OrangeSign', s:palette.orange, s:palette.none)
    call s:HL('PurpleSign', s:palette.purple, s:palette.none)
endfunction

call s:Enable_normal_scheme()


let t:is_transparent = 0
function! Toggle_transparent_background()
  if t:is_transparent == 1
    windo set cursorline
    syn off | syn on
    call s:Enable_normal_scheme()
    let t:is_transparent = 0
  else
    windo set nocursorline
    hi Normal guibg=NONE ctermbg=NONE
    call s:Enable_transparent_scheme()
    let t:is_transparent = 1
  endif
endfunction
"}}}
nnoremap <silent> <leader>tt :call Toggle_transparent_background()<CR>

" 快速编辑init.vim
nnoremap <leader>en :e $MYVIMRC<CR>
" 快速编辑tmux配置文件
nnoremap <leader>et :e $HOME/.tmux.conf<cr>
" 快速在头文件和源文件之间跳转
nnoremap <leader>eh :execute 'edit' fnamemodify(expand('%'), ':p:r') . '.h'<cr>
augroup auto_mark_C
    autocmd!
    autocmd BufLeave *.{c,cpp} mark C
augroup end
nnoremap <leader>ec :execute "normal 'C"<cr>
" 编辑该文件类型的snippets
nnoremap <leader>es :CocCommand snippets.editSnippets<cr>
" 编辑同目录下的文件
nnoremap ,e :Rooter<cr>:e <c-r>=expand('%:p:h')<cr>/
nnoremap ,n :Rooter<cr>:!mkdir <c-r>=expand('%:p:h')<cr>/
nnoremap ,N :Rooter<cr>:!mkdir <c-r>=expand(getcwd())<cr>/

" {{{查看highlighting group
function! s:synstack()
    echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), ' -> ')
endfunction
"}}}
nnoremap <F12> :<C-u>call <SID>synstack()<CR>

"{{{添加空白行
function! s:BlankUp(count) abort
    put!=repeat(nr2char(10), a:count)
    ']+1
endfunction

function! s:BlankDown(count) abort
    put =repeat(nr2char(10), a:count)
    '[-1
endfunction
"}}}
nnoremap ]<space> :<c-u>call <sid>BlankDown(v:count1)<cr>
nnoremap [<space> :<c-u>call <sid>BlankUp(v:count1)<cr>

" 当把vim作为git的difftool时，设置 git config --global difftool.trustExitCode true && git config --global mergetool.trustExitCode true
" 在git difftool或git mergetool之后  可以用:cq进行强制退出diff/merge模式，而不会不停地recall another diff/merge file
if &diff
    syn off  " 自动关闭语法高亮
    " 强制退出difftool, 不再自动唤起difftool
    noremap <leader><leader>q <esc>:cq<cr>
    noremap Q <esc>:qa<cr>
    " 在diff hunk之间跳转
    noremap ]c ]czz
    noremap [c [czz
endif

" 复制当前文件的名字，绝对路径，目录绝对路径
function Copy_to_registers(text) abort  "{{{
    let @" = a:text
    let @0 = a:text
    let @+ = a:text  " system clipboard on Linux
    let @* = a:text  " system clipboard on Windows
endfunction
"}}}
nnoremap <leader>nm :call Copy_to_registers(expand('%:t'))<cr>:echo printf('filename yanked: %s', expand('%:t'))<cr>
nnoremap <leader>ap :call Copy_to_registers(expand('%:p'))<cr>:echo printf('absolute path yanked: %s', expand('%:p'))<cr>
nnoremap <leader>dr :call Copy_to_registers(expand('%:p:h'))<cr>:echo printf('absolute dir yanked: %s', expand('%:p:h'))<cr>

"{{{ 检查Vim运行性能, 结果放在profile.log中
let g:check_performance_enabled = 0
fun Check_performance()
    if g:check_performance_enabled == 0
        execute 'profile start profile.log'
        execute 'profile file *'
        execute 'profile func *'
        let g:check_performance_enabled = 1
    else
        execute 'profile stop'
        execute 'normal Q'
    endif
endf
"}}}
nnoremap <leader>cp :call Check_performance()<cr>
"
" {{{ 实时改变colorscheme
let g:current_coloscheme_mode = g:default_colorscheme_mode
fun My_change_colorscheme(mode) abort
    let l:length = len(g:all_colorschemes)
    if a:mode < 0 || a:mode >= l:length
        echo 'failed to change colorscheme: invalid parameter'
        return ''
    endif
    if a:mode == 'next'
        if g:current_coloscheme_mode < l:length - 1
            let g:current_coloscheme_mode += 1
        else
            let g:current_coloscheme_mode = 0
        endif
    elseif a:mode == 'previous'
        if g:current_coloscheme_mode > 0
            let g:current_coloscheme_mode -= 1
        else
            let g:current_coloscheme_mode = l:length - 1
        endif
    else
        let g:current_coloscheme_mode = a:mode
    endif

    execute 'colorscheme ' . g:all_colorschemes[g:current_coloscheme_mode]
    let g:lightline.colorscheme = s:lightline_schemes[g:current_coloscheme_mode]

    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
    call s:Enable_normal_scheme()  " 恢复折叠和column的颜色
endf
"}}}
nnoremap <silent> <leader>cj :call My_change_colorscheme('next')<cr>
nnoremap <silent> <leader>ck :call My_change_colorscheme('previous')<cr>
