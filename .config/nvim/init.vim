" TODO: coc.nvim去掉特定tag版本(因为目前最新版本有bug，只能选择特定版本)
" 只考虑NeoVim，不一定兼容Vim
" 如果遇到了一些问题, 可以试着在本文件搜索FIXME, NOTE
"
" 一些经验:
"   1. 抓住主要问题, 用相对简单和有意义的按键映射出现频率高的操作, 而非常冷门的操作
"      设置较长的快捷键，或者设置成command
"   2. 最小表达力原则: 用尽可能简单的方式组合来完成复杂的需求, 比如easy-motion插件有很
"      多功能，但其实<Plug>(easymotion-bd-f)就足以胜任日常快速移动所需要的绝大部分功能, 过
"      多的快捷键及功能反而会是干扰
"
" 键位设计原则:
"   1. 有意义，容易记忆.
"   2. 每个指令均衡左右手指击键, 如果都在同一边手上则尽量用不同的手指击键，尽量减小
"      手指移动距离和次数
"
"  不建议用appimge安装，因为这样的话将nvim作为manpager会出现奇怪的权限问题
" =========================================
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
"  9.  "coc-tabnine需要**单独**用CocCommand tabnine.openConfig 设置'ignore_all_lsp': true来加强补全效果
"
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
"  7. 安装zeal: sudo add-apt-repository ppa:zeal-developers/ppa && sudo apt-get update && sudo apt-get install zeal
"       NOTE: 注意要在zeal GUI 设置 Minimize to system tray instead of taskbar
"       和　Hide to system tran on window close 这样才会每次都能快速唤出窗口
"}}}
" 【配置过程中遇到的坑】{{{
"   1. 映射<Plug>(...)时必须用递归映射
"   2. 映射ex命令的时候尽量不用noremap, 因为这可能会导致按键出现奇奇怪怪的结果, 应该改成nnoremap
"   3. vimrc文件let语句的等号两边不能有空格
"   4. 单引号是raw String 而双引号才可以转义， 所以设置unicode字体的时候应该用双引号比如"\ue0b0"
"   5. 用{'on': '<Plug>(?)'}来延迟加载时，必须要自己设置相关映射，否则无法加载(因为原插件的映射并不会被加载)，但是command就不用自己设置映射，比如
"       {'on': 'Rooter'}这种
"   6. 因为一行过长导致VimL语法不被成功解析，应该用\ 拆成多行
"   7. 如果调用了插件的函数，最好使用silent! 因为在使用--noplugin打开时，如果
"      找不到该函数且不是silent! call的话，就会一直报错，导致vim没法使用
"   8. 如果需要覆盖插件定义的映射，可用如下方式
"      autocmd VimEnter * noremap <leader>cc echo "my purpose"

"}}}

" =========================================
"{{{可自行调整的全局配置
let g:enable_front_end_layer = 1  " 前端Layer, 启动所有前端相关插件
let g:enable_file_autosave = 1  " 是否自动保存
let g:disable_laggy_plugins_for_large_file = 0  " 在启动参数里设置为1就可以加快打开速度
set updatetime=400  " 检测CursorHold事件的时间间隔,影响性能的主要因素
let g:default_colorscheme_mode = 0
let g:all_colorschemes = ['quantum', 'gruvbox-material', 'forest-night', 'pencil', 'deus', 'dracula']
let s:lightline_schemes = ['quantum', 'gruvbox_material', 'forest_night', 'forest_night', 'gruvbox_material', 'dracula']


let mapleader='<space>'  " 此条命令的位置应在插件之前
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
"}}}

" =========================================
" 插件管理
" =========================================
" {{{主要插件简介
" 1. ALE         去除多余空格空行，lint, formatter
" 2. LeaderF     模糊查找
" 3. coc         补全框架, 重构，跳转定义，其他插件生态系统
" 4. Far         可视化替换
" 5. Spelunker   拼写检查
"}}}
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
" 专为markdown适配的colorscheme
Plug 'reedes/vim-colors-pencil'
"{{{
let g:pencil_gutter_color = 0  " 灰色的signify指示图标
let g:pencil_terminal_italics = 0  " 注释不用斜体
"}}}
Plug 'ajmwagar/vim-deus'
"{{{
let g:deus_termcolors=256
"}}}
Plug 'dracula/vim'

" =================================
" 在大文件下会影响性能
" =================================
if g:disable_laggy_plugins_for_large_file == 0
    " 为spelunker提供弹窗支持, 设置的Pmenu，PmenuSel只支持cterm的
    Plug 'kamykn/popup-menu.nvim'  " 无法延迟加载
    " 拼写检查 zl出现list选择修复，zf自动使用list第一个，zg添加到词典里，zw设置为错误单词
    Plug 'kamykn/spelunker.vim'
    "{{{
    set nospell  " 禁用默认的难看的高亮红色
    let g:spelunker_check_type = 2  " 只在window内动态check, 对大文件十分友好
    let g:spelunker_highlight_type = 2  " Highlight only SpellBad.
    let s:spelunker_blacklist = ['startify', 'far', 'vim-plug', 'vim', '', 'coc-explorer']  " 这里包括了文件类型的空的buffer
    augroup my_highlight_spellbad
        autocmd!
        let g:spelunker_disable_auto_group = 1
"{{{
        fun My_should_enable_spelunker()
            if index(s:spelunker_blacklist, &filetype) >= 0 || &filetype == '' || &diff
                return 0
            endif
            return 1
        endf
"}}}
        " 用silent!的话即时不存在这个函数也不会报错，适用于--noplugin的情况
        autocmd CursorHold * if  My_should_enable_spelunker() | silent! call spelunker#check_displayed_words() | endif
    augroup end
    "}}}
    " 从词典选择相似词, 这个功能似乎有bug　会调用leaderf, 真是奇怪
    nmap zl <Plug>(spelunker-correct-from-list)
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
"{{{
let g:vim_markdown_fenced_languages = ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'csharp=cs']
"}}}

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
" 选择不高亮的文件类型
let g:Illuminate_ftblacklist = [
            \ 'vim', 'text', 'markdown', 'css', 'help',
            \ 'coc-explorer', 'vista', 'qf', 'vimwiki', 'zsh',
            \ ]
"}}}

" 选择模式和行选择模式下可以用I A批量多行写入(修改了可视模式下I和A的映射)
Plug 'kana/vim-niceblock', {'on': ['<Plug>(niceblock-I)', '<Plug>(niceblock-A)']}
"{{{
omap I <Plug>(niceblock-I)
xmap I <Plug>(niceblock-I)
xmap A <Plug>(niceblock-A)
xmap A <Plug>(niceblock-A)
"}}}

" 新增很多方便的text object, 比如 , argument in( il( 并且可以计数比如光标在a时 (((a)b)c)  --d2ab--> (c )
Plug 'wellle/targets.vim'

" 自定义text-object 是vim-textobj-variable-segment插件的依赖
Plug 'kana/vim-textobj-user'

" ii ai 在python里很好用 NOTE: 这个插件是用函数做的映射，所以不能延迟加载
Plug 'michaeljsmith/vim-indent-object', {'for': ['python']}

" vic viC vac vaC Column单词自动快选择模式, 然后按I A多列添加字符
Plug 'coderifous/textobj-word-column.vim'  " NOTE:由于插件实现原因，不能延迟加载

" ( 前一个句子，)后一个句子的开头, g(去当前句子的结尾 g)去上个句子的结尾
" NOTE:由于插件实现原因，不能延迟加载, 但是插件会自动根据文件类型加载
Plug 'reedes/vim-textobj-sentence'
"{{{
omap ix <Plug>(textobj-xmlattr-attr-i)
omap ax <Plug>(textobj-xmlattr-attr-a)
xmap ix <Plug>(textobj-xmlattr-attr-i)
xmap ax <Plug>(textobj-xmlattr-attr-a)
augroup textobj_sentence
  autocmd!
  autocmd FileType markdown silent! call textobj#sentence#init()
  autocmd FileType textile,text silent! call textobj#sentence#init()
augroup end
"}}}

" iv av variabe-text-object 部分删除变量的名字 比如camel case: getJiggyY 以及 snake case: get_jinggyy
Plug 'Julian/vim-textobj-variable-segment', {'on': ['<Plug>(textobj-variable-i)', '<Plug>(textobj-variable-a)']}
"{{{
omap iv <Plug>(textobj-variable-i)
omap av <Plug>(textobj-variable-a)
xmap iv <Plug>(textobj-variable-i)
xmap av <Plug>(textobj-variable-a)
"}}}

" ix ax XML/HTML属性文本对象
Plug 'whatyouhide/vim-textobj-xmlattr', {'on': ['<Plug>(textobj-xmlattr-attr-i)', '<Plug>(textobj-xmlattr-attr-a)']}
"{{{
omap ix <Plug>(textobj-xmlattr-attr-i)
omap ax <Plug>(textobj-xmlattr-attr-a)
xmap ix <Plug>(textobj-xmlattr-attr-i)
xmap ax <Plug>(textobj-xmlattr-attr-a)
"}}}
"
" iz az
Plug 'somini/vim-textobj-fold', {'on': ['<Plug>(textobj-fold-i)', '<Plug>(textobj-fold-a)']}
"{{{
omap iz <Plug>(textobj-fold-i)
omap az <Plug>(textobj-fold-a)
xmap iz <Plug>(textobj-fold-i)
xmap az <Plug>(textobj-fold-a)
"}}}

" ciq diq yiq viq 最近的引号' ` "
Plug 'beloglazov/vim-textobj-quotes', {'on': ['<Plug>(textobj-quote-i)', '<Plug>(textobj-quote-a)']}
"{{{
omap iq <Plug>(textobj-quote-i)
omap aq <Plug>(textobj-quote-a)
xmap iq <Plug>(textobj-quote-i)
xmap aq <Plug>(textobj-quote-a)
"}}}

" ij aj 最近的()[]{}
Plug 'Julian/vim-textobj-brace', {'on': ['<Plug>(textobj-brace-i)', '<Plug>(textobj-brace-a)']}
"{{{
omap ij <Plug>(textobj-brace-i)
omap aj <Plug>(textobj-brace-a)
xmap ij <Plug>(textobj-brace-i)
xmap aj <Plug>(textobj-brace-a)
"}}}

