#!/usr/bin/env bash
# ============================================================
#  流水线模块
# ============================================================

# 角色产出文件 (可通过 role.yaml 覆盖)
declare -A ROLE_OUTPUTS
ROLE_OUTPUTS[pm]="docs/current/requirements/PRD.md"
ROLE_OUTPUTS[designer]="docs/current/design/component-spec.md"
ROLE_OUTPUTS[frontend]="src/frontend/"
ROLE_OUTPUTS[backend]="src/backend/"
ROLE_OUTPUTS[qa]="tests/"

# 角色 emoji (可通过 role.yaml 覆盖)
declare -A ROLE_EMOJI
ROLE_EMOJI[pm]="🤖"
ROLE_EMOJI[designer]="🎨"
ROLE_EMOJI[frontend]="💻"
ROLE_EMOJI[backend]="⚙️"
ROLE_EMOJI[qa]="🧪"

# 获取角色状态
get_role_status() {
  local role="$1"
  local status_file="docs/current/status.md"

  if [ ! -f "$status_file" ]; then
    echo "⏳ 待开始"
    return
  fi

  # 从 status.md 解析状态
  local line
  line="$(grep -i "$role" "$status_file" 2>/dev/null | head -1)"
  if [ -z "$line" ]; then
    echo "⏳ 待开始"
    return
  fi

  if echo "$line" | grep -q "✅"; then
    echo "✅ 完成"
  elif echo "$line" | grep -q "🔄"; then
    echo "🔄 进行中"
  else
    echo "⏳ 待开始"
  fi
}

# 获取角色显示名称
get_role_display_name() {
  local name="$1"
  # 从 SKILL.md frontmatter 提取，fallback 用目录名
  local skill_file="roles/$name/SKILL.md"
  if [ -f "$skill_file" ]; then
    local extracted
    extracted="$(grep "^description:" "$skill_file" 2>/dev/null | head -1 | sed 's/^description:[[:space:]]*//' | cut -d'.' -f1)"
    if [ -n "$extracted" ]; then
      echo "$extracted"
      return
    fi
  fi
  echo "$name"
}

# 管线状态
cmd_pipeline_status() {
  echo ""
  echo -e "${CYAN}📊 项目流水线状态${NC}"
  echo ""

  printf "  %-5s %-15s %-12s %-30s\n" "" "角色" "状态" "产出"
  printf "  %-5s %-15s %-12s %-30s\n" "───" "───────────────" "────────────" "──────────────────────────────"

  # 动态发现角色
  for role_dir in roles/*/; do
    [ -d "$role_dir" ] || continue
    local role
    role="$(basename "$role_dir")"
    local emoji="${ROLE_EMOJI[$role]:-❓}"
    local status
    status="$(get_role_status "$role")"
    local output="${ROLE_OUTPUTS[$role]:-}"

    # 检查产出文件是否存在
    if [ -n "$output" ] && [ -e "$output" ]; then
      output="$output ✓"
    fi

    local display_name
    display_name="$(get_role_display_name "$role")"

    printf "  %-5s %-15s %-12s %-30s\n" "$emoji" "$role" "$status" "$output"
  done

  echo ""
}

# 重置状态
cmd_pipeline_reset() {
  local status_file="docs/current/status.md"

  mkdir -p "$(dirname "$status_file")"

  # 动态生成表头
  {
    echo "# 项目状态"
    echo ""
    echo "| 角色 | 状态 | 更新时间 |"
    echo "|------|------|----------|"
    for role_dir in roles/*/; do
      [ -d "$role_dir" ] || continue
      local role
      role="$(basename "$role_dir")"
      # 首字母大写
      local capitalized
      capitalized="$(echo "$role" | sed 's/./\U&/')"
      echo "| $capitalized | ⏳ 待开始 | - |"
    done
  } > "$status_file"

  ok "状态已重置"
}

# 流水线主入口
cmd_pipeline() {
  local subcmd="${1:-status}"
  shift 2>/dev/null || true

  case "$subcmd" in
    status) cmd_pipeline_status "$@" ;;
    reset)  cmd_pipeline_reset "$@" ;;
    *)      fail "未知子命令: pipeline $subcmd" ;;
  esac
}
