#!/bin/bash

# 腾讯云 Ubuntu 服务器专用 Anaconda 自动化安装脚本
# 自动安装 Anaconda、conda虚拟环境、pip库、PM2、Chrome 等

# 设置错误时退出
set -e

# 检查是否为 ubuntu 用户
if [ "$USER" != "ubuntu" ]; then 
    echo "❌ 请使用 ubuntu 用户运行此脚本"
    exit 1
fi

echo "✅ 当前用户为 ubuntu，开始执行安装流程..."

# 创建 4GB 虚拟内存（swap）
echo "📦 创建 4GB 虚拟内存..."
sudo fallocate -l 4G /home/ubuntu/swapfile
sudo chmod 600 /home/ubuntu/swapfile
sudo mkswap /home/ubuntu/swapfile
sudo swapon /home/ubuntu/swapfile
echo '/home/ubuntu/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 安装 Anaconda
echo "📦 开始安装 Anaconda..."
wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh -O /home/ubuntu/anaconda_installer.sh
bash /home/ubuntu/anaconda_installer.sh -b -p /home/ubuntu/anaconda3

# 添加 Anaconda 到 PATH，并初始化 conda
echo 'export PATH="/home/ubuntu/anaconda3/bin:$PATH"' >> /home/ubuntu/.bashrc
/home/ubuntu/anaconda3/bin/conda init bash

# 清理潜在的 bashrc 错误行
sed -i '/^fi$/d' /home/ubuntu/.bashrc

# 加载新的环境变量
source /home/ubuntu/.bashrc

# 验证 Conda 安装
echo "🧪 验证 Conda..."
conda --version

# 安装 Node.js 和 PM2
echo "📦 安装 Node.js 和 PM2..."
sudo apt update
sudo apt install -y nodejs npm
sudo npm install -g pm2
pm2 --version

# 创建 Python 3.11 的虚拟环境 Alpha
echo "🐍 创建 Python 3.11 的 Alpha 环境..."
cd /home/ubuntu/anaconda3
source bin/activate
conda create -n Alpha python=3.11 -y
conda activate Alpha
python --version

# 安装 Python 库 xbx-py11
echo "📦 安装 xbx-py11 库..."
pip install xbx-py11

# 安装谷歌 Chrome
echo "🌐 安装 Google Chrome 浏览器..."
sudo apt update && sudo apt upgrade -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /home/ubuntu/google-chrome.deb
sudo dpkg -i /home/ubuntu/google-chrome.deb || sudo apt --fix-broken install -y
google-chrome --version

# 清理安装文件
rm -f /home/ubuntu/anaconda_installer.sh
rm -f /home/ubuntu/google-chrome.deb

# 成功提示
echo "🎉 安装完成：Anaconda、PM2、Google Chrome、Alpha 环境和 xbx-py11 均已部署成功！"

# 启动交互式 shell 并进入 Alpha 环境
echo "🔄 切换到 Alpha 环境..."
exec bash -i -c "conda activate Alpha"
