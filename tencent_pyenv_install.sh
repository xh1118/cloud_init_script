#!/bin/bash

# 如果通过 sudo 执行，请使用：
# sudo env DEBIAN_FRONTEND=noninteractive bash ./tencent_pyenv_install.sh

export DEBIAN_FRONTEND=noninteractive
set -e

echo "✅ 设置防 SSH 掉线..."
apt-mark hold openssh-server openssh-client || true

echo "✅ 检查并创建 swap..."
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

echo "✅ 安装 pyenv 所需依赖..."
apt-get update
apt-get install -y make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
  libffi-dev liblzma-dev git

echo "✅ 安装 pyenv..."
rm -rf /home/ubuntu/.pyenv
git clone https://github.com/pyenv/pyenv.git /home/ubuntu/.pyenv

echo "✅ 配置 pyenv 环境变量..."
echo 'export PYENV_ROOT="/home/ubuntu/.pyenv"' >> /home/ubuntu/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/ubuntu/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> /home/ubuntu/.bashrc

export PYENV_ROOT="/home/ubuntu/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
source /home/ubuntu/.bashrc
eval "$(pyenv init -)"

echo "✅ 安装 Python 3.11..."
pyenv install 3.11.0
pyenv global 3.11.0

echo "✅ 安装 pyenv-virtualenv 插件..."
rm -rf "$(pyenv root)/plugins/pyenv-virtualenv"
git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"
echo 'eval "$(pyenv virtualenv-init -)"' >> /home/ubuntu/.bashrc
source /home/ubuntu/.bashrc
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

echo "✅ 创建并激活虚拟环境 Alpha..."
pyenv virtualenv 3.11.0 Alpha
pyenv activate Alpha

echo "✅ 安装构建工具避免 legacy 安装警告..."
pip install --upgrade pip setuptools wheel

echo "✅ 安装 Python 库 xbx-py11..."
pip install xbx-py11

echo "✅ 安装 Node.js 和 PM2..."
apt update
apt install -y nodejs npm
npm install -g pm2
pm2 --version

echo "✅ 安装 Chrome..."
apt update && apt upgrade -y
cd /home/ubuntu
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || apt --fix-broken install -y
google-chrome --version

rm -f /home/ubuntu/google-chrome-stable_current_amd64.deb

echo "✅ 所有组件安装完成：pyenv / Python 3.11 / PM2 / Chrome / xbx-py11"

exec $SHELL
exit
