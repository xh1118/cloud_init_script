#!/bin/bash
echo "请选择要执行的脚本："
select script in aliyun_anaconda_install.sh aliyun_pyenv_install.sh tencent_anaconda_install.sh tencent_pyenv_install.sh; do
  if [ -n "$script" ]; then
    echo "正在执行 $script ..."
    bash <(curl -sSL https://raw.githubusercontent.com/xh1118/cloud_init_script/main/$script)
    break
  else
    echo "无效选择，请重新输入数字。"
  fi
done 