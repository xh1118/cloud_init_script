# 云服务器自动化环境部署

## 快速安装

### Anaconda 环境（推荐）
```bash
# 安装环境
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/conda_install.sh | bash

# 配置 PM2
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/anaconda_pm2_json.sh | bash
```

### pyenv 环境
```bash
# 安装环境
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/pyenv_install.sh | bash

# 配置 PM2
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/pyenv_pm2_json.sh | bash
```

## 安装内容

- ✅ Python 3.11 + Alpha 虚拟环境
- ✅ PM2 进程管理器
- ✅ Google Chrome
- ✅ xbx-py11 库
- ✅ 4GB 虚拟内存

## 常用命令

```bash
# 查看应用状态
pm2 status

# 查看日志
pm2 logs

# 重启应用
pm2 restart all
```

## 环境激活

**Anaconda:**
```bash
conda activate Alpha
```

**pyenv:**
```bash
source ~/.bashrc
pyenv activate Alpha
```
```

这样简洁多了，只保留最核心的信息！