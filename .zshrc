# 需要下载的软件: fzf, nnn, trash, lua
# NOTE: 这些是必须放在p10k-instant-prompt前面的命令{{{
# Disable flow control (ctrl+s, ctrl+q) to enable saving with ctrl+s in Vim
stty -ixon -ixoff
# }}}
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.{{{
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}}

# export PATH variables{{{
export TERM=xterm-256color
export NNN_USE_EDITOR=1                                 # use the $EDITOR when opening text files
export EDITOR=nvim
# 下面这条选项会让git的输出用nvim来打开
# export PAGER="nvim --cmd 'let g:vimManPager = 1' -c MANPAGER -"
export MANPAGER="nvim --cmd 'let g:vimManPager = 1' -c MANPAGER -"
export BROWSER="chromium"
export NNN_COLORS="2136"                        # use a different color for each context
export NNN_TRASH=1     # trash (needs trash-cli) instead of delete
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color? [Yes, No, Abort, Edit] "
export FuzzyFinder="fzf"
# fzf查询隐藏文件
export FZF_DEFAULT_COMMAND='rg --hidden --ignore .git -g ""'

# }}}

# General settings{{{
set -o monitor
set +o nonotify
umask 077  # 新建文件的权限
setopt hist_save_no_dups hist_ignore_dups       # eliminate duplicate entries in history
setopt correctall                               # enable auto correction
setopt autopushd pushdignoredups                # auto push dir into stack and and don’t duplicate them
autoload -U promptinit && promptinit  # FIXME: 不太了解这句话的作用
# }}}

# Plugin settings{{{
ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)  # .zshrc修改时自动更新zgen
ZGEN_AUTOLOAD_COMPINIT=0  # 不要使用ZGEN的compinit
# GIT_AUTO_FETCH_INTERVAL=1200 #in seconds
# zsh-autosuggestion
export ZSH_AUTOSUGGEST_USE_ASYNC="true"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
FZ_HISTORY_CD_CMD="_zlua"  # NOTE: 必须在fz加载之前
# }}}

# {{{ completion settings
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Set options
setopt MENU_COMPLETE       # press <Tab> one time to select item
setopt COMPLETEALIASES     # complete alias
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
setopt EXTENDED_GLOB       # Needed for file modification glob modifiers with compinit
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.cache/.zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
if zstyle -t ':prezto:module:completion:*' case-sensitive; then
    zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    setopt CASE_GLOB
else
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    unsetopt CASE_GLOB
fi

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word. But make
# sure to cap (at 7) the max-errors to avoid hanging.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environment Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion. But allow ignoring custom entries from static
# */etc/hosts* which might be uninteresting.
zstyle -a ':prezto:module:completion:*:hosts' etc-host-ignores '_etc_host_ignores'

