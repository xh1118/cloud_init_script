# 云服务器自动化环境部署

## 1.Anaconda

#### 1.1 Anaconda 环境
```bash
# 安装环境
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/conda_ubuntu_install.sh | bash
```

#### 1.2 数据中心应用
```bash
# 自动化部署 datacenter 应用
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/conda_datacenter_auto.sh | bash
```

#### 1.3 实盘pm2部署
```bash
# 配置 PM2
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/conda_pm2_json.sh | bash
```
## 2.pyenv
#### 2.1 pyenv 环境
```bash
# 安装环境
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/pyenv_ubuntu_install.sh | bash
```
#### 2.2 数据中心应用
```bash
# 自动化部署 datacenter 应用
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/pyenv_datacenter_auto.sh | bash
```

#### 2.3 实盘pm2部署
```bash
# 配置 PM2
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/pyenv_pm2_json.sh | bash
```



## 安装内容

- ✅ Python 3.11 + Alpha 虚拟环境
- ✅ PM2 进程管理器
- ✅ Google Chrome
- ✅ xbx-py11 库
- ✅ 中文字体（解决乱码）

## 环境路径

### Anaconda
```bash
# Python 解释器
$HOME/anaconda3/envs/Alpha/bin/python

# 激活环境
conda activate Alpha
```

### pyenv
```bash
# Python 解释器
$HOME/.pyenv/versions/3.11.11/envs/Alpha/bin/python

# 激活环境
source ~/.bashrc
pyenv activate Alpha
```

## 常用命令

```bash
# 查看应用状态
pm2 status

# 查看日志
pm2 logs

# 重启应用
pm2 restart all
```
```

现在包含了所有三个主要脚本：环境安装、PM2配置和datacenter应用部署！