#!/bin/bash

# 阿里云 Ubuntu 服务器专用 pyenv 自动化安装脚本
# 自动安装 pyenv、Python 3.11、虚拟环境、pip库、PM2、Chrome 等

set -e

# 创建4GB虚拟内存（swap）
echo "创建4GB虚拟内存..."
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

echo "开始安装 pyenv 和 Python 3.11 环境..."

# 1. 安装必要的依赖
echo "安装系统依赖..."
apt-get update
apt-get install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev git

# 2. 安装 pyenv
echo "安装 pyenv..."
if [ -d /root/.pyenv ]; then
    echo "/root/.pyenv 已存在，先删除旧目录..."
    rm -rf /root/.pyenv
fi
git clone https://github.com/pyenv/pyenv.git /root/.pyenv

# 3. 配置环境变量
echo "配置环境变量..."
echo 'export PYENV_ROOT="/root/.pyenv"' >> /root/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /root/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> /root/.bashrc

# 4. 重新加载环境变量
echo "重新加载环境变量..."
source /root/.bashrc
export PYENV_ROOT="/root/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# 5. 安装 Python 3.11
echo "安装 Python 3.11..."
pyenv install 3.11.0

# 6. 设置全局 Python 版本
echo "设置全局 Python 版本..."
pyenv global 3.11.0

# 7. 安装 pyenv-virtualenv 插件
echo "安装 pyenv-virtualenv 插件..."
if [ -d "$(pyenv root)/plugins/pyenv-virtualenv" ]; then
    echo "pyenv-virtualenv 已存在，先删除旧目录..."
    rm -rf "$(pyenv root)/plugins/pyenv-virtualenv"
fi
git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"
echo 'eval "$(pyenv virtualenv-init -)"' >> /root/.bashrc
source /root/.bashrc
export PYENV_ROOT="/root/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# 8. 创建并激活虚拟环境
echo "创建 Alpha 虚拟环境..."
pyenv virtualenv 3.11.0 Alpha
pyenv activate Alpha

# 安装 xbx-py11 库
echo "安装 xbx-py11 库..."
pip install xbx-py11

# 安装 PM2
echo "开始安装 PM2..."
apt update
apt install -y nodejs npm
npm install -g pm2
pm2 --version

# 安装谷歌
echo "安装谷歌..."
apt update && apt upgrade -y
cd /root
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
apt --fix-broken install -y
google-chrome --version

echo "PM2、谷歌和 Python 环境安装完成，且安装了 xbx-py11 库。"

rm -f /root/google-chrome-stable_current_amd64.deb

exec $SHELL
exit 