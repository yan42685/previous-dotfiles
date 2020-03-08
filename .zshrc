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
# export PATH variables{{{
export TERM=xterm-256color
export NNN_USE_EDITOR=1                                 # use the $EDITOR when opening text files
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=999999999
export SAVEHIST=$HISTSIZE
export EDITOR=vim
export PAGER="nvim --cmd 'let g:vimManPager = 1' -c MANPAGER -"
export MANPAGER="nvim --cmd 'let g:vimManPager = 1' -c MANPAGER -"
export BROWSER="chromium"
export NNN_COLORS="2136"                        # use a different color for each context
export NNN_TRASH=1     # trash (needs trash-cli) instead of delete
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color? [Yes, No, Abort, Edit] "
export FuzzyFinder="fzf"

# }}}
# Options{{{
ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc ${HOME}/.zshrc.local)  # .zshrc修改时自动更新
setopt correct_all
# }}}

# load zgen
source "${HOME}/.zgen/zgen.zsh"
# if the init scipt doesn't exist
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/z
    zgen oh-my-zsh plugins/vi-mode
    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/extract
    zgen oh-my-zsh plugins/colorize
    zgen oh-my-zsh plugins/z
    zgen load romkatv/powerlevel10k powerlevel10k
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-autosuggestions
    zgen load zsh-users/zsh-completions
    zgen load zsh-users/zsh-history-substring-search
    zgen load chrissicool/zsh-256color  # 自动开启终端的256色
    zgen load djui/alias-tips  # 如果使用的不是缩写命令，会自动提醒你之前定义的alias
    zgen load peterhurford/git-it-on.zsh  # open your current folder, on your current branch, in GitHub or GitLab
                                          # NOTE: This was built on a Mac. 在Linux不一定有效
    # zgen load
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
alias zc='z -c'  # 当前目录下跳转
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
# 以下两点是解决ls命令出现背景色的问题{{{
# Change ls colours
LS_COLORS="ow=01;36;40" && export LS_COLORS
# make cd use the ls colours
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
# }}}
# 其他设置

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
