#!/bin/bash

# 设置 Python 解释器路径
PYTHON_PATH="/home/ubuntu/.pyenv/versions/Alpha/bin/python"

# 启动 startup.py
echo "Starting startup.py..."
$PYTHON_PATH /home/ubuntu/git/position-mgmt-trading/startup.py &

# 启动 monitor.py
echo "Starting monitor.py..."
$PYTHON_PATH /home/ubuntu/git/position-mgmt-trading/monitor.py &

# 启动 delist.py
echo "Starting delist.py..."
$PYTHON_PATH /home/ubuntu/git/position-mgmt-trading/delist.py &

# 等待所有进程
wait 