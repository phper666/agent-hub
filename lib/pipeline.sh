#!/usr/bin/env bash
# ============================================================
#  流水线模块（兼容 Bash 3.x+）
# ============================================================

# 获取角色产出文件
get_role_output() {
  local role="$1"
  case "$role" in
    pm)       echo "docs/current/requirements/PRD.md" ;;
    designer) echo "docs/current/design/component-spec.md" ;;
    frontend) echo "src/frontend/" ;;
    backend)  echo "src/backend/" ;;
    qa)       echo "tests/" ;;
    *)        echo "" ;;
  esac
}

# 获取角色 emoji
get_role_emoji() {
  local role="$1"
  case "$role" in
    pm)       echo "🤖" ;;
    designer) echo "🎨" ;;
    frontend) echo "💻" ;;
    backend)  echo "⚙️" ;;
    qa)       echo "🧪" ;;
    router)   echo "🔀" ;;
    *)        echo "❓" ;;
  esac
}

# 从 SKILL.md frontmatter 提取 depends_on
get_role_deps() {
  local role="$1"
  local skill_file="roles/$role/SKILL.md"
  if [ -f "$skill_file" ]; then
    grep "^depends_on:" "$skill_file" 2>/dev/null | head -1 | sed 's/^depends_on: *\[//' | sed 's/\] *$//' | sed 's/, */ /g'
  fi
}

# 获取角色状态
get_role_status() {
  local role="$1"
  local status_file="docs/current/status.md"
  if [ ! -f "$status_file" ]; then echo "⏳ 待开始"; return; fi

  local line
  line="$(grep -i "$role" "$status_file" 2>/dev/null | head -1)"
  if [ -z "$line" ]; then echo "⏳ 待开始"; return; fi

  if echo "$line" | grep -q "✅"; then echo "✅ 完成"
  elif echo "$line" | grep -q "🔄"; then echo "🔄 进行中"
  else echo "⏳ 待开始"; fi
}

# 获取角色显示名称
get_role_display_name() {
  local name="$1"
  local skill_file="roles/$name/SKILL.md"
  if [ -f "$skill_file" ]; then
    grep "^description:" "$skill_file" 2>/dev/null | head -1 | sed 's/^description:[[:space:]]*//' | cut -d'.' -f1
  else
    echo "$name"
  fi
}

# 管线状态
cmd_pipeline_status() {
  echo ""
  echo -e "${CYAN}📊 项目流水线状态${NC}"
  echo ""

  printf "  %-5s %-15s %-12s %-18s %s\n" "" "角色" "状态" "依赖" "产出"
  printf "  %-5s %-15s %-12s %-18s %s\n" "───" "───────────────" "────────────" "──────────────────" "──────────────────────────────"

  for role_dir in roles/*/; do
    [ -d "$role_dir" ] || continue
    local role
    role="$(basename "$role_dir")"
    local emoji="$(get_role_emoji "$role")"
    local status="$(get_role_status "$role")"
    local deps="$(get_role_deps "$role")"
    [ -z "$deps" ] && deps="-"
    local output="$(get_role_output "$role")"
    [ -n "$output" ] && [ -e "$output" ] && output="$output ✓"

    printf "  %-5s %-15s %-12s %-18s %s\n" "$emoji" "$role" "$status" "$deps" "$output"
  done

  echo ""
}

# 重置状态
cmd_pipeline_reset() {
  local status_file="docs/current/status.md"
  mkdir -p "$(dirname "$status_file")"

  {
    echo "# 项目状态"
    echo ""
    echo "| 角色 | 状态 | 更新时间 |"
    echo "|------|------|----------|"
    for role_dir in roles/*/; do
      [ -d "$role_dir" ] || continue
      local role="$(basename "$role_dir")"
      local first_char="${role:0:1}"
      local capitalized="${first_char^^}${role:1}"
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
