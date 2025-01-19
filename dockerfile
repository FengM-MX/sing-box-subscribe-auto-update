FROM python:3.11-slim
# 设置用户
ENV USER_ID=1000
ENV GROUP_ID=1000

# 确保用户权限并拉取代码
RUN \
    mkdir -m 777 /tmp/sing-box-subscribe /sing-box-subscribe && \
    apt update && \
    apt install -y git gosu && \
    git clone https://github.com/Toperlock/sing-box-subscribe.git /tmp/sing-box-subscribe && \
    sed 's/"exclude_protocol":"ssr"/"exclude_protocol":""/g' /tmp/sing-box-subscribe/providers.json 

# 切换用户

COPY ./start.sh /root/start.sh

WORKDIR /sing-box-subscribe

# 安装依赖
RUN \
    chmod +x /root/start.sh && \
    cd /tmp/sing-box-subscribe && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt


EXPOSE 5000
ENTRYPOINT ["/root/start.sh"]