" iu au 支持markdown的url  go打开连接(仅支持Linux)
Plug 'jceb/vim-textobj-uri', {'on': ['<Plug>(textobj-uri-uri-i)', '<Plug>(textobj-uri-uri-a)', '<Plug>TextobjURIOpen']}
" NOTE: 如果不设置到<Plug>TextobjURIOpen的映射，则插件会映射 go
"{{{
omap iu <Plug>(textobj-uri-uri-i)
omap au <Plug>(textobj-uri-uri-a)
xmap iu <Plug>(textobj-uri-uri-i)
xmap au <Plug>(textobj-uri-uri-a)
"}}}
nmap <silent> tu <Plug>TextobjURIOpen

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
  " 防止--noplugin模式下报错
  if g:disable_laggy_plugins_for_large_file == 1
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
    if &ft !~? 'vimfiler'
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
    if !exists('*WebDevIconsGetFileTypeSymbol')  " 判断是否启用devicon插件
        let l:result = &ft != "" ? &ft : "no ft"
    else
        let l:result = &ft != "" ? &ft . ' ' . WebDevIconsGetFileTypeSymbol() : "no ft"
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
        \           [  'gitbranch', 'filename', 'readonly', 'modified', 'session_name' ],
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

" 异步自动生成tags
Plug 'jsfaint/gen_tags.vim'
"{{{
let g:gen_tags#verbose = 0  " 不提示信息
let g:gen_tags#gtags_auto_gen = 1
let g:gen_tags#gtags_auto_gen = 1
let g:gen_tags#ctags_opts = ['--c++-kinds=+px', '--c-kinds=+px']
let g:gen_tags#ctags_opts = ['-c', '--verbose']
" FIXME: 当项目文件的路径包含非ASCII字符时，使用pygments会报UnicodeEncodeError
let $GTAGSLABEL = 'native-pygments'
" let $GTAGSCONF = '/usr/local/share/gtags/gtags.conf'

"}}}

" 写作使用的，自动单词折行
Plug 'reedes/vim-pencil', {'for': ['markdown', 'text', 'vimwiki']}
let g:pencil#textwidth = 80  " 默认单行最大长度
augroup pencil
    autocmd!
    autocmd FileType markdown silent! call pencil#init({'wrap': 'hard', 'autoformat': 1}) | setlocal wrap | setlocal textwidth=80
    autocmd FileType text silent! call pencil#init({'wrap': 'soft', 'autoformat': 0}) | setlocal wrap | setlocal textwidth=120
augroup END

"  单词级对比,　diff模式自动启动, 高亮组是DiffText
Plug 'rickhowe/diffchar.vim', {'on': 'TDChar'}

"===========================================================================
"===========================================================================
"}}}

" 需要知道用法的插件
" ---------------------------------------
" 通用功能插件
"{{{开关非常影响打开大文件性能的插件
if g:disable_laggy_plugins_for_large_file == 0
    " 侧栏显示git diff情况
    Plug 'mhinz/vim-signify'
    nnoremap gp :SignifyHunkDiff<cr>
    nnoremap ,gu :SignifyHunkUndo<cr>
    nmap gk <plug>(signify-prev-hunk)
    nmap gj <plug>(signify-next-hunk)
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
    \   'python': ['autopep8'],
    \   'html': ['prettier'],
    \   'css': ['prettier'],
    \   'scss': ['prettier'],
    \   'less': ['prettier'],
    \   'json': ['prettier'],
    \   'vue': ['prettier'],
    \   'yaml': ['prettier'],
    \   'javascript': ['prettier'],
    \   'typescript': ['prettier'],
    \   'markdown': ['prettier'],
    \   'flow': ['prettier'],
    \   'javascriptreact': ['prettier'],
    \   'typescriptreact': ['prettier'],
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
endif
"}}}
"{{{ Git 相关
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
nnoremap <silent> <leader>mc :<C-u>call MergetoolLayoutCustom()<CR>

" 显示当前行的commit信息, o下一个commit，O上一个，d打开该commit在当前文件的diff hunks，
" D打开该commit的所有diff hunks
Plug 'rhysd/git-messenger.vim', {'on': '<Plug>(git-messenger)'}
"{{{
let g:git_messenger_no_default_mappings = v:true
"}}}
" 开启预览后光标始终进入popup window, 否则要再次使用快捷键才能让光标进入popup window
" let g:git_messenger_always_into_popup = v:true
nmap gc <Plug>(git-messenger)

" git
Plug 'tpope/vim-fugitive'
" Gread就是清空暂存区 即checkkout %
" 还有diffget和diffput可以使用
nnoremap ,ga :G add %:p<CR><CR>
nnoremap ,gb :Git branch<Space>
nnoremap ,gc :G commit --all<cr>
" 定义进入diff的事件，然后当前窗口关闭syntax
autocmd User MyEnterDiffMode normal zz
" 在新tab中打开,对比目前与暂存区
nnoremap ,gd :G difftool % -y<cr>:doautocmd User MyEnterDiffMode<cr>
" 在新tab中打开,对比暂存区与HEAD
nnoremap ,gD :G difftool --cached % -y<cr>:doautocmd User MyEnterDiffMode<cr>
" 查看所有仓库文件的暂存区与HEAD之间的diff
nnoremap ,GD :G difftool --cached -y<cr>:doautocmd User MyEnterDiffMode<cr>
" 编辑其他分支的文件 Gedit branchname:path/to/file,  branchname:%表示当前buffer的文件
nnoremap ,ge :Gedit<space>
" nnoremap ,gl :Glog<cr>  " 由Flog插件替代
nnoremap ,gf :G fetch<cr>
" git status
nnoremap <silent> ,gs :vert Git<cr>
nnoremap ,gg :Ggrep<space>
" 重命名git项目下的文件
" This will:
    " Rename your file on disk.  Rename the file in git repo.
    " Reload the file into the current buffer.  Preserve undo history.
nnoremap ,gm :G commit --amend %<cr>
nnoremap .go :Git checkout<Space>
nnoremap ,gr :G add %<cr>:Gmove <c-r>=expand('%:p:h')<cr>/
nnoremap ,ps :G push<cr>
nnoremap ,pl :G pull<cr>

" 更方便的查看commit g?查看键位 enter查看详细信息 <c-n> <c-p> 跳到上下commit
Plug 'rbong/vim-flog', {'on': ['Flog']}
function! Flogdiff()  " {{{
  let first_commit = flog#get_commit_data(line("'<")).short_commit_hash
  let last_commit = flog#get_commit_data(line("'>")).short_commit_hash
  call flog#git('vertical belowright', '!', 'diff ' . last_commit . ' ' . first_commit )
endfunction
"}}}
augroup flog
    " 在FlogGraph中visual模式选中两个commit 再按gd可以显示新commit相比旧commit有哪些区别
    autocmd FileType floggraph vnoremap gd :<C-U>call Flogdiff()<CR>
augroup end
let g:flog_default_arguments = { 'max_count': 1000 }  " 约束最大显示的commit数量，防止打开太慢
nnoremap <silent> ,gl :Flog<cr>
" 选中多行查看历史
vnoremap <silent> ,gl :Flog<cr>

"}}}
"{{{coc 生态系统, 补全框架
" coc-lists
nnoremap <leader>cl :CocList<cr>

" coc-bookmark
nnoremap <leader>bl :CocList bookmark<cr>
nmap <leader>bm <Plug>(coc-bookmark-toggle)
nmap <leader>ba <Plug>(coc-bookmark-annotate)

" coc-explorer 文件树
"{{{
function ToggleCocExplorer()
  execute 'CocCommand explorer --toggle --width=35 --sources=buffer+,file+ ' . getcwd()
endfunction
"}}}
nnoremap <silent> <leader>er :call ToggleCocExplorer()<CR>

" 使用coc-yank (自带复制高亮)
nnoremap <silent> gy :<C-u>CocList --normal yank<cr>

" coc-translator  可以先输入再查词, 作为一个简单的英汉词典,
" view word history
nnoremap <leader>vw :CocList translation<cr>
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
Plug 'neoclide/coc.nvim', {'branch': 'release', 'tag': 'v0.0.77'}
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
  \ 'coc-stylelint', 'coc-sh', 'coc-dictionary', 'coc-word', 'coc-emmet',
  \ 'coc-syntax', 'coc-marketplace', 'coc-todolist', 'coc-emoji',
  \ 'coc-gitignore', 'coc-bookmark', 'coc-java', 'coc-tag', 'coc-floaterm',
  \ 'coc-markdownlint',
  \ ]


set hidden  " 隐藏buff非关闭它, TextEdit might fail if hidden is not set.
set cmdheight=2  " 如果不设置为2，每次进入新buffer都需要回车确认...
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set shortmess+=c  " Don't pass messages to ins-completion-menu.
set signcolumn=yes  " Always show the signcolumn, otherwise it would shift the text each time

" Make <tab> used for trigger completion, completion confirm, snippet expand and jump like VSCode.
" inoremap <silent> <expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" 用于在空白行第一列按tab一步缩进到位
" FIXME: 没有添加到下面列表里的文件类型如果cc不能缩进，则tab也不能缩进了, 那么就需要在下面的list新增文件类型
let g:My_quick_tab_blacklist = ['markdown', 'text', 'vim', 'vimwiki', 'gitcommit', 'snippets']
inoremap <silent> <expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? (strwidth(getline('.')) == 0 && index(g:My_quick_tab_blacklist, &filetype) < 0 ? '<esc>cc' : '<tab>') :
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
" <C-o>  切换到正常模式(q退出) <C-c>  - 关闭coclist

" 层进式范围选择
" NOTE: 暂时打算用回车映射到％　这样映射是为了在命令行按下<c-f>进入的buffer内，可以在normal模式按回车执行指令
" let g:coc_range_select_map_blacklist = ['vim', 'markdown']
" nmap <expr> <cr> index(g:coc_range_select_map_blacklist, &filetype) >=0 ? '<cr>' : '<Plug>(coc-range-select)'
" vmap <expr> <cr> index(g:coc_range_select_map_blacklist, &filetype) >=0 ? '<cr>' : '<Plug>(coc-range-select)'
" vmap <backspace> <Plug>(coc-range-select-backward)
" 触发鼠标悬浮事件
nnoremap <silent> gh :call CocActionAsync('doHover')<cr>
" 跳转到声明
nmap <silent> gD <Plug>(coc-declaration)
" 跳转到定义
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gm <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> ,re <Plug>(coc-refactor)
nmap <silent> gt <Plug>(coc-type-definition)
" 函数文本对象
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
" 可以用来import
nmap <leader>do <Plug>(coc-codeaction)
nnoremap <silent> <leader>ml :CocList --normal --number-select marks<cr>
nnoremap <silent> <leader>sl :CocList sessions<cr>
" 查看文档,并跳转
nnoremap <silent> <m-q> :call <SID>show_documentation()<CR>
" 打开鼠标位置下的链接
nmap <silent> <leader>re <Plug>(coc-rename)
" 重构
imap <silent> <c-m-v> <esc><Plug>(coc-codeaction)
nmap <silent> <c-m-v> <Plug>(coc-codeaction)
vmap <silent> <c-m-v> <Plug>(coc-codeaction-selected)
" TODO: 测试效果 在代码片段跳转后显示函数签名。
" autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" FIXME: 如果不想显示ref的虚拟文本，需要在coc-setting里关闭codelents
nnoremap <leader>cc :CocCommand<cr>

