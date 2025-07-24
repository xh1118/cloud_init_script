# cloud_init_script

本仓库用于自动化云服务器的环境部署，包含以下脚本：

- `aliyun_anaconda_install.sh`：阿里云 Anaconda 环境一键安装脚本
- `aliyun_pyenv_install.sh`：阿里云 pyenv 环境一键安装脚本
- `tencent_anaconda_install.sh`：腾讯云 Anaconda 环境一键安装脚本
- `tencent_pyenv_install.sh`：腾讯云 pyenv 环境一键安装脚本

## 使用方法

**推荐用法（避免 /dev/fd/63 报错，适用于所有云服务器）：**

以 aliyun_anaconda_install.sh 为例：

```bash
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/aliyun_anaconda_install.sh | sudo bash
```

以 tencent_pyenv_install.sh 为例：

```bash
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/tencent_pyenv_install.sh | sudo bash
```

### 一键选择脚本

你也可以直接运行 `run.sh`，根据提示选择要执行的脚本：

```bash
curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/run.sh | sudo bash
```

--- 