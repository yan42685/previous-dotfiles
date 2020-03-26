## 依赖
 包管理器最好换源
- pyenv
```
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
```
```
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
```

- python3
- snap
- zsh
- zgen
- neovim-remote(命令为nvr) `pip3 install neovim-remote`
- nvim
- lua
- node, npm
- trash
- ccls （from snap)
- universal ctags
- global
- NerdFont终端字体: SauceCodePro NF (regular+bold+italic+bold italic) + DroidSansMono NF
- eslint prettier pylint autopep8 cppcheck clang-format
- rg
- fzf
- tmux (tmux-finger插件依赖gawk包, `sudo apt install gawk`)

可有可无的软件
- nnn
- bat
- 无道词典
- gdb-dashboard


#### 如何在远程机器上使用本地zsh
https://github.com/rutchkiwi/copyzshell
```
git clone https://github.com/rutchkiwi/copyzshell.git ~ZSH_CUSTOM/plugins/copyzshell
```
test

```
copyzshell <remote machine>
```
#### 如何在远程机器上使用本地vim
https://unix.stackexchange.com/questions/202918/how-do-i-remotely-edit-files-via-ssh
使用sshfs把远程文件夹mount到本地

test