"}}}
"{{{编辑, 跳转功能增强
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
nmap <c-_> <plug>NERDCommenterToggle
" 添加gv<esc>就可以回到原地
vmap <c-_> <plug>NERDCommenterTogglegv<esc>
imap <c-_> <esc><plug>NERDCommenterToggle

" Vim-Surround快捷操作
Plug 'tpope/vim-surround'
"{{{
 " 让surround的快捷键可以用 `.` 重复
let s:key_mappings_of_surround = [
            \ "<leader>'", '<leader>"', '<leader>*', '<leader><leader>*', '<leader>)', '<leader>(',
            \ '<leader>[', '<leader>{', '<leader><', '<leader>>', '<leader>\|', '<leader>`',
            \ ",'", ',"', ',*', ',,*', ',(',
            \ ',)', ',[', ',{', ',<', ',>', ',\|', ',`'
            \ ]
for keymap in s:key_mappings_of_surround
    silent! call repeat#set(keymap, v:count)
endfor
"}}}
" {{{让cs修改的surround不包括空格
fun My_get_inverse_bracket(x)  "
    if a:x == '(' | return ')'
    elseif a:x == '[' | return ']'
    elseif a:x == '{' | return '}'
    elseif a:x == '<' | return '>'
    elseif  a:x == '>' | return '<'
    endif
endf
"
for x in ['(','[', '{', '<', "'", '"']
    for y in ['(', '[', '{', '<', '>']
        execute 'nmap cs' . x . y . ' cs' . x . My_get_inverse_bracket(y)
    endfor
endfor
"}}}
nmap ysw ysiw
nmap ysW ysiW
" 快速添加pair
" TIP: cswb == ysiwb, 用于<cword> 而<leader>{?}用于<cWORD>
nmap <leader>' :normal ysiW'<cr>gv<esc>
nmap <leader>" :normal ysiW"<cr>gv<esc>
nmap <leader>* :normal ysiW*<cr>gv<esc>
nmap <leader><leader>* :normal ysiW*<cr>:normal ysiW*<cr>gv<esc>
nmap <leader>) :normal ysiW)<cr>gv<esc>
nmap <leader>( :normal ysiW)<cr>gv<esc>
nmap <leader>[ :normal ysiW]<cr>gv<esc>
nmap <leader>{ :normal ysiW}<cr>gv<esc>
" surround with <>
nmap <leader>< :normal ysiW><cr>gv<esc>
" surround with <tag></tag>
nmap <leader>> :normal ysiW<<cr>gv<esc>
" 这里对|进行了转义
nmap <leader>\| :normal ysiW\|<cr>gv<esc>
nmap <leader>` :normal ysiW`<cr>gv<esc>

