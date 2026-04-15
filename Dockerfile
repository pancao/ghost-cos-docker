FROM ghost:6-alpine

USER root

# 安装腾讯云 COS 存储适配器到固定路径（Volume 之外）
RUN mkdir -p /tmp/adapter && \
    cd /tmp/adapter && \
    npm install ghost-cos-store --no-save && \
    mkdir -p /var/lib/ghost-adapters/ghost-cos-store && \
    cp -r /tmp/adapter/node_modules/ghost-cos-store/. \
          /var/lib/ghost-adapters/ghost-cos-store/ && \
    cd /var/lib/ghost-adapters/ghost-cos-store && \
    npm install --production && \
    rm -rf /tmp/adapter

# 替换补丁版 index.js（修复自定义域名支持）
COPY patches/ghost-cos-store-index.js \
     /var/lib/ghost-adapters/ghost-cos-store/index.js

# 自定义 entrypoint：每次启动时将适配器同步到 content 目录
COPY docker-entrypoint.sh /usr/local/bin/custom-entrypoint.sh
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

USER node

WORKDIR /var/lib/ghost

ENTRYPOINT ["custom-entrypoint.sh"]
CMD ["node", "current/index.js"]
