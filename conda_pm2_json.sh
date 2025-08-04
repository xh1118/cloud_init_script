#!/bin/bash

# 1. 设置环境变量
export PATH="$HOME/anaconda3/bin:$PATH"

# 停止所有应用
pm2 delete all

# 重新创建配置文件
cat > startup.json <<EOF
{
    "apps": [
        {
            "name": "pmt-startup",
            "script": "$HOME/git/position-mgmt-trading/startup.py",
            "interpreter": "$HOME/anaconda3/envs/Alpha/bin/python",
            "cwd": "$HOME/git/position-mgmt-trading",
            "merge_logs": false,
            "watch": false,
            "error_file": "$HOME/logs/pmt-startup.error.log",
            "out_file": "$HOME/logs/pmt-startup.out.log",
            "autorestart": true,
            "max_memory_restart": "1G"
        },
        {
            "name": "pmt-monitor",
            "script": "$HOME/git/position-mgmt-trading/monitor.py",
            "interpreter": "$HOME/anaconda3/envs/Alpha/bin/python",
            "cwd": "$HOME/git/position-mgmt-trading",
            "merge_logs": false,
            "watch": false,
            "error_file": "$HOME/logs/pmt-monitor.error.log",
            "out_file": "$HOME/logs/pmt-monitor.out.log",
            "autorestart": true,
            "max_memory_restart": "1G"
        },
        {
            "name": "pmt-delist",
            "script": "$HOME/git/position-mgmt-trading/delist.py",
            "interpreter": "$HOME/anaconda3/envs/Alpha/bin/python",
            "cwd": "$HOME/git/position-mgmt-trading",
            "merge_logs": false,
            "watch": false,
            "error_file": "$HOME/logs/pmt-delist.error.log",
            "out_file": "$HOME/logs/pmt-delist.out.log",
            "autorestart": true,
            "max_memory_restart": "1G"
        }
    ]
}
EOF

# 重新启动
pm2 start startup.json

# 4. 安装并配置 pm2-logrotate
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 100M
pm2 set pm2-logrotate:retain 30
pm2 set pm2-logrotate:compress true
pm2 set pm2-logrotate:rotateInterval '37 3 * * *'

# 5. 查看当前日志轮换配置
pm2 conf pm2-logrotate

# 6. 查看应用状态和日志
pm2 status
pm2 logs

# 7. 保存 PM2 配置并设置开机自启
pm2 save
pm2 startup 