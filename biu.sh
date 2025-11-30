#!/bin/bash

# ===================================================================
# Electron 资源路径重定向脚本 (使用 bwrap)
# 目标: 在不使用 root 权限和不修改 app.asar 的情况下，将硬编码的资源路径
#       /usr/lib/electron/resources 透明地重定向到 /usr/lib/biu
# ===================================================================

# --- 变量定义 ---

root_dir="__ROOT_DIR__"
app_asar="$root_dir/app.asar"
electron_bin="/usr/bin/__ELECTRON__"

# 应用程序硬编码查找的原始路径 (目标覆盖点)
# !!! 请替换此路径为你系统上正确的 Electron 资源目录 !!!
TARGET_RESOURCES_DIR="/usr/lib/__ELECTRON__/resources"

# 动态检测图形环境所需路径
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
USER_HOME="$HOME" # 捕获家目录路径

# --- 检查和准备 ---

if [ ! -f "$app_asar" ]; then
    echo "Error: app.asar not found under $root_dir"
    exit 1
fi

if ! command -v bwrap &> /dev/null; then
    echo "Error: 'bwrap' command not found."
    echo "请确保 Bubblewrap (bwrap) 已安装。"
    exit 1
fi

if [ ! -d "$TARGET_RESOURCES_DIR" ]; then
    echo "Error: Target resources directory not found at $TARGET_RESOURCES_DIR"
    exit 1
fi

# --- 运行应用程序于 bwrap 沙箱内 ---

echo "Starting Electron app inside bwrap sandbox with full environment bindings."
echo "Path Override: $TARGET_RESOURCES_DIR -> $root_dir"

# 1. 定义 BWRAP 参数数组
BWRAP_ARGS=(
    # 核心系统目录
    --dev /dev 
    --proc /proc 
    --tmpfs /tmp 
    --tmpfs /run 
    
    # 绑定宿主机的系统文件
    --bind /usr /usr
    --bind /etc /etc
    --bind /lib /lib
    --bind /lib64 /lib64
    --bind /bin /bin
    --bind /sbin /sbin

    # ！！！修正 1：绑定家目录 ！！！
    --bind "$USER_HOME" "$USER_HOME"

    # ！！！关键：路径重定向（解决你的原始问题）！！！
    --ro-bind "$root_dir" "$TARGET_RESOURCES_DIR"

    # 解决图形和通信错误
    --ro-bind /dev/dri /dev/dri             # 硬件驱动访问
    --ro-bind /tmp/.X11-unix /tmp/.X11-unix # X11 socket 绑定
    --ro-bind "$RUNTIME_DIR" "$RUNTIME_DIR" # D-Bus & Wayland Socket 访问
    
    # 解决字体、主题和配置问题
    --ro-bind /usr/share/fonts /usr/share/fonts
    --ro-bind /usr/share/themes /usr/share/themes
    --ro-bind /usr/share/icons /usr/share/icons
    
    # 绑定应用自身所需的文件
    --ro-bind "$root_dir" "$root_dir"
    --ro-bind "$electron_bin" "$electron_bin"

    # 设置环境变量
    --setenv APPIMAGE 1
    --setenv ELECTRON_FORCE_IS_PACKAGED true
    --setenv XDG_RUNTIME_DIR "$RUNTIME_DIR" # 确保沙箱内环境变量正确
    --setenv HOME "$USER_HOME"              # 确保沙箱内 HOME 变量正确

    # 实际执行的命令及其参数 (放在数组末尾)
    "$electron_bin" "$app_asar" --no-sandbox "$@"
)

# 2. 执行 bwrap 命令
bwrap "${BWRAP_ARGS[@]}"

echo "Script finished."
