#!/bin/bash

# 注意：如果通过 sudo 执行该脚本，请使用以下方式确保非交互变量生效：
# sudo env DEBIAN_FRONTEND=noninteractive bash ./tencent_pyenv_install.sh

# ✅ 设置非交互模式，防止 apt 卡住
export DEBIAN_FRONTEND=noninteractive

# 腾讯云 Ubuntu 服务器专用 pyenv 自动化安装脚本
# 自动安装 pyenv、Python 3.11、虚拟环境、pip库、PM2、Chrome 等

# ✅ 脚本遇到错误即退出
set -e

# ✅ 防止 openssh-server 被自动升级导致 SSH 掉线
apt-mark hold openssh-server openssh-client || true

# ✅ 创建 4GB 虚拟内存（swap）如不存在
if swapon --show | grep -q "/swapfile"; then
    echo "swapfile 已存在，跳过创建。"
else
    echo "创建4GB虚拟内存..."
    fallocate -l 4G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

echo "开始安装 pyenv 和 Python 3.11 环境..."

# ✅ 安装 pyenv 和 Python 构建所需依赖
apt-get update
apt-get install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev git

# ✅ 安装 pyenv
if [ -d /home/ubuntu/.pyenv ]; then
    echo "/home/ubuntu/.pyenv 已存在，先删除旧目录..."
    rm -rf /home/ubuntu/.pyenv
fi
git clone https://github.com/pyenv/pyenv.git /home/ubuntu/.pyenv

# ✅ 写入 pyenv 环境变量到 .bashrc
echo 'export PYENV_ROOT="/home/ubuntu/.pyenv"' >> /home/ubuntu/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/ubuntu/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> /home/ubuntu/.bashrc

# ✅ 激活 pyenv 环境变量
source /home/ubuntu/.bashrc
export PYENV_ROOT="/home/ubuntu/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# ✅ 安装 Python 3.11 并设为全局默认
pyenv install 3.11.0
pyenv global 3.11.0

# ✅ 安装 pyenv-virtualenv 插件
if [ -d "$(pyenv root)/plugins/pyenv-virtualenv" ]; then
    echo "pyenv-virtualenv 已存在，先删除旧目录..."
    rm -rf "$(pyenv root)/plugins/pyenv-virtualenv"
fi
git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"
echo 'eval "$(pyenv virtualenv-init -)"' >> /home/ubuntu/.bashrc
source /home/ubuntu/.bashrc
export PYENV_ROOT="/home/ubuntu/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# ✅ 创建虚拟环境 Alpha 并激活
pyenv virtualenv 3.11.0 Alpha
pyenv activate Alpha

# ✅ 安装指定 Python 库
pip install xbx-py11

# ✅ 安装 Node.js + PM2
apt update
apt install -y nodejs npm
npm install -g pm2
pm2 --version

# ✅ 安装 Chrome 浏览器（并修复依赖）
apt update && apt upgrade -y --no-upgrade=openssh-server,openssh-client
cd /home/ubuntu
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || apt --fix-broken install -y
google-chrome --version

# ✅ 清理 Chrome 安装包
rm -f /home/ubuntu/google-chrome-stable_current_amd64.deb

echo "✅ 安装完成：PM2、Chrome、Python 环境、xbx-py11 均已就绪。"

exec $SHELL
exit
