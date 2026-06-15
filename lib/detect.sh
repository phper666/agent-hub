#!/usr/bin/env bash
# ============================================================
#  平台检测模块
# ============================================================

# 平台元数据（关联数组，O(1) 查找）
declare -A PLATFORM_GLOBAL_PATH
declare -A PLATFORM_PROJECT_PATH

# Reasonix
PLATFORM_GLOBAL_PATH[reasonix]="$HOME/Library/Application Support/reasonix/skills"
PLATFORM_PROJECT_PATH[reasonix]=".reasonix/skills"

# Qoder
PLATFORM_GLOBAL_PATH[qoder]="$HOME/.qoder/skills"
PLATFORM_PROJECT_PATH[qoder]=".qoder/skills"

# Claude
PLATFORM_GLOBAL_PATH[claude]="$HOME/.claude/skills"
PLATFORM_PROJECT_PATH[claude]=".claude/skills"

# Cursor
PLATFORM_GLOBAL_PATH[cursor]="$HOME/.cursor/skills"
PLATFORM_PROJECT_PATH[cursor]=".cursor/skills"

# WorkBuddy
PLATFORM_GLOBAL_PATH[workbuddy]="$HOME/.workbuddy/skills"
PLATFORM_PROJECT_PATH[workbuddy]=".workbuddy/skills"

# Codex
PLATFORM_GLOBAL_PATH[codex]="$HOME/.codex/skills"
PLATFORM_PROJECT_PATH[codex]=".codex/skills"

# Gemini
PLATFORM_GLOBAL_PATH[gemini]="$HOME/.gemini/skills"
PLATFORM_PROJECT_PATH[gemini]=".gemini/skills"

# 所有已知平台列表
KNOWN_PLATFORMS=(reasonix qoder claude cursor workbuddy codex gemini)

# 检测单个平台是否安装
detect_platform() {
  local name="$1"
  local global_path="${PLATFORM_GLOBAL_PATH[$name]}"

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

  for name in "${KNOWN_PLATFORMS[@]}"; do
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

# 获取平台的全局安装路径 (O(1))
get_platform_global_path() {
  echo "${PLATFORM_GLOBAL_PATH[$1]}"
}

# 获取平台的项目安装路径 (O(1))
get_platform_project_path() {
  echo "${PLATFORM_PROJECT_PATH[$1]}"
}
