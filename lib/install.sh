#!/usr/bin/env bash
# ============================================================
#  安装/卸载模块
# ============================================================

# 安装单个角色到单个平台
install_role_to_platform() {
  local role_name="$1"
  local platform="$2"
  local mode="$3"  # global 或 project

  # 角色源目录始终从 agent-hub 安装目录读取
  local role_dir="$AGENT_HUB_DIR/roles/$role_name"
  local skill_file="$role_dir/SKILL.md"

  if [ ! -f "$skill_file" ]; then
    warn "角色 '$role_name' 的 SKILL.md 不存在，跳过"
    return 1
  fi

  # 获取目标路径（相对于当前工作目录）
  local target_base
  if [ "$mode" = "global" ]; then
    target_base="$(get_platform_global_path "$platform")"
  else
    target_base="$(get_platform_project_path "$platform")"
  fi

  if [ -z "$target_base" ]; then
    warn "平台 '$platform' 的路径未定义，跳过"
    return 1
  fi

  local target_dir="$target_base/$role_name"

  # 创建目标目录
  mkdir -p "$target_dir" 2>/dev/null || {
    warn "无法创建目录: $target_dir（可能需要权限，试试用 sudo 或在终端里手动创建）"
    return 1
  }

  # 复制 SKILL.md
  cp "$skill_file" "$target_dir/SKILL.md"

  # 复制角色资源
  safe_copy_dir "$role_dir/rules"   "$target_dir/rules"
  safe_copy_dir "$role_dir/skills"  "$target_dir/skills"
  safe_copy_dir "$role_dir/agents"  "$target_dir/agents"

  # 复制共享资源
  safe_copy_dir "$AGENT_HUB_DIR/.shared/rules"  "$target_dir/.shared/rules"
  safe_copy_dir "$AGENT_HUB_DIR/.shared/skills" "$target_dir/.shared/skills"

  return 0
}

# 卸载单个角色从单个平台
uninstall_role_from_platform() {
  local role_name="$1"
  local platform="$2"
  local mode="$3"

  local target_base
  if [ "$mode" = "global" ]; then
    target_base="$(get_platform_global_path "$platform")"
  else
    target_base="$(get_platform_project_path "$platform")"
  fi

  if [ -z "$target_base" ]; then
    return 1
  fi

  local target_dir="$target_base/$role_name"

  if [ -d "$target_dir" ]; then
    rm -rf "$target_dir"
    return 0
  fi
  return 1
}

# 解析平台参数
resolve_platforms() {
  local platforms="$1"
  if [ -z "$platforms" ]; then
    platforms="$(get_detected_platforms)"
    if [ -z "$platforms" ]; then
      fail "未检测到平台。先运行 'agent-hub detect'"
    fi
  fi
  echo "$platforms"
}

