FROM ghost:6-alpine

USER root

# 安装腾讯云 COS 存储适配器
# ghost-cos-store 由 tencentyun 官方维护
# 安装到 content.orig，Ghost entrypoint 首次启动时会自动复制到 content/
# 这样挂载 Volume 后适配器不会丢失
RUN mkdir -p /tmp/adapter && \
    cd /tmp/adapter && \
    npm install ghost-cos-store --no-save && \
    mkdir -p /var/lib/ghost/content.orig/adapters/storage/ghost-cos-store && \
    cp -r /tmp/adapter/node_modules/ghost-cos-store/. \
          /var/lib/ghost/content.orig/adapters/storage/ghost-cos-store/ && \
    cd /var/lib/ghost/content.orig/adapters/storage/ghost-cos-store && \
    npm install --production && \
    rm -rf /tmp/adapter

USER node

WORKDIR /var/lib/ghost
