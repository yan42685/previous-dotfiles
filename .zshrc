# 需要下载的软件: fzf, nnn
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
# 其他设置
set -o monitor
set +o nonotify
umask 077  # 新建文件的权限
# 插件设置
# Auto load
ZGEN_AUTOLOAD_COMPINIT=0  # 不要使用ZGEN的compinit
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
GIT_AUTO_FETCH_INTERVAL=1200 #in seconds
# {{{ completion
#
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
# {{{zsh-autosuggestions
export ZSH_AUTOSUGGEST_USE_ASYNC="true"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
# }}}

# load zgen
source "${HOME}/.zgen/zgen.zsh"
# if the init scipt doesn't exist
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh  # 加载oh-my-zsh的lib文件，但是不支持 DISABLE_LS_COLORS="true" 这样的 OMZ专属设置
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/z
    zgen oh-my-zsh plugins/vi-mode
    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/extract
    zgen oh-my-zsh plugins/colorize
    zgen oh-my-zsh plugins/z
    zgen oh-my-zsh plugins/git-auto-fetch
    zgen load romkatv/powerlevel10k powerlevel10k
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-autosuggestions
    zgen load zsh-users/zsh-completions
    zgen load zsh-users/zsh-history-substring-search
    zgen load djui/alias-tips  # 如果使用的不是缩写命令，会自动提醒你之前定义的alias
    zgen load peterhurford/git-it-on.zsh  # open your current folder, on your current branch, in GitHub or GitLab
                                          # NOTE: This was built on a Mac. 在Linux不一定有效, 并且只有当文件夹名字和远程仓库一致才有效
    zgen load changyuheng/fz    # 为z添加<tab>后的fuzzy补全列表
                                # NOTE: 需要在z之后source, 依赖fzf

    # zgen load
    # zgen load
    # zgen load
    # zgen load
    # zgen load
    # zgen load
    zgen load StackExchange/blackbox  # 在VCS里选择性加密文件 you don't have to worry about storing your VCS repo on an untrusted server
    zgen load unixorn/autoupdate-zgen  # 自动更新zgen及相关插件

    # zgen load /path/to/super-secret-private-plugin

    # save all to init script
    zgen save
fi


alias ts="trash"
# 安全的cp和mv，防止误操作覆盖同名文件
alias cp="cp -ip"
alias mv="mv -i"
alias cat='ccat'
alias vi='nvim'
# alias vim='nvim'
alias dot='/usr/bin/git --git-dir=/home/yy/.dotfiles/ --work-tree=/home/yy'   # 用于存放dotfiles
alias rm='trash'

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
bindkey -s '^ ' ' git status --short^M'  # Ctrl+space: print Git status


###############################################################################################################################################
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
# export PATH variables{{{
export TERM=xterm-256color
export NNN_USE_EDITOR=1                                 # use the $EDITOR when opening text files
export EDITOR=vim
# 下面这条选项会让git的输出用nvim来打开
# export PAGER="nvim --cmd 'let g:vimManPager = 1' -c MANPAGER -"
export MANPAGER="nvim --cmd 'let g:vimManPager = 1' -c MANPAGER -"
export BROWSER="chromium"
export NNN_COLORS="2136"                        # use a different color for each context
export NNN_TRASH=1     # trash (needs trash-cli) instead of delete
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color? [Yes, No, Abort, Edit] "
export FuzzyFinder="fzf"

# }}}
# Options{{{
ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)  # .zshrc修改时自动更新zgen
setopt COMPLETEALIASES     # complete alias
setopt correctall



#########  completion #########
# }}}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
