#!/usr/bin/env bash
# ============================================================
#  clean — 扫描并清除所有平台上 agent-hub 安装的角色残留
# ============================================================

# 主入口函数
cmd_clean() {
  local dry_run=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run|--dryrun|-n)
        dry_run=true
        shift
        ;;
      help|--help|-h)
        show_clean_help
        return
        ;;
      *)
        shift
        ;;
    esac
  done

  echo ""
  echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║  🧹 agent-hub 清理残留角色                ║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
  echo ""

  if $dry_run; then
    info "DRY RUN 模式 — 仅扫描，不执行删除"
    echo ""
  fi

  # 第一步：扫描所有平台，存入临时文件
  local scan_file
  scan_file="$(mktemp /tmp/agent-hub-clean.XXXXXX)" || {
    fail "无法创建临时文件"
  }

  local total_found=0
  local known="reasonix qoder claude cursor workbuddy codex gemini opencode zcode"

  for platform in $known; do
    local global_path
    global_path="$(get_platform_global_path "$platform")"

    if [ -z "$global_path" ] || [ ! -d "$global_path" ]; then
      continue
    fi

    local has_roles=false
    for subdir in "$global_path"/*/; do
      [ -d "$subdir" ] || continue
      local name="$(basename "$subdir")"
      if is_agent_hub_role "$subdir"; then
        echo "$platform|$global_path|$name|$(du -sh "$subdir" 2>/dev/null | cut -f1)" >> "$scan_file"
        total_found=$((total_found + 1))
        has_roles=true
      fi
    done
  done

  # 也扫描当前项目目录
  local project_scan_file
  project_scan_file="$(mktemp /tmp/agent-hub-clean-project.XXXXXX)" || {
    fail "无法创建临时文件"
  }

  local proj_count=0
  for platform in $known; do
    local proj_path
    proj_path="$(get_platform_project_path "$platform")"
    if [ -n "$proj_path" ] && [ -d "$proj_path" ]; then
      for subdir in "$proj_path"/*/; do
        [ -d "$subdir" ] || continue
        local name="$(basename "$subdir")"
        if is_agent_hub_role "$subdir"; then
          echo "$platform|$proj_path|$name|$(du -sh "$subdir" 2>/dev/null | cut -f1)" >> "$project_scan_file"
          proj_count=$((proj_count + 1))
        fi
      done
    fi
  done

  # 展示结果
  if [ "$total_found" -eq 0 ] && [ "$proj_count" -eq 0 ]; then
    ok "未发现 agent-hub 安装的角色残留"
    rm -f "$scan_file" "$project_scan_file"
    echo ""
    return
  fi

  echo -e "${YELLOW}════════════════════════════════════════════${NC}"
  echo ""

  local idx=0
  local last_platform=""

  if [ "$total_found" -gt 0 ]; then
    echo -e "  ${CYAN}[全局安装]${NC}"
    echo ""
    while IFS='|' read -r platform path name size; do
      if [ "$platform" != "$last_platform" ]; then
        echo -e "  ${CYAN}$platform${NC}  ($path)"
        last_platform="$platform"
      fi
      idx=$((idx + 1))
      echo -e "    ${idx}. ${YELLOW}$name${NC}  ($size)"
    done < "$scan_file"
    echo ""
  fi

  if [ "$proj_count" -gt 0 ]; then
    echo -e "  ${CYAN}[项目安装] (当前目录)${NC}"
    echo ""
    last_platform=""
    while IFS='|' read -r platform path name size; do
      if [ "$platform" != "$last_platform" ]; then
        echo -e "  ${CYAN}$platform${NC}  ($path)"
        last_platform="$platform"
      fi
      idx=$((idx + 1))
      echo -e "    ${idx}. ${YELLOW}$name${NC}  ($size)"
    done < "$project_scan_file"
    echo ""
  fi

  echo -e "${YELLOW}════════════════════════════════════════════${NC}"
  echo ""
  echo -e "  ${RED}总计: $idx 个角色目录待清理${NC}"
  echo ""

  if $dry_run; then
    info "DRY RUN 完成。移除 --dry-run 以执行实际清理。"
    rm -f "$scan_file" "$project_scan_file"
    echo ""
    return
  fi

  # 确认清理
  warn "此操作将永久删除以上所有角色目录及其内容！"
  echo ""
  if ! confirm_action "确认清理以上所有 agent-hub 角色残留？"; then
    info "已取消清理"
    rm -f "$scan_file" "$project_scan_file"
    echo ""
    return
  fi

  echo ""
  echo -e "${CYAN}🗑️  正在清理...${NC}"
  echo ""

  local deleted=0
  local failed=0

  # 清理全局安装
  while IFS='|' read -r platform path name size; do
    local target="$path/$name"

    # 安全检查
    if [ "$target" = "/" ] || [ ${#target} -lt 5 ]; then
      warn "安全跳过: $target (路径异常)"
      failed=$((failed + 1))
      continue
    fi

    if rm -rf "$target" 2>/dev/null; then
      ok "$platform/$name"
      deleted=$((deleted + 1))
    else
      warn "$platform/$name (删除失败)"
      failed=$((failed + 1))
    fi
  done < "$scan_file"

  # 清理项目安装
  if [ -f "$project_scan_file" ]; then
    while IFS='|' read -r platform path name size; do
      local target="$path/$name"
      if rm -rf "$target" 2>/dev/null; then
        ok "项目: $platform/$name"
        deleted=$((deleted + 1))
      else
        warn "项目: $platform/$name (删除失败)"
        failed=$((failed + 1))
      fi
    done < "$project_scan_file"
  fi

  rm -f "$scan_file" "$project_scan_file"

  echo ""
  if [ "$deleted" -gt 0 ]; then
    ok "清理完成: 删除 $deleted 个角色实例"
  fi
  if [ "$failed" -gt 0 ]; then
    warn "$failed 个删除失败"
  fi
  echo ""
}

# 显示帮助
show_clean_help() {
  echo ""
  echo "用法: agent-hub clean [选项]"
  echo ""
  echo "扫描所有已安装 Agent 平台，清除 agent-hub 安装的角色残留。"
  echo ""
  echo "选项:"
  echo "  --dry-run, -n     仅扫描展示，不执行删除"
  echo ""
  echo "识别规则："
  echo "  - 目录内有 .agent-hub-installed 标记文件"
  echo "  - 或目录内有 .shared/ 子目录 (agent-hub 特征)"
  echo ""
  echo "示例:"
  echo "  agent-hub clean --dry-run    预览待清理项"
  echo "  agent-hub clean              执行清理"
  echo ""
}
