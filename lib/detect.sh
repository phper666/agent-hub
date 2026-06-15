#!/usr/bin/env bash
# ============================================================
#  平台检测模块（兼容 Bash 3.x+）
# ============================================================

# 所有已知平台列表
KNOWN_PLATFORMS="reasonix qoder claude cursor workbuddy codex gemini opencode"

# 获取平台的全局安装路径
get_platform_global_path() {
  local name="$1"
  case "$name" in
    reasonix)  echo "$HOME/Library/Application Support/reasonix/skills" ;;
    qoder)     echo "$HOME/.qoder/skills" ;;
    claude)    echo "$HOME/.claude/skills" ;;
    cursor)    echo "$HOME/.cursor/skills" ;;
    workbuddy) echo "$HOME/.workbuddy/skills" ;;
    codex)     echo "$HOME/.codex/skills" ;;
    gemini)    echo "$HOME/.gemini/skills" ;;
    opencode)  echo "$HOME/.config/opencode/skills" ;;
    *)         echo "" ;;
  esac
}

# 获取平台的项目安装路径
get_platform_project_path() {
  local name="$1"
  case "$name" in
    reasonix)  echo ".reasonix/skills" ;;
    qoder)     echo ".qoder/skills" ;;
    claude)    echo ".claude/skills" ;;
    cursor)    echo ".cursor/skills" ;;
    workbuddy) echo ".workbuddy/skills" ;;
    codex)     echo ".codex/skills" ;;
    gemini)    echo ".gemini/skills" ;;
    opencode)  echo ".opencode/skills" ;;
    *)         echo "" ;;
  esac
}

# 检测单个平台是否安装
detect_platform() {
  local name="$1"
  local global_path
  global_path="$(get_platform_global_path "$name")"

  if [ -n "$global_path" ]; then
    # 目录检测：检查全局技能目录本身或其父目录是否存在
    if [ -d "$global_path" ] || [ -d "$(dirname "$global_path")" ]; then
      return 0
    fi
  fi
  return 1
}

# 检测所有平台
cmd_detect() {
  echo ""
  echo -e "${CYAN}🔍 检测已安装的 Agent 平台${NC}"
  echo ""

  local found=0
  local detected_list=""

  for name in $KNOWN_PLATFORMS; do
    if detect_platform "$name"; then
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
