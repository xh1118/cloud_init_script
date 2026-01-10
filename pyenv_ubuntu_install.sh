#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# ✅ 防止 SSH 被升级中断
sudo apt-mark hold openssh-server openssh-client || true

# ✅ 创建 swap（标准写法，无重复判断）
echo "创建4GB虚拟内存..."
SWAP_FILE="$HOME/swapfile"
sudo fallocate -l 8G "$SWAP_FILE"
sudo chmod 600 "$SWAP_FILE"
sudo mkswap "$SWAP_FILE"
sudo swapon "$SWAP_FILE"
echo "$SWAP_FILE none swap sw 0 0" | sudo tee -a /etc/fstab

# ✅ 安装依赖
sudo apt update
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
  libffi-dev liblzma-dev git

# ✅ 安装 pyenv、Python、虚拟环境
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# 安装 pyenv
rm -rf "$PYENV_ROOT"
git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"

# 完整的环境变量设置
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$HOME/.bashrc"
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> "$HOME/.bashrc"
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> "$HOME/.bashrc"
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init --path)"\nfi' >> "$HOME/.bashrc"

# 立即加载环境变量
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv init --path)"

# 安装 Python 3.11.11
pyenv install 3.11.11
pyenv global 3.11.11

# 安装 pyenv-virtualenv 插件
git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"
echo 'eval "$(pyenv virtualenv-init -)"' >> "$HOME/.bashrc"

# 立即加载 virtualenv 插件
eval "$(pyenv virtualenv-init -)"

# 创建虚拟环境
pyenv virtualenv 3.11.11 Alpha

echo "pyenv 和 Alpha 环境安装完成"

# ✅ 使用 pyenv shell 命令激活环境（更可靠）
echo "自动激活环境并安装依赖..."
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv shell Alpha

# 验证环境是否正确激活
python --version
which python

# 安装依赖
pip install --upgrade pip setuptools wheel
pip install xbx-py11==0.1.10

echo "Python 依赖安装完成"

# ✅ 安装 Node.js 和 PM2
# 添加 NodeSource 仓库以获取最新的 LTS 版本
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -
sudo apt install -y nodejs

# 安装稳定版本的 PM2
sudo npm install -g pm2@5.3.0

# 验证 PM2 安装
pm2 --version

# ✅ 安装 Chrome
echo "安装谷歌..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt --fix-broken install -y
rm -f google-chrome-stable_current_amd64.deb

# 验证谷歌
google-chrome --version

# ✅ 安装中文字体解决乱码问题
echo "安装中文字体..."
cd /usr/share/fonts/
sudo wget https://github.com/adobe-fonts/source-han-sans/releases/download/2.004R/SourceHanSansSC.zip
sudo apt install unzip -y
sudo unzip SourceHanSansSC.zip
sudo mv OTF/ SourceHanSans/
sudo fc-cache -fv
rm -rf ~/.cache/matplotlib

echo "中文字体安装完成"

# 完成
echo " 安装完成！pyenv、Python、Alpha 虚拟环境、PM2、Chrome、中文字体安装成功"
echo ""
echo "请执行以下命令加载环境："
echo "source ~/.bashrc"
echo "pyenv activate Alpha"
echo ""
echo "或者直接使用："
echo "pyenv shell Alpha"

# 启动新的交互式 shell，保持在虚拟环境中
exec bash -l
exit
