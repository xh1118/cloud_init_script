#!/bin/bash

# 下载 datacenter.json
wget -O datacenter.json https://raw.githubusercontent.com/xh1118/cloud_init_script/main/pyenv_datacenter.json

# 创建目录（只需要datacenter目录）
mkdir -p $HOME/json

# 复制到指定路径
cp datacenter.json $HOME/json/pyenv_datacenter.json

# 启动PM2（logs目录会自动创建）
pm2 start $HOME/json/pyenv_datacenter.json

# 保存配置
pm2 save 