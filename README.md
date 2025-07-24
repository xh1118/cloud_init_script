# cloud_init_script

本仓库用于自动化云服务器的环境部署，包含以下脚本：

- `aliyun_anaconda_install.sh`：阿里云 Anaconda 环境一键安装脚本
- `aliyun_pyenv_install.sh`：阿里云 pyenv 环境一键安装脚本
- `tencent_anaconda_install.sh`：腾讯云 Anaconda 环境一键安装脚本
- `tencent_pyenv_install.sh`：腾讯云 pyenv 环境一键安装脚本

## 使用方法

**推荐用法（适用于所有云服务器）：**

阿里云 Anaconda 环境一键安装：
```bash
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/aliyun_anaconda_install.sh | sudo bash
```

阿里云 pyenv 环境一键安装：
```bash
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/aliyun_pyenv_install.sh | sudo bash
```

腾讯云 Anaconda 环境一键安装：
```bash
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/tencent_anaconda_install.sh | sudo bash
```

腾讯云 pyenv 环境一键安装：
```bash

# ✅ 安装 curl（如未安装）并执行后续所有内容
sudo apt update && sudo apt install -y curl && \
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/tencent_pyenv_install.sh | sudo bash


```

--- 