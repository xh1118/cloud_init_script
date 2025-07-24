#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# ✅ 防止 SSH 被升级中断
apt-mark hold openssh-server openssh-client || true

# ✅ 添加 swap
if swapon --show | grep -q "/swapfile"; then
  echo "swapfile 已存在"
else
  fallocate -l 4G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

# ✅ 安装依赖
apt update
apt install -y make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
  libffi-dev liblzma-dev git

# ✅ 以 ubuntu 用户运行 pyenv 安装和虚拟环境创建
sudo -u ubuntu -H bash <<'EOF'
set -e
export HOME="/home/ubuntu"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# 清理并重新安装 pyenv
rm -rf "$PYENV_ROOT"
git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$HOME/.bashrc"
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> "$HOME/.bashrc"
echo 'eval "$(pyenv init -)"' >> "$HOME/.bashrc"

eval "$(pyenv init -)"

# 安装 Python 3.11 并设为默认
pyenv install 3.11.0
pyenv global 3.11.0

# 安装 virtualenv 插件
git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_ROOT/plugins/pyenv-virtualenv"
echo 'eval "$(pyenv virtualenv-init -)"' >> "$HOME/.bashrc"
eval "$(pyenv virtualenv-init -)"

# 创建并激活虚拟环境
pyenv virtualenv 3.11.0 Alpha
pyenv activate Alpha

# 安装 pip 工具包和你的库
pip install --upgrade pip setuptools wheel
pip install xbx-py11
EOF

# ✅ 安装 Node.js 和 PM2
apt install -y nodejs npm
npm install -g pm2

# ✅ 安装 Chrome
cd /home/ubuntu
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || apt --fix-broken install -y
rm -f google-chrome-stable_current_amd64.deb

echo "🎉 安装完成！pyenv、Python、Alpha 虚拟环境、xbx-py11、PM2、Chrome 安装成功"
