#!/bin/bash

# 1. 下载启动脚本
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/start_python_apps.sh -o /home/ubuntu/start_python_apps.sh
chmod +x /home/ubuntu/start_python_apps.sh

# 2. 生成 startup.json 文件
cat > startup.json <<EOF
{
    "apps": [
        {
            "name": "pmt-all-apps",
            "script": "/home/ubuntu/start_python_apps.sh",
            "merge_logs": false,
            "watch": false,
            "error_file": "/home/ubuntu/logs/pmt-all-apps.error.log",
            "out_file": "/home/ubuntu/logs/pmt-all-apps.out.log",
            "autorestart": true,
            "max_memory_restart": "2G"
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