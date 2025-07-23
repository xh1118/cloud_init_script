#!/bin/bash

# 腾讯云 Ubuntu 服务器专用 Anaconda 自动化安装脚本
# 自动安装 Anaconda、conda虚拟环境、pip库、PM2、Chrome 等

# 设置错误时退出
set -e

# 创建4GB虚拟内存（swap）
echo "创建4GB虚拟内存..."
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then 
    echo "请使用 root 用户运行此脚本"
    exit 1
fi

# 切换到 /root 目录
cd /root

# 安装 Anaconda
echo "开始安装 Anaconda..."
# 下载 Anaconda 安装脚本
wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh -O /root/anaconda_installer.sh
# 运行安装脚本
bash /root/anaconda_installer.sh -b -p /root/anaconda3
# 将 Anaconda 添加到 PATH
echo 'export PATH="/root/anaconda3/bin:$PATH"' >> /root/.bashrc
source /root/.bashrc
# 验证 Anaconda 安装
/root/anaconda3/bin/conda --version

# 安装 PM2
echo "开始安装 PM2..."
# 安装 Node.js（PM2 依赖 Node.js）
apt update
apt install -y nodejs npm
# 安装 PM2
npm install -g pm2
# 验证 PM2 安装
pm2 --version

# 创建 Python 3.11 的 Alpha 环境
echo "创建 Python 3.11 的 Alpha 环境..."
# 切换到 Anaconda3 目录
cd /root/anaconda3
# 激活base环境
source /root/anaconda3/bin/activate
# 创建新的环境
/root/anaconda3/bin/conda create -n Alpha python=3.11 -y
# 激活环境
/root/anaconda3/bin/conda activate Alpha
# 验证 Python 版本
python --version

# 安装 xbx-py11 库
echo "安装 xbx-py11 库..."
pip install xbx-py11

# 安装谷歌
echo "安装谷歌..."
# 更新环境
apt update && apt upgrade -y
# 下载谷歌
cd /root
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# 安装谷歌
dpkg -i google-chrome-stable_current_amd64.deb
apt --fix-broken install -y
# 验证谷歌
google-chrome --version

# 完成
echo "Anaconda、PM2、谷歌和 Python 环境安装完成，且安装了 xbx-py11 库。"

# 清理安装文件
rm -f /root/anaconda_installer.sh
rm -f /root/google-chrome-stable_current_amd64.deb

# 启动新的交互式 shell，保持在虚拟环境中
exec $SHELL
exit 