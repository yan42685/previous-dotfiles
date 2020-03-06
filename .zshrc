# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/yy/.oh-my-zsh"
export EDITOR="nvim"
export NNN_USE_EDITOR=1                                 # use the $EDITOR when opening text files
export MANPAGER="vim -c MANPAGER -"
export BROWSER="chromium"
# export NNN_SSHFS_OPTS="sshfs -o follow_symlinks"        # make sshfs follow symlinks on the remote
export NNN_COLORS="2136"                        # use a different color for each context
export NNN_TRASH=1                                      # trash (needs trash-cli) instead of delete

# Set fzf installation directory path

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_COLORIZE_STYLE="solarized-dark"
LS_COLORS="ow=01;36;40" && export LS_COLORS  # 解决ls命令出现背景色的问题
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# auto-correction
ENABLE_CORRECTION="true"
autoload -U colors && colors
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color? [Yes, No, Abort, Edit] "

plugins=(git sudo z zsh-syntax-highlighting zsh-autosuggestions zsh-completions vi-mode extract colorize)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

alias ts="trash"
# 安全的cp和mv，防止误操作覆盖同名文件
alias cp="cp -ip"
alias mv="mv -i"
alias zc='z -c'  # 当前目录下跳转
alias vi='nvim'
alias vim='nvim'
alias dot='/usr/bin/git --git-dir=/home/yy/.dotfiles/ --work-tree=/home/yy'   # 用于存放dotfiles
alias rm='trash'

# {{{ [弃用] Vim单实例
# if [ -z "$VIMRUNTIME" ]; then
# alias vim='vim --servername FOO';
# else
# # 单引号不用转义
# alias vim='vim --servername $VIM_SERVERNAME --remote "+wincmd o | Tclose"';
# fi
# }}}
#
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
# 下面内容都是自动生成的
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
