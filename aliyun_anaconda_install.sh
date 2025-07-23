#!/bin/bash

# 阿里云 Ubuntu 服务器专用 Anaconda 自动化安装脚本
# 自动安装 Anaconda、conda虚拟环境、pip库、PM2、Chrome 等

set -e

# 创建4GB虚拟内存（swap）
echo "创建4GB虚拟内存..."
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

if [ "$EUID" -ne 0 ]; then 
    echo "请使用 root 用户运行此脚本"
    exit 1
fi

cd /root

echo "开始安装 Anaconda..."
wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh -O /root/anaconda_installer.sh
bash /root/anaconda_installer.sh -b -p /root/anaconda3
echo 'export PATH="/root/anaconda3/bin:$PATH"' >> /root/.bashrc
source /root/.bashrc
/root/anaconda3/bin/conda --version

echo "开始安装 PM2..."
apt update
apt install -y nodejs npm
npm install -g pm2
pm2 --version

echo "创建 Python 3.11 的 Alpha 环境..."
cd /root/anaconda3
source /root/anaconda3/bin/activate
/root/anaconda3/bin/conda create -n Alpha python=3.11 -y
/root/anaconda3/bin/conda activate Alpha
python --version

echo "安装 xbx-py11 库..."
pip install xbx-py11

echo "安装谷歌..."
apt update && apt upgrade -y
cd /root
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
apt --fix-broken install -y
google-chrome --version

echo "Anaconda、PM2、谷歌和 Python 环境安装完成，且安装了 xbx-py11 库。"

rm -f /root/anaconda_installer.sh
rm -f /root/google-chrome-stable_current_amd64.deb

exec $SHELL
exit 