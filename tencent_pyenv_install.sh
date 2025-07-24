#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

echo "✅ 设置防 SSH 掉线..."
apt-mark hold openssh-server openssh-client || true

echo "✅ 检查并创建 swap..."
if swapon --show | grep -q "/swapfile"; then
    echo "swapfile 已存在，跳过创建。"
else
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

echo "✅ 以 ubuntu 用户身份安装 pyenv 和 Python..."
sudo -u ubuntu -H bash <<'EOF'
set -e
export HOME="/home/ubuntu"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

rm -rf "$PYENV_ROOT"
git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$HOME/.bashrc"
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> "$HOME/.bashrc"
echo 'eval "$(pyenv init -)"' >> "$HOME/.bashrc"

eval "$(pyenv init -)"

echo "✅ 安装 Python 3.11.0..."
pyenv install 3.11.0
pyenv global 3.11.0

git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_ROOT/plugins/pyenv-virtualenv"
echo 'eval "$(pyenv virtualenv-init -)"' >> "$HOME/.bashrc"
eval "$(pyenv virtualenv-init -)"

pyenv virtualenv 3.11.0 Alpha
pyenv activate Alpha

pip install --upgrade pip setuptools wheel
pip install xbx-py11
EOF

echo "✅ 安装 Node.js 和 PM2..."
apt install -y nodejs npm
npm install -g pm2
pm2 --version

echo "✅ 安装 Chrome..."
cd /home/ubuntu
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || apt --fix-broken install -y
google-chrome --version
rm -f google-chrome-stable_current_amd64.deb

echo "🎉 所有组件安装完成：pyenv / Python 3.11 / PM2 / Chrome / xbx-py11"
