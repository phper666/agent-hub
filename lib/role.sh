#!/usr/bin/env bash
# ============================================================
#  角色管理模块
# ============================================================

# 角色列表
cmd_role_list() {
  echo ""
  echo -e "${CYAN}📋 角色列表${NC}"
  echo ""

  if [ ! -d "roles" ] || [ -z "$(ls -A roles 2>/dev/null)" ]; then
    warn "还没有角色，运行 'agent-hub role create <name>' 创建"
    return
  fi

  printf "  %-5s %-15s %-30s %-10s\n" "EMOJI" "名称" "描述" "状态"
  printf "  %-5s %-15s %-30s %-10s\n" "────" "───────────────" "──────────────────────────────" "──────────"

  for role_dir in roles/*/; do
    [ -d "$role_dir" ] || continue
    local name
    name="$(basename "$role_dir")"
    local skill_file="$role_dir/SKILL.md"

    if [ -f "$skill_file" ]; then
      local emoji description
      emoji="🤖"
      description=""

      # 从 YAML frontmatter 提取描述
      local in_frontmatter=false
      while IFS= read -r line; do
        if [ "$line" = "---" ]; then
          if [ "$in_frontmatter" = false ]; then
            in_frontmatter=true
          else
            break
          fi
          continue
        fi

        if [ "$in_frontmatter" = true ]; then
          # 提取 description（单行格式）
          if echo "$line" | grep -q "^description:"; then
            description="$(echo "$line" | sed 's/^description:[[:space:]]*//' | sed 's/[[:space:]]*$//')"
          fi
        fi
      done < "$skill_file"

      # 角色 emoji 映射
      case "$name" in
        pm|product-manager) emoji="🤖" ;;
        designer) emoji="🎨" ;;
        frontend|frontend-dev) emoji="💻" ;;
        backend|backend-dev) emoji="⚙️" ;;
        qa|qa-engineer) emoji="🧪" ;;
        router) emoji="🔀" ;;
      esac

      printf "  %-5s %-15s %-50s %-10s\n" "$emoji" "$name" "${description:0:48}" "已定义"
    else
      printf "  %-5s %-15s %-30s %-10s\n" "❓" "$name" "(无 SKILL.md)" "不完整"
    fi
  done

  echo ""
}

