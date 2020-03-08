# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# export PATH variables{{{
export EDITOR="nvim"
export NNN_USE_EDITOR=1                                 # use the $EDITOR when opening text files
export MANPAGER="vim -c MANPAGER -"
export BROWSER="chromium"
# export NNN_SSHFS_OPTS="sshfs -o follow_symlinks"        # make sshfs follow symlinks on the remote
export NNN_COLORS="2136"                        # use a different color for each context
export NNN_TRASH=1     # trash (needs trash-cli) instead of delete
export EDITOR='nvim'
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color? [Yes, No, Abort, Edit] "
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
bindkey '^k' up-history
bindkey '^j' down-history
bindkey ',' autosuggest-accept  # 采纳补全建议
bindkey -M vicmd 'H' vi-beginning-of-line
bindkey -M vicmd 'L' vi-end-of-line
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

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
# Oh-My-Zsh设置{{{
#
# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_COLORIZE_STYLE="solarized-dark"
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# auto-correction
ENABLE_CORRECTION="true"
autoload -U colors && colors#
# }}}

source ~/powerlevel10k/powerlevel10k.zsh-theme
source $ZSH/oh-my-zsh.sh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
