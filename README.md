# cloud_init_script

本仓库用于自动化云服务器的环境部署，包含以下脚本：

- `aliyun_anaconda_install.sh`：阿里云 Anaconda 环境一键安装脚本
- `aliyun_pyenv_install.sh`：阿里云 pyenv 环境一键安装脚本
- `tencent_anaconda_install.sh`：腾讯云 Anaconda 环境一键安装脚本
- `tencent_pyenv_install.sh`：腾讯云 pyenv 环境一键安装脚本

## 使用方法

在云服务器上任选其一，执行如下命令即可（以 aliyun_anaconda_install.sh 为例）：

```bash
bash <(curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/aliyun_anaconda_install.sh)
```

### 一键选择脚本

你也可以直接运行 `run.sh`，根据提示选择要执行的脚本：

```bash
bash <(curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/run.sh)
```

--- 