zstyle -e ':completion:*:hosts' hosts 'reply=(
    ${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
    ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%(\#${_etc_host_ignores:+|${(j:|:)~_etc_host_ignores}})*}
    ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Don't complete uninteresting users...
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
    dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
    hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
    mailman mailnull mldonkey mysql nagios \
    named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
    operator pcap postfix postgres privoxy pulse pvm quagga radvd \
    rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# auto rehash
zstyle ':completion:*' rehash true

#highlight prefix
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Media Players
zstyle ':completion:*:*:mpg123:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:mpg321:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:ogg123:*' file-patterns '*.(ogg|OGG|flac):ogg\ files *(-/):directories'
zstyle ':completion:*:*:mocp:*' file-patterns '*.(wav|WAV|mp3|MP3|ogg|OGG|flac):ogg\ files *(-/):directories'

# Mutt
if [[ -s "$HOME/.mutt/aliases" ]]; then
    zstyle ':completion:*:*:mutt:*' menu yes select
    zstyle ':completion:*:mutt:*' users ${${${(f)"$(<"$HOME/.mutt/aliases")"}#alias[[:space:]]}%%[[:space:]]*}
fi

# SSH/SCP/RSYNC
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
# }}}

# load zgen Plugins
# {{{
source "${HOME}/.zgen/zgen.zsh"
# if the init scipt doesn't exist
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh  # 加载oh-my-zsh的lib文件，但是不支持 DISABLE_LS_COLORS="true" 这样的 OMZ专属设置
    zgen load skywind3000/z.lua  # Windows下也能用, FIXME: 如果z.lua不生效，就先把~/.zgen/ohmyzsh/ohmyzsh-master/plugins/z给删掉
                                # NOTE: 必须放在fz之前加载
    zgen load changyuheng/fz    # 为z添加<tab>后的fuzzy补全列表, 并提供进入非历史目录的功能(即cd)
                                # NOTE: 需要在z之后source, 依赖fzf
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/vi-mode
    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/extract
    zgen oh-my-zsh plugins/colorize
    # zgen oh-my-zsh plugins/git-auto-fetch
    zgen load romkatv/powerlevel10k powerlevel10k
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-autosuggestions
    zgen load zsh-users/zsh-completions
    zgen load zsh-users/zsh-history-substring-search
    zgen load djui/alias-tips  # 如果使用的不是缩写命令，会自动提醒你之前定义的alias
    zgen load urbainvaes/fzf-marks
    zgen load hlissner/zsh-autopair
    zgen load peterhurford/git-it-on.zsh  # open your current folder, on your current branch, in GitHub or GitLab
                                          # NOTE: This was built on a Mac. 在Linux不一定有效, 并且只有当文件夹名字和远程仓库一致才有效
    zgen load StackExchange/blackbox  # 在VCS里选择性加密文件 you don't have to worry about storing your VCS repo on an untrusted server
    zgen load unixorn/autoupdate-zgen  # 自动更新zgen及相关插件
    # zgen load https://github.com/sainnhe/dotfiles/raw/master/.zsh-theme-gruvbox-material-dark
    # zgen load yan42685/dotfiles .zsh-theme/.gruvbox-material-dark
    # zgen load sainnhe/dotfiles .zsh-theme-gruvbox-material-dark

    # zgen load /path/to/super-secret-private-plugin

    # save all to init script
    zgen save
fi
# }}}



alias y='ydict'
alias t='tmux'
alias ts="trash"
# 安全的cp和mv，防止误操作覆盖同名文件
alias cp="cp -ip"
alias mv="mv -i"
alias cat='bat'
alias vi='nvim'
alias vim='nvim'
alias vimm='\vim'   # 用转义符防止递归映射
alias dot='/usr/bin/git --git-dir=/home/yy/.dotfiles/ --work-tree=/home/yy'   # 用于存放dotfiles
alias rm='trash'
alias nnn='PAGER= nnn'
alias zho='z ~'
alias zh='z -I -t .'  # MRU
alias zb='z -b'  # 项目目录
alias zc='z -c' # 严格匹配当前路径的子路径
alias zf='z -I' # 使用 fzf 对多个结果进行选择
alias zbf='z -b -I'
alias diff='nvim -d'

# 下面的alias参考common-alias插件
alias zshrc='${=EDITOR} ~/.zshrc' # Quick access to the ~/.zshrc file
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"


# 采纳补全建议
bindkey ',' autosuggest-accept
bindkey 'kj' vi-cmd-mode
bindkey '^h' beginning-of-line
bindkey '^l' end-of-line
# 增量查询历史命令记录
bindkey '^r' history-incremental-search-backward
bindkey '^k' history-substring-search-up
bindkey '^j' history-substring-search-down
bindkey ',' autosuggest-accept  # 采纳补全建议
bindkey -M vicmd 'H' vi-beginning-of-line
bindkey -M vicmd 'L' vi-end-of-line


# {{{
insert-last-command-output() {
LBUFFER+="$(eval $history[$((HISTCMD-1))])"
}
zle -N insert-last-command-output
# }}}
bindkey '^[x' insert-last-command-output  # insert last command result
bindkey -M menuselect '^M' .accept-line  # In menu completion, the Return key will accept the current selected match
# bindkey -s '^ ' ' git status --short^M'  # Ctrl+space: print Git status


############################################################
# {{{ [弃用] Vim单实例
# if [ -z "$VIMRUNTIME" ]; then
# alias vim='vim --servername FOO';
# else
# # 单引号不用转义
# alias vim='vim --servername $VIM_SERVERNAME --remote "+wincmd o | Tclose"';
# fi
# }}}
# 解决ls命令出现奇怪背景色的问题{{{
# Change ls colours
LS_COLORS="ow=01;36;40" && export LS_COLORS
# }}}
# {{{ 命令行浏览Reddit的工具: rtv
export RTV_EDITOR="vim"
export RTV_BROWSER="w3m"
export RTV_URLVIEWER="urlscan"
# }}}
# {{{fzf
# export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="
-m --height=50%
--layout=reverse
--prompt='➤ '
--ansi
--tabstop=4
--color=dark
--color=bg:-1,hl:2,fg+:4,bg+:-1,hl+:2
--color=info:11,prompt:2,pointer:5,marker:1,spinner:3,header:11
"
# }}}
# {{{fzf-marks
# Usage: mark fzm C-d
FZF_MARKS_FILE="$HOME/.cache/fzf-marks"
FZF_MARKS_COMMAND="fzf"
FZF_MARKS_COLOR_RHS="249"
# }}}
# {{{Utility Functions 可以在命令行直接使用
test_cmd_pre() { # {{{
    command -v "$1" >/dev/null
} # }}}
test_cmd() { # {{{
    test_cmd_pre "$1" && echo 'yes' || echo 'no'
} # }}}
# {{{zcomp-gen
zcomp-gen () {
    echo "[1] manpage  [2] help"
    read -r var
    if [[ "$var"x == ""x ]]; then
        var=1
    fi
    if [[ "$var"x == "1"x ]]; then
        TARGET=$(find -L /usr/share/man -type f -print -o -type l \
            -print -o  \( -path '*/\.*' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \) \
            -prune 2> /dev/null |\
            sed 's|\./||g' |\
            sed '1i [cancel]' |\
            fzf)
        if [[ "$TARGET"x == "[cancel]"x ]]; then
            echo ""
        else
            echo "$TARGET" | xargs -i sh ~/.zplugin/plugins/nevesnunes---sh-manpage-completions/gencomp-manpage {}
            zpcompinit
        fi
    elif [[ "$var"x == "2"x ]]; then
        TARGET=$(compgen -cb | sed '1i [cancel]' | fzf)
        if [[ "$TARGET"x == "[cancel]"x ]]; then
            echo ""
        else
            gencomp "$TARGET"
            zpcompinit
        fi
    fi
}
# }}}
# }}}
# Z.lua{{{
export _ZL_DATA="$HOME/.cache/.zlua"
export _ZL_MATCH_MODE=1  # 增强匹配模式
export _ZL_ROOT_MARKERS=".git,.svn,.hg,.root,package.json"  # 设定项目根目录列表
function _z() { _zlua "$@"; }  # 整合fz与zlua
# }}}

# {{{FuzzyFinder
# fuzzy match dirs and cd
cdf() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
        -o -type d -print 2> /dev/null | "$FuzzyFinder") &&
        cd "$dir"
    }
# include hidden dirs
cdf-all() {
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null | grep -v ".git/" | "$FuzzyFinder") && cd "$dir"
}
# job to fore
job-fore() {
    JOB_ID=$(jobs | grep "[[[:digit:]]*]" | "$FuzzyFinder" | grep -o "[[[:digit:]]*]" | grep -o "[[:digit:]]*")
    fg %"$JOB_ID"
}

# job to back
job-back() {
    JOB_ID=$(jobs | grep "[[[:digit:]]*]" | "$FuzzyFinder" | grep -o "[[[:digit:]]*]" | grep -o "[[:digit:]]*")
    bg %"$JOB_ID"
}

# job kill
job-kill() {
    JOB_ID=$(jobs | grep "[[[:digit:]]*]" | "$FuzzyFinder" | grep -o "[[[:digit:]]*]" | grep -o "[[:digit:]]*")
    kill %"$JOB_ID"
}

# ps ls
ps-ls() {
    PROC_ID_ORIGIN=$(ps -alf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        echo "$PROC_ID_ORIGIN"
    fi
}

# ps ls all
ps-ls-all() {
    PROC_ID_ORIGIN=$(ps -elf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        echo "$PROC_ID_ORIGIN"
    fi
}

# ps info
ps-info() {
    PROC_ID_ORIGIN=$(ps -alf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        top -p "$PROC_ID"
    fi
}

# ps info all
ps-info-all() {
    PROC_ID_ORIGIN=$(ps -elf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        top -p "$PROC_ID"
    fi
}

# ps tree
ps-tree() {
    PROC_ID_ORIGIN=$(ps -alf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        pstree -p "$PROC_ID"
    fi
}

# ps tree all
ps-tree-all() {
    PROC_ID_ORIGIN=$(ps -elf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        pstree -p "$PROC_ID"
    fi
}

# ps kill
ps-kill() {
    PROC_ID_ORIGIN=$(ps -alf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        kill -9 "$PROC_ID"
    fi
}

# ps kill
ps-kill-all() {
    PROC_ID_ORIGIN=$(ps -elf | "$FuzzyFinder")
    if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
        PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        kill -9 "$PROC_ID"
    fi
}
# }}}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh








# This theme is gruvbox material version of purepower(powerlevel10k)
# Upstream: https://github.com/romkatv/dotfiles-public/blob/master/.purepower

# PURE_POWER_MODE=modern    use nerdfont characters in the prompt
# PURE_POWER_MODE=fancy     use unicode characters in the prompt
# PURE_POWER_MODE=portable  use only ascii characters in the prompt
PURE_POWER_MODE=modern

if autoload -U is-at-least && is-at-least 5.7 && [[ $COLORTERM == (24bit|truecolor) || ${terminfo[colors]} -eq 16777216 ]]; then
    DESERT_NIGHT_PURE_POWER_TRUE_COLOR=true
else
    DESERT_NIGHT_PURE_POWER_TRUE_COLOR=false
fi

if test -z "${ZSH_VERSION}"; then
  echo "purepower: unsupported shell; try zsh instead" >&2
  return 1
  exit 1
fi

() {
  emulate -L zsh && setopt no_unset pipe_fail

  # `$(_pp_c x y`) evaluates to `y` if the terminal supports >= 256 colors and to `x` otherwise.
  zmodload zsh/terminfo
  if (( terminfo[colors] >= 256 )); then
    function _pp_c() { print -nr -- $2 }
  else
    function _pp_c() { print -nr -- $1 }
    typeset -g POWERLEVEL9K_IGNORE_TERM_COLORS=true
  fi

  # `$(_pp_s x y`) evaluates to `x` in portable mode and to `y` in fancy mode.
  if [[ ${PURE_POWER_MODE:-fancy} == fancy || $PURE_POWER_MODE == modern ]]; then
    function _pp_s() { print -nr -- $2 }
  else
    if [[ $PURE_POWER_MODE != portable ]]; then
      echo -En "purepower: invalid mode: ${(qq)PURE_POWER_MODE}; " >&2
      echo -E  "valid options are 'modern', 'fancy' and 'portable'; falling back to 'portable'" >&2
    fi
    function _pp_s() { print -nr -- $1 }
  fi

  typeset -ga POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
      dir vcs)

  typeset -ga POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      status command_execution_time background_jobs custom_rprompt context)

  local ins=$(_pp_s '>' '❯')
  local cmd=$(_pp_s '<' '❮')
  if (( ${PURE_POWER_USE_P10K_EXTENSIONS:-1} )); then
    local p="\${\${\${KEYMAP:-0}:#vicmd}:+${${ins//\\/\\\\}//\}/\\\}}}"
    p+="\${\${\$((!\${#\${KEYMAP:-0}:#vicmd})):#0}:+${${cmd//\\/\\\\}//\}/\\\}}}"
  else
    p=$ins
  fi
  if [[ "$DESERT_NIGHT_PURE_POWER_TRUE_COLOR" == "true" ]]; then
    local ok="%F{#d4be98}${p}%f"
    local err="%F{#ea6962}${p}%f"
  else
    local ok="%F{$(_pp_s 007 223)}${p}%f"
    local err="%F{$(_pp_s 001 167)}${p}%f"
  fi

  if (( ${PURE_POWER_USE_P10K_EXTENSIONS:-1} )); then
    typeset -g POWERLEVEL9K_SHOW_RULER=true
    typeset -g POWERLEVEL9K_RULER_CHAR=$(_pp_s '-' '─')
    typeset -g POWERLEVEL9K_RULER_BACKGROUND=none
    if [[ "$DESERT_NIGHT_PURE_POWER_TRUE_COLOR" == "true" ]]; then
      typeset -g POWERLEVEL9K_RULER_FOREGROUND='#665c54'
    else
      typeset -g POWERLEVEL9K_RULER_FOREGROUND=$(_pp_c 7 241)
    fi
  else
    typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
    function custom_rprompt() { }
  fi

  typeset -g POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR=
  typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
  typeset -g POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%(?.$ok.$err) "

  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_WHITESPACE_BETWEEN_{LEFT,RIGHT}_SEGMENTS=

  typeset -g POWERLEVEL9K_DIR_{ETC,HOME,HOME_SUBFOLDER,DEFAULT,NOT_WRITABLE}_BACKGROUND=none
  typeset -g POWERLEVEL9K_{ETC,FOLDER,HOME,HOME_SUB}_ICON=
  if [[ "$DESERT_NIGHT_PURE_POWER_TRUE_COLOR" == "true" ]]; then
    typeset -g POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_VISUAL_IDENTIFIER_COLOR='#e78a4e'
  else
    typeset -g POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_VISUAL_IDENTIFIER_COLOR=$(_pp_c 003 208)
  fi
  if [[ "$PURE_POWER_MODE" == "modern" ]]; then
    typeset -g POWERLEVEL9K_LOCK_ICON=''
  else
    typeset -g POWERLEVEL9K_LOCK_ICON=
  fi
  if [[ "$DESERT_NIGHT_PURE_POWER_TRUE_COLOR" == "true" ]]; then
    typeset -g POWERLEVEL9K_DIR_{ETC,DEFAULT}_FOREGROUND='#89b482'
    typeset -g POWERLEVEL9K_DIR_{HOME,HOME_SUBFOLDER}_FOREGROUND='#a9b665'
    typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_FOREGROUND='#ea6962'
  else
    typeset -g POWERLEVEL9K_DIR_{ETC,DEFAULT}_FOREGROUND=$(_pp_c 006 108)
    typeset -g POWERLEVEL9K_DIR_{HOME,HOME_SUBFOLDER}_FOREGROUND=$(_pp_c 010 142)
    typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_FOREGROUND=$(_pp_c 009 167)
  fi

  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED,LOADING}_BACKGROUND=none
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED}_MAX_NUM=99
  if [[ "$DESERT_NIGHT_PURE_POWER_TRUE_COLOR" == "true" ]]; then
    typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#7daea3'
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#d8a657'
    typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#d3869b'
    typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND='#928374'
  else
    typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$(_pp_c 004 109)
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$(_pp_c 011 214)
    typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$(_pp_c 005 175)
    typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=$(_pp_c 007 245)
  fi
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_UNTRACKEDFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_UNSTAGEDFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_MODIFIED_FOREGROUND
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_STAGEDFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_MODIFIED_FOREGROUND
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_INCOMING_CHANGESFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_FOREGROUND
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_OUTGOING_CHANGESFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_FOREGROUND
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_STASHFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_FOREGROUND
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_ACTIONFORMAT_FOREGROUND=001
  typeset -g POWERLEVEL9K_VCS_LOADING_ACTIONFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_LOADING_FOREGROUND
  if [[ "$PURE_POWER_MODE" == "modern" ]]; then
    typeset -g POWERLEVEL9K_VCS_GIT_ICON=''
    typeset -g POWERLEVEL9K_VCS_GIT_GITHUB_ICON=''
    typeset -g POWERLEVEL9K_VCS_GIT_GITLAB_ICON=''
    typeset -g POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=''
    typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '
    typeset -g POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON=' '
    typeset -g POWERLEVEL9K_VCS_COMMIT_ICON=' '
    typeset -g POWERLEVEL9K_VCS_STAGED_ICON=' '
    typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON=' '
    # typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='✩'
    # typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='✦'
    # typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='٭'
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='❄ '


    typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='⇣'
    typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='⇡'
    typeset -g POWERLEVEL9K_VCS_STASH_ICON='*'
    typeset -g POWERLEVEL9K_VCS_TAG_ICON=' '
  else
    typeset -g POWERLEVEL9K_VCS_{GIT,GIT_GITHUB,GIT_BITBUCKET,GIT_GITLAB,BRANCH}_ICON=
    typeset -g POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON=$'%{\b|%}'
    typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='@'
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
    typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='!'
    typeset -g POWERLEVEL9K_VCS_STAGED_ICON='+'
    typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=$(_pp_s '<' '⇣')
    typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=$(_pp_s '>' '⇡')
    typeset -g POWERLEVEL9K_VCS_STASH_ICON='*'
    typeset -g POWERLEVEL9K_VCS_TAG_ICON=$'%{\b#%}'
  fi

  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=none
  if [[ "$DESERT_NIGHT_PURE_POWER_TRUE_COLOR" == "true" ]]; then
    typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#ea6962'
  else
    typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$(_pp_c 001 167)
  fi
  typeset -g POWERLEVEL9K_CARRIAGE_RETURN_ICON=

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=none
  if [[ "$DESERT_NIGHT_PURE_POWER_TRUE_COLOR" == "true" ]]; then
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#a89984'
  else
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$(_pp_c 008 246)
  fi
  typeset -g POWERLEVEL9K_EXECUTION_TIME_ICON=

  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,ROOT,REMOTE_SUDO,REMOTE,SUDO}_BACKGROUND=none
  if [[ "$DESERT_NIGHT_PURE_POWER_TRUE_COLOR" == "true" ]]; then
    typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,REMOTE_SUDO,REMOTE,SUDO}_FOREGROUND='#e78a4e'
    typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='#ea6962'
  else
    typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,REMOTE_SUDO,REMOTE,SUDO}_FOREGROUND=$(_pp_c 003 208)
    typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=$(_pp_c 001 167)
  fi

  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=none
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_COLOR=2
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_ICON=$(_pp_s '%%' '⇶')

  # typeset -g POWERLEVEL9K_CUSTOM_RPROMPT=custom_rprompt
  # typeset -g POWERLEVEL9K_CUSTOM_RPROMPT_BACKGROUND=none
  # typeset -g POWERLEVEL9K_CUSTOM_RPROMPT_FOREGROUND=$(_pp_c 4 12)

  unfunction _pp_c _pp_s
} "$@"
