#!/usr/bin/env bash
# ============================================================
#  平台检测模块
# ============================================================

# 平台定义：名称|检测方式|全局安装路径|项目安装路径
PLATFORM_DEFS=(
  "reasonix|dir|$HOME/Library/Application Support/reasonix/skills|.reasonix/skills"
  "qoder|dir|$HOME/.qoder/skills|.qoder/skills"
  "claude|dir|$HOME/.claude/skills|.claude/skills"
  "cursor|dir|$HOME/.cursor/skills|.cursor/skills"
  "workbuddy|dir|$HOME/.workbuddy/skills|.workbuddy/skills"
  "codex|dir|$HOME/.codex/skills|.codex/skills"
  "gemini|dir|$HOME/.gemini/skills|.gemini/skills"
)

# 解析路径中的转义空格（兼容带空格的路径如 ~/Library/Application Support/...）
_resolve_path() {
  echo "${1//\\ / }"
}

# 检测单个平台是否安装
detect_platform() {
  local name="$1"
  local check_type="$2"
  local raw_path="$3"

  case "$check_type" in
    dir)
      local global_path
      global_path="$(_resolve_path "$raw_path")"
      # 检查全局技能目录本身或其父目录是否存在
      if [ -d "$global_path" ] || [ -d "$(dirname "$global_path")" ]; then
        return 0
      fi
      ;;
    cmd)
      if command -v "$name" &>/dev/null; then
        return 0
      fi
      ;;
  esac
  return 1
}

# 检测所有平台
cmd_detect() {
  echo ""
  echo -e "${CYAN}🔍 检测已安装的 Agent 平台${NC}"
  echo ""

  local found=0
  local detected_list=""

  for def in "${PLATFORM_DEFS[@]}"; do
    IFS='|' read -r name check_type global_path project_path <<< "$def"

    if detect_platform "$name" "$check_type" "$global_path"; then
      ok "$name"
      found=$((found + 1))
      detected_list="${detected_list:+$detected_list,}$name"
    else
      echo -e "  ${RED}✗${NC} $name (未安装)"
    fi
  done

  echo ""
  if [ "$found" -gt 0 ]; then
    ok "检测到 $found 个平台: $detected_list"
  else
    warn "未检测到任何 Agent 平台"
  fi

  # 保存检测结果到 agent-hub 安装目录
  echo "$detected_list" > "$AGENT_HUB_DIR/.agent-hub-detected"
  info "检测结果已保存"

  echo ""
}

# 获取已检测的平台列表
get_detected_platforms() {
  if [ -f "$AGENT_HUB_DIR/.agent-hub-detected" ]; then
    cat "$AGENT_HUB_DIR/.agent-hub-detected" | tr -d '[:space:]'
  else
    echo ""
  fi
}

# 获取平台的全局安装路径
get_platform_global_path() {
  local target="$1"
  for def in "${PLATFORM_DEFS[@]}"; do
    IFS='|' read -r name check_type global_path project_path <<< "$def"
    if [ "$name" = "$target" ]; then
      echo "$global_path"
      return 0
    fi
  done
  return 1
}

# 获取平台的项目安装路径
get_platform_project_path() {
  local target="$1"
  for def in "${PLATFORM_DEFS[@]}"; do
    IFS='|' read -r name check_type global_path project_path <<< "$def"
    if [ "$name" = "$target" ]; then
      echo "$project_path"
      return 0
    fi
  done
  return 1
}
