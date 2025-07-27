#!/bin/bash

echo "=== 清理旧的 pyenv 环境 ==="

# 检查是否为 root 用户
if [ "$EUID" -eq 0 ]; then 
    echo "❌ 请不要使用 root 用户运行此脚本"
    echo "请切换到 ubuntu 用户后运行"
    exit 1
fi

# 停止所有 PM2 应用
echo "停止所有 PM2 应用..."
pm2 delete all 2>/dev/null || true
pm2 kill 2>/dev/null || true

# 清理 swap 文件（解决 'Text file busy' 问题）
echo "清理 swap 文件..."
sudo swapoff -a 2>/dev/null || true
sudo rm -f /home/ubuntu/swapfile 2>/dev/null || true
sudo sed -i '/swapfile/d' /etc/fstab 2>/dev/null || true

# 强制清理 pyenv 相关文件（解决权限问题）
echo "强制清理 pyenv 文件..."
sudo rm -rf /home/ubuntu/.pyenv 2>/dev/null || true
sudo rm -rf /home/ubuntu/.pyenv_root 2>/dev/null || true

# 清理 .bashrc 中的 pyenv 相关配置
echo "清理 .bashrc 配置..."
sed -i '/pyenv/d' /home/ubuntu/.bashrc 2>/dev/null || true
sed -i '/PYENV_ROOT/d' /home/ubuntu/.bashrc 2>/dev/null || true

# 清理 Python 进程
echo "清理 Python 进程..."
pkill -f "startup.py|monitor.py|delist.py" 2>/dev/null || true
pkill -f "python.*position-mgmt-trading" 2>/dev/null || true

# 清理日志文件
echo "清理日志文件..."
rm -rf /home/ubuntu/logs/pmt-*.log 2>/dev/null || true
rm -rf /home/ubuntu/.pm2/logs/pmt-*.log 2>/dev/null || true
rm -rf /home/ubuntu/.pm2/pids/* 2>/dev/null || true

# 清理可能的残留进程
echo "清理残留进程..."
sudo pkill -f "pyenv" 2>/dev/null || true
sudo pkill -f "python.*Alpha" 2>/dev/null || true

# 重置环境变量
echo "重置环境变量..."
unset PYENV_ROOT
unset PYENV_VERSION
unset PYENV_SHELL

echo "=== 清理完成 ==="
echo ""
echo "✅ 所有旧环境已清理完成"
echo ""
echo "📋 下一步操作："
echo "1. 重新安装 pyenv 环境："
echo "   curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/tencent_pyenv_install.sh | sudo bash"
echo ""
echo "2. 重新加载环境变量："
echo "   source ~/.bashrc"
echo ""
echo "3. 验证安装："
echo "   pyenv --version"
echo ""
echo "4. 激活 Alpha 环境："
echo "   pyenv activate Alpha"
echo ""
echo "5. 启动 PM2 应用："
echo "   curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/tencent_pyenv_startup_pm2.sh | bash"
echo ""
echo "🔧 如果遇到问题，请检查："
echo "- 确保使用 ubuntu 用户运行安装脚本"
echo "- 确保网络连接正常"
echo "- 确保有足够的磁盘空间" 