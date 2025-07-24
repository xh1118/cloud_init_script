#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# ✅ 防止 SSH 被升级中断
apt-mark hold openssh-server openssh-client || true

# ✅ 检查 root 权限
if [ "$EUID" -ne 0 ]; then 
    echo "请使用 root 用户运行此脚本"
    exit 1
fi

# ✅ 创建 swap（标准写法，无重复判断）
echo "创建4GB虚拟内存..."
fallocate -l 4G /home/ubuntu/swapfile
chmod 600 /home/ubuntu/swapfile
mkswap /home/ubuntu/swapfile
swapon /home/ubuntu/swapfile
echo '/home/ubuntu/swapfile none swap sw 0 0' >> /etc/fstab

# ✅ 安装依赖
apt update
apt install -y make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
  libffi-dev liblzma-dev git

# ✅ 以 ubuntu 用户安装 pyenv、Python、虚拟环境
sudo -u ubuntu -H bash <<'EOF'
set -e
export HOME="/home/ubuntu"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# 安装 pyenv
rm -rf "$PYENV_ROOT"
git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$HOME/.bashrc"
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> "$HOME/.bashrc"
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> "$HOME/.bashrc"
source "$HOME/.bashrc"

# 安装 Python 3.11.0
pyenv install 3.11.0
pyenv global 3.11.0

# 安装 pyenv-virtualenv 插件
git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"
echo 'eval "$(pyenv virtualenv-init -)"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"

# 创建虚拟环境
pyenv virtualenv 3.11.0 Alpha

# 不在脚本里激活虚拟环境和安装 pip 包
EOF

echo "请登录 ubuntu 用户后，执行以下命令激活虚拟环境并安装包："
echo "source ~/.bashrc"
echo "pyenv activate Alpha"
echo "pip install --upgrade pip setuptools wheel"
echo "pip install xbx-py11"

# ✅ 安装 Node.js 和 PM2
apt install -y nodejs npm
npm install -g pm2

# ✅ 安装 Chrome
cd /home/ubuntu
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || apt --fix-broken install -y
rm -f google-chrome-stable_current_amd64.deb

# ✅ 安装 pip 包到 Alpha 虚拟环境
/home/ubuntu/.pyenv/versions/Alpha/bin/pip install --upgrade pip setuptools wheel
/home/ubuntu/.pyenv/versions/Alpha/bin/pip install xbx-py11

echo "🎉 安装完成！pyenv、Python、Alpha 虚拟环境、xbx-py11、PM2、Chrome 安装成功"
