## 所安装的软件包
- pyenv
    - (具体依赖看https://github.com/pyenv/pyenv/wiki/Common-build-problemsj)      Ubuntu:  sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
    - (git clone https://github.com/yyuu/pyenv.git ~/.pyenv)
- nvim
- zsh
- zgen
- snap
- python3
- lua
- node, npm
- trash
- ccls （from snap)
- universal ctags
- global
- 终端字体: SauceCodePro NF (regular+bold+italic+bold italic) + DroidSansMono NF
- eslint prettier pylint autopep8 cppcheck clang-format
- rg
- fzf
- tmux (tmux-finger插件依赖gawk包, sudo apt install gawk)
- nnn

可有可无的软件
- bat
- 无道词典


#### 如何在远程机器上使用本地zsh: https://github.com/rutchkiwi/copyzshell 提供的copyzshell插件,     git clone https://github.com/rutchkiwi/copyzshell.git ~ZSH_CUSTOM/plugins/copyzshell  copyzshell <remote machine>
#### 如何在远程机器上使用本地vim: https://unix.stackexchange.com/questions/202918/how-do-i-remotely-edit-files-via-ssh  使用sshfs把远程文件夹mount到本地
