#!/usr/bin/env bash
# ============================================================
#  流水线模块
# ============================================================

# 角色依赖关系（格式: role:dep1,dep2）
ROLE_DEPS_PM=""
ROLE_DEPS_DESIGNER="pm"
ROLE_DEPS_FRONTEND="designer"
ROLE_DEPS_BACKEND="designer"
ROLE_DEPS_QA="frontend backend"

# 角色产出文件
ROLE_OUTPUTS_PM="docs/current/requirements/PRD.md"
ROLE_OUTPUTS_DESIGNER="docs/current/design/component-spec.md"
ROLE_OUTPUTS_FRONTEND="src/frontend/"
ROLE_OUTPUTS_BACKEND="src/backend/"
ROLE_OUTPUTS_QA="tests/"

# 角色 emoji
ROLE_EMOJI_PM="🤖"
ROLE_EMOJI_DESIGNER="🎨"
ROLE_EMOJI_FRONTEND="💻"
ROLE_EMOJI_BACKEND="⚙️"
ROLE_EMOJI_QA="🧪"

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

# 管线状态
cmd_pipeline_status() {
  echo ""
  echo -e "${CYAN}📊 项目流水线状态${NC}"
  echo ""

  printf "  %-5s %-12s %-12s %-30s\n" "" "角色" "状态" "产出"
  printf "  %-5s %-12s %-12s %-30s\n" "───" "────────────" "────────────" "──────────────────────────────"

  for role in pm designer frontend backend qa; do
    local upper_role
    upper_role="$(echo "$role" | tr '[:lower:]' '[:upper:]' | tr '-' '_')"
    local emoji_var="ROLE_EMOJI_${upper_role}"
    local emoji="${!emoji_var:-❓}"
    local status
    status="$(get_role_status "$role")"
    local output_var="ROLE_OUTPUTS_${upper_role}"
    local output="${!output_var:-}"

    # 检查产出文件是否存在
    if [ -n "$output" ] && [ -e "$output" ]; then
      output="$output ✓"
    fi

    printf "  %-5s %-12s %-12s %-30s\n" "$emoji" "$role" "$status" "$output"
  done

  echo ""
}

# 重置状态
cmd_pipeline_reset() {
  local status_file="docs/current/status.md"

  mkdir -p "$(dirname "$status_file")"

  cat > "$status_file" << 'EOF'
# 项目状态

| 角色 | 状态 | 更新时间 |
|------|------|----------|
| PM | ⏳ 待开始 | - |
| Designer | ⏳ 待开始 | - |
| Frontend | ⏳ 待开始 | - |
| Backend | ⏳ 待开始 | - |
| QA | ⏳ 待开始 | - |
EOF

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
