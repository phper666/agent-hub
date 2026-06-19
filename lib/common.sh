#!/usr/bin/env bash
# ============================================================
#  公共函数库
# ============================================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Agent Hub 内置角色列表（所有版本的合集）
KNOWN_BUILTIN_ROLES="architect backend delivery-director designer frontend pm qa router"

# 日志函数
info()  { echo -e "${BLUE}ℹ️  $1${NC}"; }
ok()    { echo -e "${GREEN}✅ $1${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $1${NC}"; }
fail()  { echo -e "${RED}❌ $1${NC}"; exit 1; }

# 获取脚本所在目录
get_script_dir() {
  local source="${BASH_SOURCE[1]}"
  while [ -L "$source" ]; do
    local dir
    dir="$(cd -P "$(dirname "$source")" && pwd)"
    source="$(readlink "$source")"
    [[ $source != /* ]] && source="$dir/$source"
  done
  cd -P "$(dirname "$source")" && pwd
}

# 检查命令是否存在
command_exists() {
  command -v "$1" &> /dev/null
}

# 检查目录是否存在且非空
dir_has_content() {
  local dir="$1"
  [ -d "$dir" ] && [ -n "$(ls -A "$dir" 2>/dev/null)" ]
}

# 安全复制目录
safe_copy_dir() {
  local src="$1"
  local dst="$2"
  if dir_has_content "$src"; then
    mkdir -p "$dst" 2>/dev/null || true
    cp -r "$src/"* "$dst/" 2>/dev/null || true
  fi
}

# 确认操作
confirm_action() {
  local message="${1:-确认执行此操作？}"
  read -p "$message (y/N): " -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]]
}

# 检查文件是否存在，不存在则创建
ensure_file() {
  local file="$1"
  local content="${2:-}"
  if [ ! -f "$file" ]; then
    mkdir -p "$(dirname "$file")" 2>/dev/null
    echo "$content" > "$file"
  fi
}

# 读取 VERSION 文件
get_version() {
  local script_dir="${1:-$AGENT_HUB_DIR}"
  cat "$script_dir/VERSION" 2>/dev/null | tr -d '[:space:]' || echo "unknown"
}

# 判断目录是否为 agent-hub 安装的角色
# 检查 marker 文件或 .shared/ 子目录
is_agent_hub_role() {
  local dir="$1"
  [ -f "$dir/.agent-hub-installed" ] && return 0
  [ -d "$dir/.shared" ] && return 0
  return 1
}

# 列出指定目录下所有 agent-hub 安装的角色子目录
list_agent_hub_roles_in() {
  local skills_dir="$1"
  if [ ! -d "$skills_dir" ]; then
    return
  fi
  for subdir in "$skills_dir"/*/; do
    [ -d "$subdir" ] || continue
    local name="$(basename "$subdir")"
    if is_agent_hub_role "$subdir"; then
      echo "$name"
    fi
  done
}