# 解析角色列表
resolve_roles() {
  local target="$1"
  local roles=()
  if [ "$target" = "all" ]; then
    for role_dir in "$AGENT_HUB_DIR"/roles/*/; do
      [ -d "$role_dir" ] || continue
      roles+=("$(basename "$role_dir")")
    done
  else
    roles=("$target")
  fi
  echo "${roles[@]}"
}

# 安装命令
cmd_install() {
  local target="${1:-all}"
  local mode="project"
  local platforms=""

  # 解析参数
  shift
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --global)  mode="global"; shift ;;
      --project) mode="project"; shift ;;
      --to)      platforms="$2"; shift 2 ;;
      *)         shift ;;
    esac
  done

  platforms="$(resolve_platforms "$platforms")"
  local roles_to_install
  read -ra roles_to_install <<< "$(resolve_roles "$target")"

  echo ""
  echo -e "${CYAN}📦 安装角色 (模式: $mode)${NC}"
  echo ""

  local total=0
  for role_name in "${roles_to_install[@]}"; do
    IFS=',' read -ra plat_array <<< "$platforms"
    for platform in "${plat_array[@]}"; do
      platform="$(echo "$platform" | tr -d '[:space:]')"
      [ -z "$platform" ] && continue

      if install_role_to_platform "$role_name" "$platform" "$mode"; then
        ok "$role_name → $platform ($mode)"
        total=$((total + 1))
      fi
    done
  done

  echo ""
  if [ "$total" -gt 0 ]; then
    ok "安装完成: $total 个角色实例"
  else
    warn "没有安装任何角色。如果是全局安装，可能需要在终端里手动运行命令（home 目录有权限限制）"
  fi
  echo ""
}

# 卸载命令
cmd_uninstall() {
  local target="${1:-all}"
  local mode="project"
  local platforms=""

  shift
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --global)  mode="global"; shift ;;
      --project) mode="project"; shift ;;
      --to)      platforms="$2"; shift 2 ;;
      *)         shift ;;
    esac
  done

  platforms="$(resolve_platforms "$platforms")"
  local roles_to_uninstall
  read -ra roles_to_uninstall <<< "$(resolve_roles "$target")"

  echo ""
  echo -e "${CYAN}🗑️  卸载角色 (模式: $mode)${NC}"
  echo ""

  local total=0
  for role_name in "${roles_to_uninstall[@]}"; do
    IFS=',' read -ra plat_array <<< "$platforms"
    for platform in "${plat_array[@]}"; do
      platform="$(echo "$platform" | tr -d '[:space:]')"
      [ -z "$platform" ] && continue

      if uninstall_role_from_platform "$role_name" "$platform" "$mode"; then
        ok "卸载: $role_name ← $platform"
        total=$((total + 1))
      fi
    done
  done

  echo ""
  if [ "$total" -gt 0 ]; then
    ok "卸载完成: $total 个角色实例"
  else
    warn "没有找到已安装的角色（请在项目目录里运行卸载命令）"
  fi
  echo ""
}

# 更新命令（卸载 + 安装，保留模式）
cmd_update() {
  local target="${1:-all}"
  local mode="project"
  local platforms=""

  shift 2>/dev/null || true
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --global)  mode="global"; shift ;;
      --project) mode="project"; shift ;;
      --to)      platforms="$2"; shift 2 ;;
      *)         shift ;;
    esac
  done

  platforms="$(resolve_platforms "$platforms")"

  echo ""
  echo -e "${CYAN}🔄 更新角色 (模式: $mode)${NC}"
  echo ""

  # 先卸载再安装
  cmd_uninstall "$target" "--$mode" --to "$platforms"
  cmd_install "$target" "--$mode" --to "$platforms"

  ok "更新完成"
  echo ""
}

# 升级命令（自更新）
cmd_upgrade() {
  echo ""
  echo -e "${CYAN}🔄 检查更新${NC}"
  echo ""

  local current_version
  current_version="$("$AGENT_HUB_DIR/agent-hub" version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
  info "当前版本: v$current_version"

  # 检查是否是 git 仓库
  if [ -d "$AGENT_HUB_DIR/.git" ]; then
    cd "$AGENT_HUB_DIR"
    # 检查是否有远程仓库
    if git remote -v 2>/dev/null | grep -q "origin"; then
      info "从远程仓库更新..."
      local default_branch
      default_branch="$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')"
      if [ -z "$default_branch" ]; then
        # 尝试 main 或 master
        git pull origin main 2>&1 || git pull origin master 2>&1
      else
        git pull origin "$default_branch" 2>&1
      fi
      ok "更新完成"
    else
      # 本地仓库，检查是否有新 commit
      local last_commit
      last_commit="$(git log --oneline -1 2>/dev/null)"
      info "本地仓库，已是最新版本"
      echo "  最新提交: $last_commit"
      echo ""
      info "如需远程同步，添加远程仓库："
      echo "  cd $AGENT_HUB_DIR"
      echo "  git remote add origin https://github.com/your-repo/agent-hub.git"
      echo "  git push -u origin main"
    fi
  else
    info "非 Git 安装，请手动下载最新版本"
    echo "  GitHub: https://github.com/your-repo/agent-hub"
  fi

  echo ""
}
