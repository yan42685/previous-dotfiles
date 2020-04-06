# 依赖

包管理器最好换源

- pyenv

```bash
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
```

```bash
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
```

- python3, pip3
- node, npm
- snap
- zsh
- zgen
- nvim
- neovim-remote `pip3 install neovim-remote`
- lua
- trash
- ccls （from snap)
- universal ctags
- global
- NerdFont 终端字体：SauceCodePro NF
  (regular+bold+italic+bold italic) 或 DroidSansMono NF
- eslint prettier pylint autopep8 cppcheck clang-format
- rg
- fzf
- tmux (tmux-finger 插件依赖 gawk 包，`sudo apt install gawk`)
- cz-cli cz-conventional-changelog `npm install commitizen -g`

# 其他非必须工具推荐

- zeal 查看各种离线文档
- nnn 文件管理器
- bat 略好看的 cat
- 无道词典
- gdb-dashboard 更好看的 gdb
- 如果是用的 gnome-terminal, 可以考虑从`https://github.com/Mayccoll/Gogh`安装比较好看
  的主题（暂时用 material )
- asynctask (`mkdir ~/github && cd ~/github && git clone --depth 1 https://github.com/skywind3000/asynctasks.vim && ln -s ~/github/asynctasks.vim/bin/asynctask ~/.local/bin`)
- Alacritty （这个终端模拟器不能正常显示 emoji, 其他都挺好）
- syncthing.x64 （同步工具）

# 如何在远程机器上使用本地 zsh

[https://github.com/rutchkiwi/copyzshell](https://github.com/rutchkiwi/copyzshell)

```bash
git clone https://github.com/rutchkiwi/copyzshell.git ~ZSH_CUSTOM/plugins/copyzshell
```

```bash
copyzshell <remote machine>
```

# 如何在远程机器上使用本地 vim

[https://unix.stackexchange.com/questions/202918/how-do-i-remotely-edit-files-via-ssh](https://unix.stackexchange.com/questions/202918/how-do-i-remotely-edit-files-via-ssh)

使用 sshfs 把远程文件夹 mount 到本地
