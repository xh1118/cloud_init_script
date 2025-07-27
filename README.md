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
安装完成后，登录 ubuntu 用户，激活虚拟环境 Alpha 并使用 pip：
```bash
source ~/.bashrc
pyenv activate Alpha
pip list
```



## 腾讯云 PM2 一键部署与日志轮换自动化：

该脚本会自动生成 startup.json，启动所有 PM2 应用，并配置日志轮换、开机自启等。

**⚠️ 重要更新：** 脚本已修复 Python 解释器路径问题，现在使用正确的 pyenv 环境路径 `/home/ubuntu/.pyenv/versions/Alpha/bin/python`。

使用方法：
```bash
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/tencent_pyenv_startup_pm2.sh | bash
```

脚本功能：
- 自动生成 PM2 启动配置 startup.json
- 启动所有 Python 应用（startup.py、monitor.py、delist.py）
- 使用正确的 pyenv Python 解释器路径
- 配置 pm2-logrotate 日志轮换（最大100M，保留30份，压缩，定时轮换）
- 查看应用状态和日志
- 保存 PM2 配置并设置开机自启

**前置条件：**
- 确保已安装 pyenv 并创建了 Alpha 虚拟环境
- 确保项目代码位于 `/home/ubuntu/git/position-mgmt-trading/` 目录



## curl 的常见用法

### 1. 下载并执行 GitHub 上的 shell 脚本

比如你要在云服务器上一键运行你上传到 GitHub 的 `setup_pm2.sh` 脚本，可以这样：

```bash
curl -sSL https://raw.githubusercontent.com/你的用户名/你的仓库名/分支名/路径/setup_pm2.sh | bash
```

**举例：**
```bash
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/pyenv_pmt_all/setup_pm2.sh | bash
```

- `-sSL` 参数让 curl 静默、跟随重定向、显示错误。
- `| bash` 表示下载后直接交给 bash 执行。

---

### 2. 只下载文件，不执行

```bash
curl -O https://raw.githubusercontent.com/xh1118/cloud_init_script/main/tencent_pyenv_startup_pm2.sh
```
- `-O` 表示保存为本地同名文件。

---

### 3. 下载后手动赋权并执行

```bash
curl -O https://raw.githubusercontent.com/xh1118/cloud_init_script/main/pyenv_pmt_all/setup_pm2.sh
chmod +x setup_pm2.sh
./setup_pm2.sh
```

---

## 总结

- `curl` 可以让你**无需 git clone，直接从 GitHub 下载并运行脚本**，非常适合自动化部署。
- 只需把你的脚本 push 到 GitHub，然后用 curl 命令在服务器上一键执行即可。

---

如需帮你生成 curl 命令或有其他自动化需求，欢迎随时提问！


