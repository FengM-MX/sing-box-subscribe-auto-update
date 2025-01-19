#!/bin/bash
# 如果指定了 USER_ID，则创建用户
if ! id -u $USER_ID > /dev/null 2>&1; then
    groupadd -g $GROUP_ID subscribe
    useradd -u $USER_ID -g subscribe -s /bin/bash -m subscribe
fi

# 取消git filemode模式
echo "disable git filemode..."
git config --global core.filemode false

echo "copy the program from /tmp/sing-box-subscribe to /sing-box-subscribe"
# 文件不存在，则移动程序文件
if [ ! -d "/sing-box-subscribe" ];then
    echo "create dest dir..."
    mkdir /sing-box-subscribe
fi
if [ ! -f "/sing-box-subscribe/api/app.py" ];then
   echo "copy files to dest dir..."
   #find /tmp/sing-box-subscribe -mindepth 1 -maxdepth 1 -exec cp -rfv {} /sing-box-subscribe/ \;
   shopt -s dotglob
   cp -rfv /tmp/sing-box-subscribe /
   #cp -rf /tmp/sing-box-subscribe/.git /sing-box-subscribe/
   #cp -rf /tmp/sing-box-subscribe/.github /sing-box-subscribe/
   #cp -rf /tmp/sing-box-subscribe/.gitignore /sing-box-subscribe/
fi
echo "grant permissions..."
chown -R $USER_ID:$GROUP_ID /sing-box-subscribe
# 拉取最新代码
echo "start pulling the latest code"
gosu $USER_ID bash -c 'cd /sing-box-subscribe && \
    git config core.filemode false && \
    git stash save && \
    git pull --rebase && \
    git stash pop && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt'

# 启动项目
echo "Starting application..."
gosu $USER_ID bash -c "python /sing-box-subscribe/api/app.py"