vmap <leader>" S"gv<esc>
" visual添加surround同上{{{
vmap <leader>' S'gv<esc>
vmap <leader>* S*gv<esc>
vmap <leader><leader>* S*gvS*gv<esc>
vmap <leader>( S)gv<esc>
vmap <leader>) S)gv<esc>
vmap <leader>[ S]gv<esc>
vmap <leader>{ S}gv<esc>
vmap <leader>< S>gv<esc>
vmap <leader>> S<gv<esc>
vmap <leader>\| S\|gv<esc>
vmap <leader>` S`gv<esc>
"}}}
nmap ," :normal ds"<cr>
"{{{ 逗号删除surround
nmap ,' :normal ds'<cr>
nmap ,* :normal ds*<cr>
nmap ,,* :normal ds*<cr>:normal ds*<cr>
nmap ,( :normal ds(<cr>
nmap ,) :normal ds(<cr>
nmap ,[ :normal ds[<cr>
nmap ,{ :normal ds{<cr>
nmap ,< :normal ds><cr>
nmap ,> :normal dst<cr>
nmap ,\| :normal ds\|<cr>
nmap ,` :normal ds`<cr>
"}}}

" %匹配对象增强, 也许可以把%改成m
Plug 'andymass/vim-matchup'
"{{{
let loaded_matchit = 1
let loaded_matchparen = 1
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

" 支持v:count 块选择模式整列的递增/减数字 <c-a> <c-x>
Plug 'triglav/vim-visual-increment', {'on': ['<Plug>(VisualIncrement)', '<Plug>(VisualDecrement)']}
set nrformats=alpha,hex,bin  " 支持数字，字母，十六进制, 二进制
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

" 让代码在一行和多行之间转换, 主要用与js(ts,vue,json),html,yaml,数组,字典
Plug 'AndrewRadev/splitjoin.vim', {'on': ['SplitjoinSplit', 'SplitjoinJoin'] }
"{{{
let g:splitjoin_split_mapping = ''  " 禁用默认映射
let g:splitjoin_join_mapping = ''
"}}}
nmap <silent> <Leader>tj :SplitjoinSplit<cr>
nmap <silent> <Leader>tk :SplitjoinJoin<cr>

"}}}
"{{{ UI 相关

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
" I got it from https://fsymbols.com/text-art/
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
nnoremap <leader>ST :StartupTime<cr>
nnoremap <leader>PI :PlugInstall<cr>
nnoremap <leader>PC :PlugClean<cr>
nnoremap <leader>PS :PlugStatus<cr>

" keymap提示 NOTE: 不能延迟加载
Plug 'liuchengxu/vim-which-key'
"{{{
autocmd VimEnter * call which_key#register('<Space>', "g:which_key_map_space")
autocmd VimEnter * call which_key#register(',', "g:which_key_map_comma")
autocmd VimEnter * call which_key#register('g', "g:which_key_map_g")
autocmd VimEnter * call which_key#register('t', "g:which_key_map_t")
" 快捷键注释
"{{{ <Space> 快捷键注释
let g:which_key_map_space = {}
let g:which_key_map_space['0'] = 'toggle-sytax'
let g:which_key_map_space.a = {
            \ 'name': '+absolute-path',
            \ 'p': 'absolute-path-copy'
            \}
let g:which_key_map_space.b = {
    \ 'name': '+buffer/bookmark/build',
    \ 'd': 'buffer-close',
    \ }
let g:which_key_map_space.c = {
            \ 'name': '+comment/colors-scheme/coc-list',
            \ }
let g:which_key_map_space.d = {
            \ 'name': '+diff/directory',
            \ 'r': 'dir-path-copy',
            \}
let g:which_key_map_space.e = {
            \ 'name': '+edit/explorer',
            \ 'c': 'edit-c/cpp',
            \ 'h': 'edit-.h',
            \ 'n': 'edit-$VIMRC',
            \ 's': 'edit-snippets',
            \ 't': 'edit-tmux-config',
            \}
let g:which_key_map_space.g = {
            \ 'name': '+goto',
            \ 'w': 'goto-<cword>',
            \ 'W': 'goto-<cWORD>',
            \}
let g:which_key_map_space.m = {
            \ 'name': '+markdown/mergetool/marks',
            \}
let g:which_key_map_space.n = {
            \ 'name': '+filename',
            \ 'm': 'filename-copy',
            \}
let g:which_key_map_space.o = {
            \ 'name': '+outline/fold-level',
            \ 't': 'outline-open',
            \ 'o': 'toggle-fold-level-0/１'
            \}
let g:which_key_map_space.p = {
            \ 'name': '+project(session)',
            \}
let g:which_key_map_space.P = {
            \ 'name': '+Plug',
            \}
let g:which_key_map_space.r = {
            \ 'name': '+run/rename/rooter/rg/regex-search',
            \}
let g:which_key_map_space.s = {
            \ 'name': '+buffer-substitute/split/select',
            \ 's': 'split-horizontal',
            \ 'v': 'split-vertical',
            \ 'o': 'select-all',
            \ 'u': 'buffer-substitute-cword',
            \ 'U': 'buffer-substitute-cWORD',
            \}
let g:which_key_map_space.S = {
            \ 'name': '+startuptime'
            \}
let g:which_key_map_space.t = {
            \ 'name': '+todolist/transparent',
            \}
let g:which_key_map_space.u = {
            \ 'name': '+undo-tree',
            \}
let g:which_key_map_space.v = {
            \ 'name': '+view',
            \}

let g:which_key_map_space['w'] = {
      \ 'name': '+windows',
      \ 'o': 'window-full-screen',
      \ 'f': 'window-swap',
      \ 'r': 'window-resize-mode',
      \ 'm': 'window-move-mode',
      \ }
"}}}
"{{{ "," 快捷键注释
let g:which_key_map_comma = {}
let g:which_key_map_comma.e = 'edit-file'
let g:which_key_map_comma.g = {
            \ 'name': '+git',
            \ 'd': 'diff-current-file',
            \ 'l': 'git-log',
            \ 's': 'git-status',
            \ 'u': 'undo-diff-hunk',
            \ 'r': 'git-rename',
            \}
let g:which_key_map_comma.p = {
            \ 'name': '+pull/push',
            \}
let g:which_key_map_comma.s = {
            \ 'name': '+buffer-substitute/sink',
            \ 'n': 'sink-mode (zen-mode)',
            \ 'u': 'buffer-substitute-cword',
            \ 'U': 'buffer-substitute-cWORD',
            \ 'r': 'regex-substitute',
            \}
let g:which_key_map_comma.w = 'write (save-buffer)'
"}}}
"{{{ "g" 快捷键注释
let g:which_key_map_g = {}
" HACK: 特殊字符就不能用 . 了，　只能用['']的形式
let g:which_key_map_g[';'] = 'last-edit-positon-normal-mode'
let g:which_key_map_g['/'] = 'last-buffer-grep'
let g:which_key_map_g['?'] = 'last-buffer-search'
let g:which_key_map_g.b = 'next-braket'
let g:which_key_map_g.c = 'line-commit-message'
let g:which_key_map_g.i = 'last-edit-positon-insert-mode'
let g:which_key_map_g.q = 'toggle-quickfix-window'
let g:which_key_map_g.u = 'toggle-upper-case-<cword>'
let g:which_key_map_g.U = 'toggle-upper-case-<cWORD>'
let g:which_key_map_g.y = 'yank-history'
"}}}
"{{{ "t" 快捷键注释
let g:which_key_map_t = {}
let g:which_key_map_t.h = 'swap-left'
let g:which_key_map_t.l = 'swap-right'
let g:which_key_map_t.j = 'join-line'
let g:which_key_map_t.t = 'translate-<cword>'
let g:which_key_map_t.u = 'open-URL'
"}}}
let g:which_key_display_names = { ' ': 'SPC', '<TAB>': 'TAB', }  " 定义快捷键的别名, key必须是大写字母
let g:which_key_run_map_on_popup = 1  " 每次popup自动更新词典，防止buffer local的keymap改变时vim-whichkey信息过时了
let g:which_key_use_floating_win = 1  " 使用浮动窗口,优点是在多窗口的时候兼容性很好
"}}}
let g:which_key_fallback_to_native_key = 1  " 如果没有自定义则不报警
nnoremap <silent> <leader> :<C-U>WhichKey '<Space>'<cr>
nnoremap <silent> <localleader> :<C-U>WhichKey ','<cr>
" 在Visual模式显示WhichKey
vnoremap <silent> <leader> :<C-U>WhichKeyVisual '<space>'<cr>
vnoremap <silent> <localleader> :<C-U>WhichKeyVisual ','<cr>
nnoremap <silent> g :<C-U>WhichKey 'g'<cr>
vnoremap <silent> g :<C-U>WhichKeyVisual  'g'<cr>
augroup settings_whichkey_for_t  " 因为有插件映射了t所以这里要用autocmd来映射
    autocmd!
    autocmd VimEnter * nnoremap <silent> t :WhichKey 't'<cr>
    autocmd VimEnter * vnoremap <silent> t :WhichKeyVisual 't'<cr>
augroup end

" 为内置终端提供方便接口 NOTE:暂时被floaterm替代，以后唯一可能用的地方就是REPL吧
" Plug 'kassio/neoterm'
"{{{
let g:neoterm_autojump = 1  " 自动进入终端
let g:neoterm_autoinsert = 1  " 进入终端默认插入模式
let g:neoterm_use_relative_path = 1
let g:neoterm_autoscroll = 1
let g:neoterm_size = 10  " 调整terminal的大小
"}}}
" nnoremap <silent> <m-m> :botright Ttoggle<cr>
" tnoremap <silent> <m-m> <c-\><c-n>:Ttoggle<cr>
" nnoremap <silent> <m-j> :botright Topen<cr>
" inoremap <silent> <m-j> <esc>:botright Topen<cr>
" tnoremap <m-j> <c-\><c-n><c-w>j
" tnoremap <m-k> <c-\><c-n><c-w>k<esc>

" 浮动终端
Plug 'voldikss/vim-floaterm'  " NOTE: 作者不推荐延迟加载
"{{{
fun My_reset_floaterm_config()
    let g:floaterm_type = 'floating'   "　终端出现形式, 可选normal
    " let g:floaterm_type = 'normal'   "　终端出现形式, 可选normal
    let g:floaterm_winblend = 35  " 背景透明度百分比
    let g:floaterm_position = 'center'  " 浮动窗口位置
    " 从终端打开文件的方式 Available: 'edit', 'split', 'vsplit', 'tabe', 'drop'. Default: 'edit'
    let g:floaterm_open_command = 'tabe'
    " 使用git commit时触发
    let g:floaterm_gitcommit = 'split'  " split vsplit tabe可选
endf
call My_reset_floaterm_config()

augroup fix_bug_in_floaterm_and_startify
    autocmd!
    autocmd User Startified setlocal buflisted
augroup end
"}}}
" 进入终端前复制当前buffer所在目录, 以便于快速进入该buffer的目录
nnoremap <silent> <m-n> :FloatermNew<cr>
tnoremap <silent> <m-n> <c-\><c-n>:FloatermNew<cr>
" 进入普通模式
tnoremap <c-m-n> <c-\><c-n>
" 可以作为从编辑器回到浮动窗口的快捷键
nnoremap <silent> <m-m> :FloatermToggle<cr>
"{{{ function My_toggle_full_screen_floterm
let g:My_full_screen_floterm_status = 0
function My_toggle_full_screen_floterm()
    if &buftype != 'terminal'
        echo "not in a float terminal"
    endif
    if g:My_full_screen_floterm_status == 0
        let g:My_full_screen_floterm_status = 1
        setlocal laststatus=0  " 不显示状态栏
        1000wincmd |  " 延长水平窗口
        1000wincmd _
        startinsert  " 进入插入模式
    else
        let g:My_full_screen_floterm_status = 0
        FloatermToggle
        FloatermToggle
        setlocal laststatus=2
    endif
endf
"}}}
" 浮动终端开关全屏模式
tnoremap <silent> <m-o> <c-\><c-n>:call My_toggle_full_screen_floterm()<cr>
nnoremap <silent> <m-o> <c-\><c-n>:call My_toggle_full_screen_floterm()<cr>
tnoremap <silent> <m-m> <c-\><c-n>:FloatermToggle<cr>
nnoremap <silent> <m-j> :FloatermNext<cr>
tnoremap <silent> <m-j> <c-\><c-n>:FloatermNext<cr>
nnoremap <silent> <m-k> :FloatermPrev<cr>
tnoremap <silent> <m-k> <c-\><c-n>:FloatermPrev<cr>
" 在浮动终端执行命令 -A表示自动预览
nnoremap <silent> <leader>ct :CocList -A floaterm <cr>
" 向终端送去命令去除空白但保持缩进 NOTE: 不适用于浮动窗口，只能当 g:floaterm_type = 'normal'时才能用
nnoremap <silent> ts :FloatermSend!<cr>
vnoremap <silent> ts :FloatermSend!<cr>
tnoremap <m-h> <c-\><c-n><c-w>h
tnoremap <m-l> <c-\><c-n><c-w>l
" " 粘贴寄存器0的内容到终端
tnoremap <expr> <m-p> '<C-\><C-n>"0pi'

"}}}
"{{{ Project 增强
" 切换到项目根目录
Plug 'airblade/vim-rooter'
"{{{
" let g:rooter_manual_only = 1  " 停止自动Rooter
let g:rooter_resolve_links = 1  " resolve软硬链接
let g:rooter_silent_chdir = 1  " 静默change dir
"}}}
" 手动切换到项目根目录
nnoremap <leader>rt :Rooter<cr>:echo printf('Rooter to %s', FindRootDirectory())<cr>

" 模糊搜索 弹窗后按<c-r>进行正则搜索模式, visual模式 '*' 查找函数依赖这个插件，所以不要延迟加载
Plug 'Yggdroot/LeaderF', {'do': './install.sh'}
"{{{
let g:Lf_RgConfig = [
      \ '--glob=!\.git/*',
      \ '--glob=!\.svn/*',
      \ '--glob=!\.hg/*',
      \ '--glob=!\.vscode/*',
      \ '--glob=!.ccls',
      \ '--glob=!.ccls-cache',
      \ '--glob=!**/.repo/*',
      \ '--glob=!**/.ccache/*',
      \ '--glob=!**/GTAGS',
      \ '--glob=!**/GRTAGS',
      \ '--glob=!**/GPATH',
      \ '--glob=!**/tags',
      \ '--glob=!**/prj_tags',
      \ '--iglob=!**/obj/*',
      \ '--iglob=!**/out/*',
      \ '--multiline',
      \ '--hidden',
      \ "-g '!.git'",
      \ ]
let g:Lf_WildIgnore = {
            \ 'dir': ['.svn','.git','.hg','.vscode','.wine','.deepinwine','.oh-my-zsh'],
            \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
            \}

" popup的normal模式是否自动预览 FIXME: 如果觉得上下移动很慢的话就得关闭preview
"                               TIP: 不要按着j或<c-j>不动而是连续按j的话就不会显得很慢
let g:Lf_PreviewResult = {
        \ 'File': 1,
        \ 'Buffer': 1,
        \ 'Mru': 1,
        \ 'Tag': 1,
        \ 'BufTag': 1,
        \ 'Function': 1,
        \ 'Line': 1,
        \ 'Colorscheme': 1,
        \ 'Rg': 1,
        \ 'Gtags': 1
        \}

let g:Lf_WindowPosition = 'popup'  " 使用popup
let g:Lf_PopupWidth = 0.66
let g:Lf_PopupHeight = 0.4
let g:Lf_PreviewInPopup = 1  " <c-p>预览弹出窗口
let g:Lf_CursorBlink = 0  " 取消光标闪烁
let g:Lf_ShowHidden = 1  " 搜索结果包含隐藏文件
let g:Lf_IgnoreCurrentBufferName = 1  " 搜索文件时忽略当前buffer FIXME: 不确定这条选项会不会导致搜索不到文件
" let g:Lf_WindowHeight = 0.4  " 非popup窗口的高度
let g:Lf_HistoryNumber = 200  " default 100
let g:Lf_GtagsAutoGenerate = 1  " 有['.git', '.hg', '.svn']之中的文件时自动生成gtags
let g:Lf_RecurseSubmodules = 1  " show the files in submodules of git repository
let g:Lf_RgStorePattern = '+'  "　使用leaderf rg -e ... 搜索时会保存同含义的vim regex形式的正则表达式到+寄存器
let g:Lf_Gtagslabel =  "native-pygments"  " 如果不是gtags支持的文件类型，就用pygments作为补充
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2"  }  " 分隔符样式
" let g:Lf_FollowLinks = 1  " 是否解析本为link的目录
let g:Lf_WorkingDirectoryMode = 'a'  " the nearest ancestor of current directory that contains one of directories
                                     " or files defined in |g:Lf_RootMarkers|. Fall back to 'c' if no such
                                     " ancestor directory found.
let g:Lf_ShortcutF = ''  " 这两项是为了覆盖默认设置的键位
let g:Lf_ShortcutB = ''
"}}}
nnoremap <silent> <c-p> :Leaderf command<cr>
let g:Lf_CommandMap = {
            \ '<C-]>':['<C-l>'],
            \ '<c-p>': ['<c-p>'],
            \}  " 搜索后<c-l>在右侧窗口打开文件
nnoremap <silent> <leader>gf :Leaderf file<cr>
nnoremap <silent> <leader>gb :Leaderf buffer<cr>
nnoremap <silent> <leader>gr :Leaderf mru<cr>
nnoremap <silent> <leader>gc :Leaderf cmdHistory<cr>
nnoremap <silent> <leader>gs :Leaderf searchHistory<cr>
nnoremap <silent> gf :Leaderf function<cr>
" 项目下即时搜索
nnoremap <silent> <leader>rg :<C-U>Leaderf rg<cr>
" 项目下搜索词 -F是fix 即不是正则模式
nnoremap <silent> <Leader>gw :<C-U><C-R>=printf("Leaderf! rg -F %s", expand("<cword>"))<CR><cr>
nnoremap <silent> <Leader>gW :<C-U><C-R>=printf("Leaderf! rg -F %s", expand("<cWORD>"))<CR><cr>
xnoremap <silent> <leader>gw :<C-U><C-R>=printf("Leaderf! rg -F %s", leaderf#Rg#visual())<CR><cr>
" buffer内即时搜索
nnoremap <silent> / :Leaderf rg --current-buffer<cr>
" 重复上次搜索, 会直接调用上次搜索结果的缓存
nnoremap <silent> g/ :Leaderf rg --recall<cr>
" buffer内搜索词
nnoremap <silent> gw :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer %s", expand("<cword>"))<CR><cr>
nnoremap <silent> gW :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer %s", expand("<cWORD>"))<CR><cr>
xnoremap <silent> gw :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer %s", leaderf#Rg#visual())<CR><cr>
xnoremap <silent> * :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer %s", leaderf#Rg#visual())<CR><cr>
" 仅测试用, 不知道用不用得上
" 查看tag引用
nnoremap <leader>tr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
" 查看tag定义
nnoremap <leader>td :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>

" Project/buffer内替换 (默认搜索隐藏文件)
Plug 'brooth/far.vim'  " 因为奇怪的遮罩原因，不建议使用on来延迟加载
"{{{
let g:far#mode_open = {'regex': 0, 'case_sensitive': 0, 'word': 0, 'substitute': 1}  " 默认模式,是没有正则的
let g:far#source = 'rgnvim'  " 使用rg + nvim的异步API 作为搜索源 FIXME: 如果以后换了grep工具需要换这个选项
let g:far#enable_undo = 1  " 允许按u进行undo替换
let g:far#auto_write_replaced_buffers = 1  " 自动写入
let g:far#auto_delete_replaced_buffers = 1  " 自动关闭替换完成的buffer
" 快捷键
let g:far#mapping = {
    \ 'replace_do': ['r'],
    \ 'expand_all': ['zm', 'zM'],
    \ 'collapse_all': ['zr', 'zR'],
    \ }
let g:far#default_file_mask = '%'  " 命令行默认遮罩(搜索的范围)
" 命令行补全资源
let g:far#file_mask_favorites = ['%', '**/*.*', '**/*.html', '**/*.js', '**/*.css', '**/*.c', '**/*.cpp',
            \'**/*.ts', '**/*.jsx', '**/*.tsx', '**/*.vue', '**/*.py', '**/*.java',
            \'**/*.md'
            \]
" 自定义快捷键提示样式
let g:far#prompt_mapping = {
    \ 'quit'           : { 'key' : '<esc>', 'prompt' : '<esc>' },
    \ 'regex'          : { 'key' : '<c-r>', 'prompt' : '<c-r>'  },
    \ 'case_sensitive' : { 'key' : '<c-a>', 'prompt' : '<c-a>'  },
    \ 'word'           : { 'key' : '<c-w>', 'prompt' : '<c-w>'  },
    \ 'substitute'     : { 'key' : '<c-f>', 'prompt' : '<c-f>'  },
    \ }
"}}}
" 定义far buffer的映射, NOTE: 如果自己的vimrc里有对应非递归映射(比如nnoremap zo)，则这个插件的映射会失效, 此外由于 插件bug导致不能映射zo  到za
" 快捷键r表示执行替换 q快速退出 x取消当前行 i激活当前行 t是toggle  他们的大写形式(X I T)表示全部行
" 其他用法: Farr交互式查找，并且可以转换成正则模式
" TIP: 已经预先复制好了要替换的内容，可以在命令行用<m-p>粘贴
" TIP: 可以用:3,10Far foo bar **/*.py 指定行和文件, 遮罩%表示本文件，*表示所有文件
" NOTE: 必须要先rooter再替换，否则会找不到文件
" buffer内替换
nnoremap ,su :let @0=expand('<cword>')<cr>:Far <c-r>=expand('<cword>')<cr>  %<left><left><c-f>i
nnoremap ,sU :let @0=expand('<cWORD>')<cr>:Far <c-r>=expand('<cWORD>')<cr>  %<left><left><c-f>i
" {{{Function: My_get_current_visual_text() 获取当前visual选择的文本
function My_get_current_visual_text() abort
    execute "normal! `<v`>y"
    return @"
endfunction
"}}}
xnoremap ,su :<c-u>Far <c-r>=My_get_current_visual_text()<cr>  %<left><left><c-f>i
" Project内替换
nnoremap ,Su :let @0=expand('<cword>')<cr>:Far <c-r>=expand('<cword>')<cr>  *<left><left><c-f>i
nnoremap ,SU :let @0=expand('<cWORD>')<cr>:Far <c-r>=expand('<cWORD>')<cr>  *<left><left><c-f>i
xnoremap ,Su :<c-u>Far <c-r>=My_get_current_visual_text()<cr>  *<left><left><c-f>i
" 交互式替换，按<c-r>可以改变匹配模式为正则 <c-f>在查找和替换模式之间切换
nnoremap ,sr :Farr<cr>

" 在quickfix窗口里编辑  " FIXME: 和quickr-preview有冲突
" Plug 'stefandtw/quickfix-reflector.vim'
" let g:qf_join_changes = 1  " 允许在同一个quickfix里undo多个文件

" 自动预览quickfix  FIXME: 和quickfix-reflector.vim有冲突
Plug 'ronakg/quickr-preview.vim', {'for': 'qf'}
let g:quickr_preview_keymaps = 0  " 禁用默认映射
let g:quickr_preview_on_cursor = 1  " 自动预览

" 类似VSCode的编译/测试/部署 任务工具
Plug 'skywind3000/asynctasks.vim', {'on': 'AsyncTask'}
"{{{
let g:asyncrun_open = 6
let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg']
let g:asynctasks_term_pos = 'floaterm' " 使用浮动终端
" let g:asynctasks_term_pos = 'bottom' " 可选tab
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
"}}}
"{{{杂项, 优化使用体验
" 编辑嵌套的代码，可以有独立的缩进和补全，使用场景: JS, Css在Html里面，
" Markdown内嵌代码，Vue组件，代码内嵌SQL
Plug 'AndrewRadev/inline_edit.vim', {'on': 'InlineEdit'}
nnoremap <leader>ei :InlineEdit<cr>a
xnoremap <leader>ei :InlineEdit<cr>a

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
Plug 'osyo-manga/vim-anzu', {'on': ['<Plug>(anzu-star-with-echo)', '<Plug>(anzu-sharp-with-echo)']}
nmap n <Plug>(anzu-n-with-echo)zv
nmap N <Plug>(anzu-N-with-echo)zv
nmap * <Plug>(anzu-star-with-echo)zv
nmap # <Plug>(anzu-sharp-with-echo)zv

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
nnoremap <leader>cm :DogeGenerate<cr>

"  选择区域进行diff
Plug 'rickhowe/spotdiff.vim', {'on': 'Diffthis'}
let s:in_diff_hunk_status = 0
nnoremap <leader>ds :Diffthis<cr>
" diff selsct
vnoremap <leader>ds :Diffthis<cr>
" diff close
nnoremap <leader>dc :Diffoff<cr>

" 查看各种离线文档, 使用:Docset 参数<cr>可以指定当前buffer的文档(docset), 重置当前buffer文档
" 类型, 使用:Docset<cr>重置当前buffer为默认文档类型
Plug 'KabbAmine/zeavim.vim', {'on': ['<Plug>Zeavim', '<Plug>ZVVisSelection',
            \ '<Plug>ZVOperator', '<Plug>ZVKeyDocset', 'Docset']}
"{{{
" let g:zv_keep_focus = 0  " 打开zeal后是否focus vim, 默认是1
" 根据文件类型查找文档
let g:zv_file_types = {
            \   'help'                : 'vim',
            \   'javascript'          : 'javascript,nodejs',
            \   'python'              : 'python_3',
            \   '\v^(G|g)ulpfile\.js' : 'gulp,javascript,nodejs',
            \ }
"}}}
" 自动选择<cword>和文件类型
nmap <leader>z <Plug>Zeavim
vmap <leader>z <Plug>ZVVisSelection
" gz{motion/text-object}
nmap gz <Plug>ZVOperator
" 手动选择文档包名
nmap <leader><leader>z <Plug>ZVKeyDocset

" normal模式fcitx输入法自动切换到英文输入
" NOTE: 会把启动速度拖慢180ms左右, 所以必须要延时启动
Plug 'lilydjwg/fcitx.vim', {'on':['Leaderf', 'Leaderf!', 'G', 'CocList']}

"}}}
" ---------------------------------------
" Layer
"{{{前端 Layer
if g:enable_front_end_layer == 1


    " Node.js支持
    " Plug 'moll/vim-node', {'for': [ 'javascript', 'typescript', '*jsx', '*tsx' ]}

    " 实时预览html,css,js
    Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server', 'on': 'Bracey'}
    nnoremap <leader>pv :Bracey<cr>

    " 具体的snippets见 https://github.com/mlaursen/vim-react-snippets
    " Plug 'mlaursen/vim-react-snippets'

    " plug 模板引擎
    " Plug 'digitaltoad/vim-pug'

    " 选择，插入，修改css颜色,配合取色器, NOTE: 可能不支持nvim
    " Plug 'kabbamine/vCoolor.vim', {'on': ['VCoolor', 'VCoolIns']}
"{{{
    let g:vcoolor_disable_mappings = 1  " 取消默认快捷键
"}}}

endif
"}}}
"{{{写作 Layer
" NOTE:　目前影响markdown排版的有pangu, ale里设置的prettier, lint是用的coc-markdownlint (如果prettier能做到无报警，
"        那就可以卸载coc-markdownlint了)
" TIP: 尝试过语法检查插件, 不怎么好用，最好在vim里写完了再去专门的网站检查

" Todo List 和 笔记，文档管理
Plug 'vimwiki/vimwiki', {'on': 'VimwikiIndex'}  " NOTE: 使用延迟加载的话可能在session中有bug
" {{{
" 使用markdown而不是vimwiki的语法
"let g:vimwiki_list = [{'path': '~/vimwiki/',
            " \ 'syntax': 'markdown', 'ext': '.md'}]
" let g:vimwiki_folding='expr'
" 禁用table_mappings在insert mode 对<tab>的映射, 避免和coc的补全快捷键冲突
let g:vimwiki_key_mappings =
\ {
\   'all_maps': 1,
\   'global': 1,
\   'headers': 1,
\   'text_objs': 1,
\   'table_format': 1,
\   'table_mappings': 0,
\   'lists': 1,
\   'links': 1,
\   'html': 1,
\   'mouse': 0,
\ }

"}}}

"　自动commit,push　vimwiki
Plug 'michal-h21/vimwiki-sync', { 'for': 'vimwiki', 'on': ['VimwikiIndex'] }

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

" 中文自动排版，不能连续重复使用除感叹号以外的标点 连续句号转换成省略号，中英文之间自动加标点，中文前后的半角符号转成全角
" NOTE: 文档书写规范见https://github.com/sparanoid/chinese-copywriting-guidelines
" TIP: 持久化禁用 在编辑的文档中任何位置注明 PANGU_DISABLE，则整个文档不自动规范化
" :PanguDisable禁用自动排版，对于多个文件可以使用vi a.xx b.xx c.xx 然后:argdo Pangu | update
Plug 'hotoo/pangu.vim', {'for': ['markdown','vimwiki', 'text', 'wiki', 'gitcommit']}
"{{{ 根据文件类型自动开启
augroup auto_enable_pangu
    autocmd!
    autocmd BufWritePre *.markdown,*.md,*.text,*.txt,*.wiki,*.cnx call PanGuSpacing()
    " COMMIT_EDITMSG就是fugitifu提供的gitcommit buffer的文件名
    autocmd InsertLeave COMMIT_EDITMSG call PanGuSpacing()
augroup end
"}}}

" 模糊非视觉中心的字符
Plug 'junegunn/limelight.vim', {'on': 'Limelight'}

" MarkDown预览, 目前似乎只支持本地图片, 不支持在线的图片
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'on': '<Plug>MarkdownPreviewToggle'}
"{{{
let g:mkdp_open_to_the_world = 1  " 可以让别人浏览
let g:mkdp_command_for_global = 1  " 所有文件中可以使用预览markdown命令
"}}}
nmap <leader>mp <Plug>MarkdownPreviewToggle

" 运行markdown内代码
Plug 'dbridges/vim-markdown-runner', { 'on': ['MarkdownRunner', 'MarkdownRunnerInsert'] }
augroup My_markdown_run
    autocmd!
    autocmd FileType markdown nnoremap <buffer> <Leader>rf :MarkdownRunner<CR>
    autocmd FileType markdown nnoremap <buffer> <Leader>Rf :MarkdownRunnerInsert<CR>
augroup end

"}}}
" {{{其他语言 Layer

" Java增强语法高亮
Plug 'uiiaoo/java-syntax.vim', {'for': ['java']}
"}}}

" ---------------------------------------
"{{{打算以后再体验的插件
"

" 多光标插件有bug 用不了

" coc-import-cost (仅用于JS和TS)
" coc-github
" coc-css-block-comments
" coc-sql (lint和format, format似乎要手动, 看ale能不能自动调用这个插件自带的sql-formatter把)

" 似乎是vim唯一的test插件, 支持CI
" Plug 'janko/vim-test'
"
" SQL Wrapper (不建议使用另一个插件vim-sql-workbench 因为太麻烦了)
" Plug 'joereynolds/SQHell.vim'

" 数据库接口(似乎只能查询)
" Plug 'tpope/vim-dadbod'
" 数据库接口的ui
" Plug 'kristijanhusak/vim-dadbod-ui'




" Github支持
"Plug 'junegunn/vim-github-dashboard'
" Gist　支持
" Plug 'mattn/vim-gist'

" 为不同的文件类型设置不同的tab expand 编码 EOF
"Plug 'editorconfig/editorconfig-vim'

" 快速创建表格
"Plug 'dhruvasagar/vim-table-mode'
" 生成Markdonw TOC
"Plug 'mzlogin/vim-markdown-toc'

" 自动生成作者、时间等信息
" Plug 'alpertuna/vim-header'







" ===========================================
" ============================================
" 以下插件目前看不到使用场景，作为尝鲜用的吧

" Vue支持
" coc-vetur

" 高亮多组选中单词, 缺点是需要重新映射n, N与anzu插件有冲突(当然可以选择不要next occurrence功能)
" Plug 'lfv89/vim-interestingwords'

" React NOTE: 因为有coc-tsserver了 不确定需不需要
" coc作者早期的插件，高亮以及缩进, js对jsx的适配
" Plug 'neoclide/vim-jsx-improve'

" 最新的 Stylus 语法高亮，可能被polyglot替代了
" Plug 'iloginow/vim-stylus'

" 添加文件图标 NOTE: 需要放在startify之后才能在startify中生效
Plug 'ryanoasis/vim-devicons'
let g:webdevicons_enable_startify = 1

"}}}
call plug#end()

"==========================================
" HotKey Settings  自定义快捷键设置
"==========================================
" {{{重要的按键重定义
inoremap kj <esc>
cnoremap kj <c-c>
nnoremap ? /
" 去掉搜索高亮
nnoremap <silent> <leader>? :nohls<cr>
" 重复上次搜索
nnoremap g? /<c-r>/<cr>
noremap ; :
nmap zo za
nmap zO zA
noremap ,; ;
nnoremap ,w :w<cr>
" 解决通过命令let @" = {text}设置的@" 不能被p正确粘贴的问题
nnoremap p ""p
vnoremap v <esc>
" 快速退出选择模式
xnoremap v <esc>
" 快速在行末写分号并换行, 如果左边一个字符是分号则直接换行
inoremap <expr> ;j nr2char(strgetchar(getline('.')[col('.') - 2:], 0)) == ';' ? '<c-o>o' : '<esc>A;<esc>o'
inoremap <expr> ;; nr2char(strgetchar(getline('.')[col('.') - 2:], 0)) == ';' ? '<c-o>o' : '<c-o>A;<esc>jo'
" 开关大小写
inoremap ;u <esc>viW~A
" 快速创建折叠marker, 避免受autopair的影响
inoremap <expr> ;a &foldmethod == 'marker' ? '{{{' : ';a'
inoremap <expr> ;b &foldmethod == 'marker' ? '}}}' : ';b'
" NOTE: 这里用imap是因为要借用auto-pairs插件提供的{}自动配对
imap [[ <esc>A<space>{<cr>
" 连接下一行
nnoremap tj J
" 废弃ZZ退出
noremap ZZ <nop>
" 这里判断&buftype是否为nofile是为了在命令模式按<c-f>之后进入的buffer内可以回车执行命令
map <expr> <cr> &buftype == 'nofile' ? '<cr>' : '%'
"}}}
"{{{ 更便捷的移动以及视角居中
"set wrap之后，在折行之间也可以跳
noremap j gj
noremap k gk
" 在同一个折叠的首位跳转
nnoremap zzj ]z
nnoremap zzk [z
noremap J <C-f>
noremap K <C-b>
nmap gb %
" 去上次修改的地方
nnoremap gi gi<esc>zvzzi
" goto previous/next change positon
nnoremap g; g;zv
nnoremap g, g,zv
nnoremap '' ``zv
nnoremap '. `.zv
" HACK: zv可以自动展开折叠
nnoremap <c-o> <c-o>zv
nnoremap <c-i> <c-i>zv
nnoremap u uzv
nnoremap <c-r> <c-r>zv
" 交换 ' `, 使得可以快速使用'跳到marked相同的位置
noremap ' `
noremap ` '
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
"}}}
"{{{ Buffer Window Tab 操作
" Buffer操作
nnoremap <silent> <m-l> :bp<cr>
nnoremap <silent> <m-h> :bn<cr>
inoremap <silent> <m-l> <esc>:bp<cr>
inoremap <silent> <m-h> <esc>:bn<cr>

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
" 调整窗口布局
nnoremap <silent> <leader>wh :wincmd H<cr>
nnoremap <silent> <leader>wj :wincmd J<cr>
nnoremap <silent> <leader>wk :wincmd K<cr>
nnoremap <silent> <leader>wl :wincmd L<cr>
nnoremap <silent> <leader>wf <c-w><c-r>
nnoremap <leader>w= <c-w>=
" 窗口最大化 leaving only the help window open/maximized
nnoremap <leader>wo <c-w>o
nnoremap <leader>ss <c-w>s<c-w>w
noremap <silent> <leader>sv :wincmd v<cr>:wincmd w<cr>
noremap <silent> <leader>j :wincmd j<cr>
noremap <silent> <leader>k :wincmd k<cr>
noremap <silent> <leader>h :wincmd h<cr>
noremap <silent> <leader>l :wincmd l<cr>

" Tab操作
nnoremap <leader><leader>h gT
nnoremap <leader><leader>l gt
nnoremap gxo :tabonly<cr>
nnoremap <silent> <c-t> :tab split<cr>
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
nnoremap <silent> <c-w> :tabclose<cr>
inoremap <silent> <c-t> <esc>:tab split<cr>
" normal模式下切换到确切的tab
for s:count_num in [1,2,3,4,5,6,7,8,9]
    exec 'nnoremap <leader>' . s:count_num . ' ' . s:count_num . 'gt'
endfor
"}}}
" 当前buffer/当前选中范围替换{{{
" NOTE: 目前被Far.vim插件替代, 不过同一文件内小范围的替换用这个方式还是更方便一些
" 当前buffer替换
nnoremap <leader>su :let @0=expand('<cword>')<cr>:%s/<c-r>=expand('<cword>')<cr>//gc<left><left><left>
nnoremap <leader>sU :let @0=expand('<cword>')<cr>:%s/<c-r>=expand('<cWORD>')<cr>//gc<left><left><left>
xnoremap  <leader>su :<c-u>%s/<c-r>=My_get_current_visual_text()<cr>//gc<left><left><left>
nnoremap <leader>rsu :%s/\v//gc<left><left><left><left>

" 范围内替换
xnoremap  <leader>Su :s///gc<left><left><left><left>
" 范围内正则替换
xnoremap <leader>rSu :s/\v//gc<left><left><left><left>
"}}}
"{{{修改默认快捷键到更令人舒适的行为

"{{{ 更方便的跳转标记
let s:alphabet =['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
            \'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
            \'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
            \'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',]
for single_char in s:alphabet
    exec "nnoremap '" . single_char . ' `' . single_char . 'zv'
endfor
"}}}
" 调整缩进后自动选中，方便再次操作
vnoremap < <gv
vnoremap > >gv
nnoremap < <<
nnoremap > >>
" 让y复制后光标仍在原位
vnoremap y ygv<esc>
" 让normal模式的s不要污染无名寄存器, 因为一个字母没有必要覆盖之前的寄存器内容
" 同时visual模式s表示删除，x表示剪切
nnoremap s "_s
vnoremap s "_s
" 创建折叠的同时也执行折叠
vnoremap zf zfzc

"}}}
" {{{通过快捷键实现新功能

" TIP: g<c-g> 可以统计字数,行，字节，字符 会将汉字、标点、空格、英文字母都看做一个字, 还可以选择模式使用, 具体信息查看:h g^g
" TIP: 待映射快捷键: v? q? T? z?
" 重复上次执行的寄存器的命令
nnoremap <leader>r; @:
" 执行宏 q
nnoremap R @q
" 可以在选中的行执行宏　xnoremap <expr> <leader>@ ":norm! @".nr2char(getchar())."<CR>"
xnoremap <expr> R ":norm! @q<CR>"

" 选择全部
nnoremap <leader>so ggVG
" 切换大小写
nnoremap gu viw~gv<esc>
nnoremap gU viW~gv<esc>
vnoremap gu ~gv<esc>

" 退出系列
noremap <silent> <leader>q <esc>:q<cr>
"{{{ 退出Vim并自动保存会话
function s:auto_save_session() abort
    let session_name = fnamemodify(v:this_session,':t')
    let session_name = session_name == '' ? 'default.vim' : session_name
    execute 'SSave! ' . session_name
    execute 'qa'
endfunction
"}}}
noremap <silent> Q <esc>:call <SID>auto_save_session()<cr>

" 快速调整折叠层级
for i in range(10)
    execute 'nnoremap <leader>o' . i . ' :setlocal foldlevel=' . i . '<cr>zz'
endfor

" toggle foldlevel=0 / foldlevel=1
" {{{function
let g:My_toggle_foldlevel_mode = 0
fun My_toggle_foldlevel()
    if g:My_toggle_foldlevel_mode == 0
        setlocal foldlevel=0
        let g:My_toggle_foldlevel_mode = 1
    else
        setlocal foldlevel=1
        let g:My_toggle_foldlevel_mode = 0
    endif
endf
"}}}
nnoremap <silent> <leader>oo :call My_toggle_foldlevel()<cr>
" 在markdown中调整conceallevel (visible)
nnoremap <expr> <silent> <leader>vi &conceallevel == 3 ? ':set conceallevel=0<cr>' : ':set conceallevel=3<cr>'

" HACK: 新发现，解锁v键映射
nnoremap va ggVG


"}}}

"==========================================
" 设置 Settings
"==========================================
" {{{ 基础设置 Basic Settings
set scrolloff=100  " 让视角始终居中，在vim中好像有性能问题,但是在neovim中不清楚
set termguicolors  " 使用真色彩  NOTE: 此条设置应在colorscheme命令之前
exec 'colorscheme ' . g:all_colorschemes[g:default_colorscheme_mode]
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
" set t_ti= t_te=  " 设置 退出vim后，内容显示在终端屏幕, 可以用于查看和复制, 不需要可以去掉,
                    " 好处：误删什么的，如果以前屏幕打开，可以找回
set mouse=r  " 启用鼠标, 可以用右键使用系统剪切板来复制粘贴
set title  " change the terminal's title
set novisualbell  " 去掉输入错误的提示声音
set noerrorbells
set vb t_vb= " 彻底禁止错误发出bell
set tm=500
set backspace=eol,start,indent  " Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l
set synmaxcol=200  " 对于很长的行语法高亮很拖慢速度
set viminfo+=!  " 保存viminfo全局信息
set lazyredraw  " redraw only when we need to.
set nocompatible  " 去掉有关vi一致性模式，避免以前版本的bug和局限
set wildmenu  " 增强模式中的命令行自动完成操作
set wildmode=longest,full
set showbreak=⤷▶  " wrap line指示器
" set showbreak=↪
set backupcopy=yes  " Does not break hard/symbolic links on file save
set virtualedit+=block  " 块选择模式可以把光标移动到没有字符的位置





" {{{ 文件编码,格式 FileEncode Settings

set fencs=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
set encoding=utf-8  " 设置新文件的编码为 UTF-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1  " 自动判断编码时，依次尝试以下编码：
set helplang=cn
set termencoding=utf-8  " 下面这句只影响普通模式 (非图形界面) 下的 Vim
set formatoptions+=m  " 如遇Unicode值大于255的文本，不必等到空格再折行
set formatoptions+=B  " 合并两行中文时，不在中间加空格
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
" {{{ 展示/排版等界面格式设置 Display Settings
set ruler  " 显示当前的行号列号
set showmode  " 左下角显示当前vim模式
set number  " 显示行号
set textwidth=0  " 打字超过一定长度也不会自动换行
set relativenumber number  " 相对行号: 行号变成相对，可以用 nj/nk 进行跳转
" set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
" " 命令行（在状态行下）的高度，默认为1，这里是2
set laststatus=2  " Always show the status line - use 2 lines for the status bar
set showmatch  " 括号配对情况, 跳转并高亮一下匹配的括号
set matchtime=2  " How many tenths of a second to blink when matching brackets
set hlsearch  " 高亮search命中的文本
set incsearch  " 打开增量搜索模式,随着键入即时搜索
set ignorecase  " 搜索时忽略大小写
set smartcase  " 有一个或以上大写字母时变成大小写敏感
set foldenable  " 代码折叠 zM全部折叠 zR全部打开 zo开关一个折叠
set smartindent  " Smart indent
set autoindent  " never add copyindent, case error   " copy the previous indentation on autoindenting
" tab相关变更
set tabstop=4  " 设置Tab键的宽度 (等同的空格个数)
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

syntax on  " NOTE: 这条语句放在不同的地方会有不同的效果，经测试,放在这里是比较合适的
"}}}
"}}}
" {{{  对不同文件类型的设置 FileType Settings

" 具体编辑文件类型的一般设置，比如不要 tab 等
augroup tab_indent_settings_by_filetype
    autocmd!
    autocmd filetype python,ruby,snippets setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab ai
    autocmd filetype javascript,html,css,xml,sass,scss setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
    autocmd BufRead,BufNewFile *.md,*.mkd,*.markdown setlocal filetype=markdown
    autocmd BufRead,BufNewFile *.part setlocal filetype=html
    " autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
    autocmd BufWinEnter *.php set mps-=<:>  " disable showmatch when use > in php
    " makefile 必须用tab来进行缩进
    autocmd FileType make setlocal noexpandtab shiftwidth=4 softtabstop=0 list listchars=tab:▸\ ,extends:❯,precedes:❮
    " 下两行是coc-tsserver这么要求的
    autocmd BufRead,BufNewFile *.jsx set filetype=javascript.jsx
    autocmd BufRead,BufNewFile *.tsx set filetype=typescript.tsx
    " NOTE: 如果js之类的大文件高亮渲染不同步 可以开启这两个可能影响性能的选项
    " autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
    " autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear"
    " 在右边窗口打开help,man, q快速退出
    autocmd filetype man,help wincmd L | nnoremap <silent> <buffer> q :q!<cr>
    autocmd filetype fugitiveblame,fugitive nnoremap <silent> <buffer> q :q!<cr>

augroup end
"}}}
"{{{ 自动命令设置 Autocmds Settings
augroup auto_actions_for_better_experience
    autocmd!
    " 自动source VIMRC
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
    " 打开自动定位到最后编辑的位置, FIXME: 需要确认 .viminfo 当前用户有可写权限
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exec "normal! g'\" \| zz" | endif
    " 进入新窗口始终让viewport居中
    autocmd BufWinEnter * exec 'normal! zz'
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
        endif
    endfunction
    "}}}
    autocmd UIEnter,UILeave,WinEnter,WinLeave,BufLeave,BufEnter * call Change_mapping_for_quickfix()
    " 关闭quickfix时恢复快捷键q
    autocmd UILeave * nmap q q
    " 进入diff模式关闭语法高亮，离开时恢复语法高亮 FIXME: 不确定会不会有性能问题
    autocmd User MyEnterDiffMode if (&filetype != '' && &diff) | windo setlocal syntax=off | windo setlocal wrap
    " FIXME: 这里的set syntax=on可能会影响某些特殊的文件类型的高亮渲染, 所以必要时应该排除在外
    autocmd WinEnter,WinLeave * if (&filetype != '' && &syntax != 'on' && !&diff && &filetype != 'far')
                \ | set syntax=on | endif
    " 只在当前窗口显示corsorline
    autocmd WinLeave * if g:in_transparent_mode == 0 | setlocal nocursorline
    autocmd WinEnter * if g:in_transparent_mode == 0 | setlocal cursorline
    " 每次隐藏浮动窗口重置全屏状态
    autocmd WinLeave * if &filetype == 'floaterm' | let g:My_full_screen_floterm_status = 0 | setlocal laststatus=2 | endif
    " HACK: 解决markdonw不能正常高亮的问题, 方法是试出来的，原因不明确, 不过影响也不大
    autocmd User StartifyBufferOpened if &ft == 'markdown' | set syntax=on | endif
    autocmd BufWinEnter,WinEnter,BufEnter * if &ft == 'markdown' | set syntax=on | endif
augroup end
"}}}
"{{{ 自定义高亮 Highlighting, ColorScheme

" {{{ 基础调色盘
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
              \ 'none':       ['NONE',      'NONE', 'NONE'],
              \ 'blue':       ['#399ce5', '175', 'Blue'],
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
"}}}

" 切换colorscheme时需要调用这个函数覆盖默认的设置
function s:Enable_normal_scheme() abort
    "{{{ TODO: FIXME: BUG: NOTE: HACK: 自定义标记配色
        highlight! MyTodo cterm=bold ctermbg=180 ctermfg=black gui=bold guifg=#ff8700
        highlight! MyNote cterm=bold ctermbg=75 ctermfg=black gui=bold guifg=#19dd9d
        highlight! MyFixme cterm=bold ctermbg=189 ctermfg=black gui=bold guifg=#e697e6
        highlight! MyBug cterm=bold ctermbg=168 ctermfg=black gui=bold guifg=#dd698c
        highlight! MyHack cterm=bold ctermbg=240 ctermfg=black gui=bold guifg=#f4da9a
        highlight! link MyTip MyHack

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
    " {{{折叠，侧栏，Signature的mark标记
    "             高亮组名     前景色         背景色
    call s:HL('FoldColumn', s:palette.grey, s:palette.bg2)
    call s:HL('Folded', s:palette.grey, s:palette.none)
    call s:HL('SignColumn', s:palette.fg0, s:palette.none)
    call s:HL('OrangeSign', s:palette.orange, s:palette.none)
    call s:HL('PurpleSign', s:palette.purple, s:palette.none)
    call s:HL('BlueSign', s:palette.blue, s:palette.none)
    " vsplit分割线
    highlight! VertSplit guifg=#658494 guibg=None
    " kshenoy/vim-signature 标记的配色
    highlight! link SignatureMarkText OrangeSign
    highlight! link SignatureMarkerText PurpleSign
    " highlight! LineNr guifg=#717172
    highlight! LineNr guifg=#9d9d9d
"}}}
" {{{ startify启动页面
    highlight! StartifyHeader cterm=bold ctermbg=black ctermfg=75 gui=bold guifg=#87bb7c
    highlight! StartifyFile cterm=None ctermfg=75 gui=None guifg=#d8b98a
    highlight! StartifyNumber cterm=None ctermfg=75 gui=None guifg=#7daea3
"}}}
" {{{ Spelunker 拼写检查
    " spelunker的popup menue配色(只支持cterm, 但又要兼顾coc的gui补全配色)
    hi! Pmenu ctermfg=188 ctermbg=240 cterm=NONE guifg=#aebbc5 guibg=#425762 gui=NONE
    hi! PmenuSel ctermfg=237 ctermbg=246 cterm=NONE guifg=#2c3a41 guibg=#69c5ce gui=NONE

    " spelunker 显示错误单词的颜色
    highlight! SpelunkerSpellBad cterm=undercurl ctermfg=247 gui=undercurl guifg=#9e9e9e
    highlight! SpelunkerComplexOrCompoundWord cterm=undercurl ctermfg=247 gui=undercurl guifg=#9e9e9e
"}}}
"{{{ diff单词的高亮
    hi! DiffText ctermfg=237 ctermbg=246 cterm=undercurl guifg=#3397dd gui=undercurl
"}}}
"{{{让JSONC的注释高亮正常
augroup enable_comment_highlighting_for_json
    autocmd!
    autocmd FileType json syntax match Comment +\/\/.\+$+
augroup end
"}}}
"{{{ Vim-Which-Key高亮
highlight! WhichKey gui=None guifg=#c765c8
highlight! WhichKeySeperator gui=None guifg=#00b37d
highlight! WhichKeyGroup   gui=None guifg=#3397dd
highlight! WhichKeyDesc    gui=None  guifg=#5686dd
" 让弹窗背景自适应主题的背景色
highlight! WhichKeyFloating gui=None
"}}}
" {{{浮动终端配色
hi! FloatermNF guibg=None
hi! FloatermBorderNF guibg=None guifg=#828282
"}}}
" {{{ Illuminate相同单词高亮
hi link illuminatedWord Visual
"}}}
"{{{取消snippets文件前导空格高亮
hi! snipLeadingSpaces guibg=None
hi! link snipSippetFooterKeyword snipSnippetHeaderKeyword
"}}}
endfunction

call s:Enable_normal_scheme()
"}}}

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
command! RefreshSyntax :set syntax=off | set syntax=on

"==========================================
" 新增功能
"==========================================
" --------- 自动生效的功能 -----------
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
            checktime  " checktime with autoread will sync files on a last-writer-wins basis.
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
"{{{ 自动根据文件类型选择折叠方法
function Change_fold_method_by_filetype()
    set foldlevel=99  " 第一次进入时不折叠
    let s:marker_fold_list = ['vim', 'text', 'zsh', 'tmux']  " 根据文件类型选择不同的折叠模式
    let s:indent_fold_list = ['python']
    let s:expression_fold_list = ['markdown', 'rust', 'vimwiki']
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
"}}}
" ------------------------------------

" --------需要主动了解的功能----------
" {{{对vim作为git difftoll的增强, <leader><leader>q 强制退出difftool
" 当把vim作为git的difftool时，设置 git config --global difftool.trustExitCode true && git config --global mergetool.trustExitCode true
" 在git difftool或git mergetool之后  可以用:cq进行强制退出diff/merge模式，而不会不停地recall another diff/merge file
if &diff
    syn off  " 自动关闭语法高亮
    " 强制退出difftool, 不再自动唤起difftool
    noremap <leader><leader>q <esc>:cq<cr>
    noremap Q <esc>:qa<cr>
    " 在diff hunk之间跳转
    noremap gj ]c
    noremap gk [c
endif
"}}}
"{{{当有两个窗口时, 滚动另一个窗口 <c-j/k/d/e/gg/G>
"{{{ function
function! ScrollAnotherWindow(mode)
    if winnr('$') <= 1
        return
    endif
    noautocmd silent! wincmd p
    if a:mode == 1
        exec "normal! k"
    elseif a:mode == 2
        exec "normal! j"
    elseif a:mode == 3
        exec "normal! \<c-b>"
    elseif a:mode == 4
        exec "normal! \<c-f>"
    elseif a:mode == 5
        exec "normal! gg"
    elseif a:mode == 6
        exec "normal! G"
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
"}}}
"{{{ 快速编辑特定文件 <leader>e{?}
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

" 搜索并alternative文件(比如在c和头文件之间替换, 用于c/cpp和h文件不在同一目录的情况),　具体的可以自己定义字典
"{{{ function
function! Alternative()
    let name = expand("%:t:r")
    let extension = expand("%:e")
    let mapping = {"h": "c", "cpp": "h", 'c': 'h'}
    return name . '.' . get(mapping, extension, "")
endfunction
"}}}
noremap <silent> <leader>ea :<C-U><C-R>=printf("Leaderf file --input %s", Alternative())<CR><CR>
nnoremap <leader>ew :VimwikiIndex<cr>
nnoremap <leader>es :CocCommand snippets.editSnippets<cr>
" 快速编辑同目录下的文件
nnoremap ,e :e <c-r>=expand('%:p:h')<cr>/
nnoremap ,n :!mkdir <c-r>=expand('%:p:h')<cr>/
"}}}
"{{{ 快速添加空白行 {v:count} ]或[<space>
"{{{ function
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
"}}}
" {{{ 切换colorscheme <leader>cj/k
"{{{ function
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
    set syntax=on  " 用于刷新syntax解决markdown奇奇怪怪的渲染
endf
"}}}
" 直接选择主题
for i in range(1, len(g:all_colorschemes))
    execute 'nnoremap <silent> <leader>c' . i . ' :call My_change_colorscheme(' . (i-1) . ')<cr>'
endfor
nnoremap <silent> <leader>cj :call My_change_colorscheme('next')<cr>
nnoremap <silent> <leader>ck :call My_change_colorscheme('previous')<cr>
"}}}
" {{{ 行号开关，用于鼠标复制代码用, 为方便复制 <F2>
"{{{ function
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
"}}}
nnoremap <F2> :call ToggleColumnNumber()<cr>
" }}}
"{{{ 部分插件开关，提升大文件编辑体验 <F4>
"{{{ function
function Faster_mode_for_large_file()
    " 开关spelunker拼写检查插件
    execute 'normal ZT'
    " 这个一般由于向VCS仓库中新增了大文件而导致的大面积column实时重绘, 所以需要关闭
    execute 'SignifyToggle'
    execute 'ALEToggleBuffer'
endfunction
"}}}
nnoremap <F4> :call Faster_mode_for_large_file()<cr>
"}}}
" {{{查看highlighting group <F12>
"{{{ function
function! s:synstack()
    echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), ' -> ')
endfunction
"}}}
nnoremap <F12> :<C-u>call <SID>synstack()<CR>
"}}}
" 代码高亮开关 <leader>0{{{
nnoremap <leader>0 :exec exists('syntax_on') ? 'syn off' : 'syn on'<cr>
"}}}
" {{{ 切换透明模式, 需要预先设置好终端的透明度 <leader>tt
"{{{ function
function s:Enable_transparent_scheme() abort
    call s:HL('FoldColumn', s:palette.grey, s:palette.none)
    call s:HL('Folded', s:palette.grey, s:palette.none)
    call s:HL('SignColumn', s:palette.none, s:palette.none)
    call s:HL('OrangeSign', s:palette.orange, s:palette.none)
    call s:HL('PurpleSign', s:palette.purple, s:palette.none)
    call s:HL('BlueSign', s:palette.none, s:palette.none)
endfunction

let g:in_transparent_mode = 0
function! Toggle_transparent_background()
  if g:in_transparent_mode == 1
    let g:in_transparent_mode = 0
    set laststatus=2
    setlocal cursorline
    syn off | syn on
    " illuminate插件
    silent! IlluminationEnable
    silent! DoMatchParen
    " matchup插件
    call s:Enable_normal_scheme()
  else
    let g:in_transparent_mode = 1
    set laststatus=0
    setlocal nocursorline
    hi Normal guibg=NONE ctermbg=NONE
    silent! IlluminationDisable
    silent! NoMatchParen
    call s:Enable_transparent_scheme()
  endif
endfunction
"}}}
nnoremap <silent> <leader>tt :call Toggle_transparent_background()<CR>
"}}}
"{{{ 检查Vim运行性能,结果放在profile.log中,需要用两次 <leader>cp
"{{{ function
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
"}}}
"{{{ 复制当前文件的名字，绝对路径，目录绝对路径
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
"}}}
