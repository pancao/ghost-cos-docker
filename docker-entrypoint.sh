#!/bin/sh
set -e

# 每次启动时强制将适配器从固定路径同步到 content 目录
# 这样即使 Volume 覆盖了 content，适配器也不会丢失
ADAPTER_SRC="/var/lib/ghost-adapters/ghost-cos-store"
ADAPTER_DST="/var/lib/ghost/content/adapters/storage/ghost-cos-store"

if [ -d "$ADAPTER_SRC" ]; then
    mkdir -p "$(dirname "$ADAPTER_DST")"
    rm -rf "$ADAPTER_DST"
    cp -r "$ADAPTER_SRC" "$ADAPTER_DST"
fi

# 执行官方 Ghost entrypoint
exec docker-entrypoint.sh "$@"
