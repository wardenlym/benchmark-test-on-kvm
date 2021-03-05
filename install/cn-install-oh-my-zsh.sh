# https://touka.dev/tech/oh-my-zsh-china-mirror/

下载码云安装包
wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
编辑install.sh
找到以下部分

# Default settings
ZSH=${ZSH:-~/.oh-my-zsh}
REPO=${REPO:-ohmyzsh/ohmyzsh}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}
把

REPO=${REPO:-ohmyzsh/ohmyzsh}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
替换为

REPO=${REPO:-mirrors/oh-my-zsh}
REMOTE=${REMOTE:-https://gitee.com/${REPO}.git}
编辑后保存, 运行安装即可. (运行前先给install.sh权限)

修改仓库地址
cd ~/.oh-my-zsh
git remote set-url origin https://gitee.com/mirrors/oh-my-zsh.git
git pull