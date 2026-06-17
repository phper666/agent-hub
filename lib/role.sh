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
        architect) emoji="🏛️" ;;
        backend|backend-dev) emoji="⚙️" ;;
        delivery-director) emoji="📋" ;;
        designer) emoji="🎨" ;;
        frontend|frontend-dev) emoji="💻" ;;
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

# 角色去重检查 — 创建前扫描已有角色是否功能重复
check_role_duplication() {
  local new_name="$1"
  local new_description="$2"

  [ ! -d "roles" ] && return 0

  for existing_role in roles/*/; do
    [ -d "$existing_role" ] || continue
    local existing_name
    existing_name="$(basename "$existing_role")"

    local skill_file="$existing_role/SKILL.md"
    [ ! -f "$skill_file" ] && continue

    # 提取现有角色的 description
    local existing_desc
    existing_desc="$(grep "^description:" "$skill_file" 2>/dev/null | head -1 | sed 's/^description:[[:space:]]*//' | sed 's/[[:space:]]*$//')"
    [ -z "$existing_desc" ] && continue

    # 关键词重叠检测：将 description 拆成单词，计算重叠率
    local overlap=0 total=0
    for word in $new_description; do
      # 跳过太短的词和 TODO 占位符
      [ ${#word} -lt 3 ] && continue
      echo "$word" | grep -qi "todo" && continue

      total=$((total + 1))
      if echo "$existing_desc" | grep -qi "$word"; then
        overlap=$((overlap + 1))
      fi
    done

    # 如果有意义的关键词 > 0 且重叠率 >= 50%，警告
    if [ "$total" -gt 1 ] && [ "$(( overlap * 100 / total ))" -ge 50 ]; then
      local overlap_pct=$(( overlap * 100 / total ))
      warn "新角色 '$new_name' 与已有角色 '$existing_name' 功能相似"
      info "  新角色描述: $new_description"
      info "  已有角色描述: $existing_desc"
      info "  关键词重叠率: ${overlap_pct}%"
      info "  建议: 扩展已有角色 (agent-hub role edit $existing_name) 或确认后重试"
      return 1
    fi
  done
  return 0
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

  # 去重检查
  local role_desc="TODO: 角色职责描述，请在创建后编辑"
  if ! check_role_duplication "$name" "$role_desc"; then
    info "如需跳过检查，使用 --force 参数（暂不支持）"
    return 1
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

### Step 2: Update Status
更新 \`docs/current/status.md\` 标记当前角色状态

### Step 3: Self-Evaluation (可选)
任务完成后，将简要自评写入 \`docs/current/feedback/{role}-self-eval.md\`：
- 哪些规则/技能帮上忙了
- 哪些规则不适用/可以改进
- 是否有 Expert 知识遗漏

## Team Communication Protocol（团队通信协议）

| 场景 | 行为 |
|------|------|
| **被阻塞时** | 更新 \`docs/current/status.md\`，标记为 ❌ Blocked，注明原因 |
| **上游产出有问题时** | 将发现写入 \`docs/current/feedback/{role}-feedback.md\`，通知 Delivery Director |
| **完成任务时** | 更新 \`docs/current/status.md\`，标记为 ✅ Done，注明产出路径 |
| **跨角色交接** | 启动前检查 \`docs/current/feedback/\` 目录，确认是否有已知问题 |

## Error Handling（错误处理）

| 异常类型 | 处理方式 |
|---------|---------|
| **Input 文件缺失** | ❌ 停止并报告："缺少 [文件名]，等待 [上游角色] 完成" |
| **Input 文件存在但为空** | ⚠️ 停止并报告："[文件名] 为空，请检查 [上游角色] 的产出" |
| **Input 格式不符合预期** | 尝试解析；失败则报告并请求澄清 |
| **工具/API 失败** (markitdown等) | 重试 1 次；仍失败则用已有数据继续，在产出中注明缺失部分 |
| **任务超时** | 保存部分产出，标记状态为 ⚠️ Partial |

## 你不能做的事
- TODO: 列出限制
- 不要静默忽略缺失或损坏的 Input — 始终报告
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

  [ -z "$role_dir" ] && fail "内部错误：角色路径为空"
  [ "$role_dir" = "roles" ] || [ "$role_dir" = "roles/" ] && fail "内部错误：不允许删除 roles 目录"
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
    help|--help|-h)
      echo "用法: agent-hub role <子命令>"
      echo ""
      echo "可用子命令:"
      echo "  list               列出所有角色"
      echo "  create <name>      创建角色模板"
      echo "  edit <name>        用编辑器打开角色 SKILL.md"
      echo "  delete <name>      删除角色"
      echo "  info <name>        查看角色详情"
      ;;
    *)      fail "未知子命令: role $subcmd。运行 'agent-hub role help' 查看帮助" ;;
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
      mkdir -p "roles/$name/rules" "roles/$name/skills" "roles/$name/agents"
      cp "$role_dir/SKILL.md" "roles/$name/SKILL.md"
      [ -d "$role_dir/rules" ] && cp -r "$role_dir/rules/"* "roles/$name/rules/" 2>/dev/null || true
      [ -d "$role_dir/skills" ] && cp -r "$role_dir/skills/"* "roles/$name/skills/" 2>/dev/null || true
      [ -d "$role_dir/agents" ] && cp -r "$role_dir/agents/"* "roles/$name/agents/" 2>/dev/null || true
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
  local name=""
  local output=""

  # 解析参数
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --output|-o)
        output="$2"
        shift 2
        ;;
      *)
        name="$1"
        shift
        ;;
    esac
  done

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