# 创建角色模板
cmd_role_create() {
  local name="$1"
  if [ -z "$name" ]; then
    fail "用法: agent-hub role create <name>"
  fi

  local role_dir="roles/$name"
  if [ -d "$role_dir" ]; then
    warn "角色 '$name' 已存在"
    return
  fi

  mkdir -p "$role_dir/rules" "$role_dir/skills"

  # 生成 SKILL.md 模板
  cat > "$role_dir/SKILL.md" << EOF
---
name: $name
description: |
  TODO: 一句话描述这个角色的职责。
  Trigger on: 关键词1, 关键词2.
---

# Role: $name

你是一个 TODO（填写角色名）。

## 加载顺序
1. \`.shared/rules/git-rules.md\` — Git 规范
2. \`.shared/rules/quality-rules.md\` — 质量底线
3. \`.shared/rules/security-rules.md\` — 安全底线
4. 本文件（角色指令）

## Input
| 文件 | 来源 | 是否必须 |
|------|------|:---:|
| TODO | TODO | ✅ |

## Output
| 文件 | 下游消费者 | 是否必须 |
|------|-----------|:---:|
| TODO | TODO | ✅ |

## Core Principles
- TODO: 列出核心原则

## Workflow

### Step 1: TODO
TODO: 描述工作流程

## 你不能做的事
- TODO: 列出限制
EOF

  ok "角色 '$name' 已创建: $role_dir/SKILL.md"
  info "编辑: agent-hub role edit $name"
}

# 编辑角色
cmd_role_edit() {
  local name="$1"
  if [ -z "$name" ]; then
    fail "用法: agent-hub role edit <name>"
  fi

  local skill_file="roles/$name/SKILL.md"
  if [ ! -f "$skill_file" ]; then
    fail "角色 '$name' 不存在。运行 'agent-hub role create $name' 创建"
  fi

  # 用默认编辑器打开
  ${EDITOR:-vi} "$skill_file"
}

# 删除角色
cmd_role_delete() {
  local name="$1"
  if [ -z "$name" ]; then
    fail "用法: agent-hub role delete <name>"
  fi

  local role_dir="roles/$name"
  if [ ! -d "$role_dir" ]; then
    fail "角色 '$name' 不存在"
  fi

  rm -rf "$role_dir"
  ok "角色 '$name' 已删除"
}

# 查看角色详情
cmd_role_info() {
  local name="$1"
  if [ -z "$name" ]; then
    fail "用法: agent-hub role info <name>"
  fi

  local skill_file="roles/$name/SKILL.md"
  if [ ! -f "$skill_file" ]; then
    fail "角色 '$name' 不存在"
  fi

  echo ""
  echo -e "${CYAN}📄 角色: $name${NC}"
  echo ""
  head -20 "$skill_file"
  echo ""
  info "完整文件: $skill_file"
  echo ""
}

# 角色管理主入口
cmd_role() {
  local subcmd="${1:-list}"
  shift 2>/dev/null || true

  case "$subcmd" in
    list)   cmd_role_list "$@" ;;
    create) cmd_role_create "$@" ;;
    edit)   cmd_role_edit "$@" ;;
    delete) cmd_role_delete "$@" ;;
    info)   cmd_role_info "$@" ;;
    *)      fail "未知子命令: role $subcmd。可用: list/create/edit/delete/info" ;;
  esac
}

# 导入角色（从 skills-install-sh 等项目）
cmd_import() {
  local source_path="$1"
  if [ -z "$source_path" ]; then
    fail "用法: agent-hub import <path>"
  fi

  if [ ! -d "$source_path/roles" ]; then
    fail "未找到 roles/ 目录: $source_path"
  fi

  echo ""
  echo -e "${CYAN}📥 从 $source_path 导入角色${NC}"
  echo ""

  local imported=0
  for role_dir in "$source_path"/roles/*/; do
    [ -d "$role_dir" ] || continue
    local name
    name="$(basename "$role_dir")"

    if [ -f "$role_dir/SKILL.md" ]; then
      mkdir -p "roles/$name/rules" "roles/$name/skills"
      cp "$role_dir/SKILL.md" "roles/$name/SKILL.md"
      [ -d "$role_dir/rules" ] && cp -r "$role_dir/rules/"* "roles/$name/rules/" 2>/dev/null || true
      [ -d "$role_dir/skills" ] && cp -r "$role_dir/skills/"* "roles/$name/skills/" 2>/dev/null || true
      ok "导入: $name"
      imported=$((imported + 1))
    fi
  done

  # 导入共享规则
  if [ -d "$source_path/.shared/rules" ]; then
    mkdir -p .shared/rules
    cp -r "$source_path/.shared/rules/"* ".shared/rules/" 2>/dev/null || true
    ok "导入共享规则"
  fi

  echo ""
  ok "导入完成: $imported 个角色"
  echo ""
}

# 导出角色
cmd_export() {
  local name="$1"
  local output="${2:-}"

  if [ -z "$name" ]; then
    fail "用法: agent-hub export <role> [--output <file>]"
  fi

  local skill_file="roles/$name/SKILL.md"
  if [ ! -f "$skill_file" ]; then
    fail "角色 '$name' 不存在"
  fi

  if [ -n "$output" ]; then
    cp "$skill_file" "$output"
    ok "导出到: $output"
  else
    cat "$skill_file"
  fi
}

# 依赖管理
cmd_deps() {
  local subcmd="${1:-list}"
  shift 2>/dev/null || true

  case "$subcmd" in
    install)
      echo ""
      echo -e "${CYAN}📦 安装依赖${NC}"
      echo ""

      # markitdown
      if python3 -c "import markitdown" 2>/dev/null; then
        ok "markitdown 已安装"
      else
        info "安装 markitdown..."
        pip install markitdown 2>/dev/null && ok "markitdown 安装完成" || warn "markitdown 安装失败"
      fi

      echo ""
      ok "依赖安装完成"
      ;;
    list)
      echo ""
      echo -e "${CYAN}📦 依赖列表${NC}"
      echo ""
      echo "  markitdown    文件转 Markdown（PDF/Office/图片）"
      echo ""
      ;;
    *)
      fail "未知子命令: deps $subcmd"
      ;;
  esac
}
