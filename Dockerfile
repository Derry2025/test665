FROM alpine:latest

# 安装必要工具：sing-box, cloudflared, curl, jq
RUN apk add --no-cache curl wget ca-certificates bash

# 下载并安装 sing-box
RUN wget -O /tmp/sing-box.tar.gz https://github.com/SagerNet/sing-box/releases/download/v1.8.11/sing-box-1.8.11-linux-amd64.tar.gz && \
    tar -zxvf /tmp/sing-box.tar.gz -C /tmp && \
    cp /tmp/sing-box-*/sing-box /usr/local/bin/ && \
    rm -rf /tmp/*

# 下载并安装 cloudflared (Argo Tunnel)
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# 复制配置文件和启动脚本
COPY config.json /etc/sing-box/config.json
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Railway 默认端口
EXPOSE 8080

ENTRYPOINT ["/bin/bash", "/start.sh"]
