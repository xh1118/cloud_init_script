#!/bin/bash

# 确认是否需要创建目录
if [ -d "$HOME/json" ]; then
    echo "json目录已存在，跳过创建"
else
    echo "创建json目录..."
    mkdir -p $HOME/json
fi

# 直接下载到目标目录
wget -O $HOME/json/pyenv_datacenter.json https://raw.githubusercontent.com/xh1118/cloud_init_script/main/pyenv_datacenter.json

# 启动PM2（logs目录会自动创建）
pm2 start $HOME/json/pyenv_datacenter.json

# 保存配置
pm2 save