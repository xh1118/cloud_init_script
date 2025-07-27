#!/bin/bash

echo "=== 清理旧的 pyenv 环境 ==="

# 停止所有 PM2 应用
echo "停止所有 PM2 应用..."
pm2 delete all 2>/dev/null || true
pm2 kill 2>/dev/null || true

# 清理 pyenv 相关文件
echo "清理 pyenv 文件..."
rm -rf /home/ubuntu/.pyenv
rm -rf /home/ubuntu/.pyenv_root

# 清理 .bashrc 中的 pyenv 相关配置
echo "清理 .bashrc 配置..."
sed -i '/pyenv/d' /home/ubuntu/.bashrc
sed -i '/PYENV_ROOT/d' /home/ubuntu/.bashrc

# 清理 Python 进程
echo "清理 Python 进程..."
pkill -f "startup.py|monitor.py|delist.py" 2>/dev/null || true

# 清理日志文件
echo "清理日志文件..."
rm -rf /home/ubuntu/logs/pmt-*.log 2>/dev/null || true
rm -rf /home/ubuntu/.pm2/logs/pmt-*.log 2>/dev/null || true

echo "=== 清理完成 ==="
echo ""
echo "现在重新安装 pyenv 环境..."
echo "运行以下命令："
echo "curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/tencent_pyenv_install.sh | sudo bash"
echo ""
echo "安装完成后，运行以下命令启动应用："
echo "curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/tencent_pyenv_startup_pm2.sh | bash" 