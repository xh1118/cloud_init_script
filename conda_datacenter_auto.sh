#!/bin/bash

# 确认是否需要创建目录
if [ -d "$HOME/json" ]; then
    echo "json目录已存在，跳过创建"
else
    echo "创建json目录..."
    mkdir -p $HOME/json
fi

# 直接下载到目标目录
wget -O $HOME/json/conda_datacenter.json https://raw.githubusercontent.com/xh1118/cloud_init_script/main/conda_datacenter.json

# 启动PM2（logs目录会自动创建）
pm2 start $HOME/json/conda_datacenter.json

# 3. 安装并配置 pm2-logrotate
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 100M
pm2 set pm2-logrotate:retain 30
pm2 set pm2-logrotate:compress true
pm2 set pm2-logrotate:rotateInterval '37 3 * * *'

# 4. 查看当前日志轮换配置
pm2 conf pm2-logrotate

# 5. 查看应用状态和日志
pm2 status
pm2 logs

# 6. 保存 PM2 配置并设置开机自启
pm2 save
pm2 startup

# 保存配置
pm2 save 