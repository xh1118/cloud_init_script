#!/bin/bash

# 1. 设置环境变量
export PATH="/home/ubuntu/anaconda3/bin:$PATH"

# 2. 生成 startup.json 文件
cat > startup.json <<EOF
{
    "apps": [
        {
            "name": "pmt-startup",
            "script": "/home/ubuntu/git/position-mgmt-trading/startup.py",
            "exec_interpreter": "/home/ubuntu/anaconda3/envs/Alpha/bin/python",
            "merge_logs": false,
            "watch": false,
            "error_file": "/home/ubuntu/logs/pmt-startup.error.log",
            "out_file": "/home/ubuntu/logs/pmt-startup.out.log",
            "autorestart": true,
            "max_memory_restart": "1G"
        },
        {
            "name": "pmt-monitor",
            "script": "/home/ubuntu/git/position-mgmt-trading/monitor.py",
            "exec_interpreter": "/home/ubuntu/anaconda3/envs/Alpha/bin/python",
            "merge_logs": false,
            "watch": false,
            "error_file": "/home/ubuntu/logs/pmt-monitor.error.log",
            "out_file": "/home/ubuntu/logs/pmt-monitor.out.log",
            "autorestart": true,
            "max_memory_restart": "1G"
        },
        {
            "name": "pmt-delist",
            "script": "/home/ubuntu/git/position-mgmt-trading/delist.py",
            "exec_interpreter": "/home/ubuntu/anaconda3/envs/Alpha/bin/python",
            "merge_logs": false,
            "watch": false,
            "error_file": "/home/ubuntu/logs/pmt-delist.error.log",
            "out_file": "/home/ubuntu/logs/pmt-delist.out.log",
            "autorestart": true,
            "max_memory_restart": "1G"
        }
    ]
}
EOF

# 3. 启动应用
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