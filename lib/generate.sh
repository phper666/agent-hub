#!/usr/bin/env bash
# ============================================================
#  generate — 根据领域自动生成角色配置
#
#  基于 harness 的 6 种团队架构模式
#  来源：https://github.com/revfactory/harness
# ============================================================

# 主入口函数（供 agent-hub 主命令调用）
cmd_generate() {
  local domain="${1:-help}"

  case "$domain" in
    help|--help|-h)
      show_generate_help
      ;;
    *)
      create_role_files "$domain"
      ;;
  esac
}

# 显示帮助
show_generate_help() {
  echo ""
  echo "用法: agent-hub generate <领域>"
  echo ""
  echo "根据领域自动生成角色配置"
  echo ""
  echo "可用领域:"
  echo "  web          Web 开发（5 角色）"
  echo "  mobile       移动端开发（5 角色）"
  echo "  data         数据分析（4 角色）"
  echo "  api          API 开发（4 角色）"
  echo "  ml           机器学习（4 角色）"
  echo "  devops       DevOps（4 角色）"
  echo "  game         游戏开发（5 角色）"
  echo "  blockchain   区块链（4 角色）"
  echo "  ai           AI 应用（4 角色）"
  echo "  ecommerce    电商（5 角色）"
  echo ""
  echo "示例:"
  echo "  agent-hub generate web"
  echo "  agent-hub generate mobile"
  echo "  agent-hub generate data"
  echo ""
}

# 获取领域角色配置
# 格式: "name|title|description" 每行一个角色
get_domain_roles() {
  local domain="$1"
  
  case "$domain" in
    web)
      cat << 'EOF'
product-manager|Senior Product Manager|Requirements analysis and product planning
ui-designer|Senior UI/UX Designer|Interface design and user experience
frontend-developer|Senior Frontend Developer|React/Vue implementation
backend-developer|Senior Backend Developer|API and database design
qa-engineer|Senior QA Engineer|Quality assurance
EOF
      ;;
    mobile)
      cat << 'EOF'
product-manager|Senior Product Manager|Mobile product planning
mobile-designer|Senior Mobile Designer|iOS/Android interface design
ios-developer|Senior iOS Developer|Swift/SwiftUI implementation
android-developer|Senior Android Developer|Kotlin implementation
mobile-qa|Senior Mobile QA|Device compatibility testing
EOF
      ;;
    data)
      cat << 'EOF'
data-analyst|Senior Data Analyst|Data exploration and insights
data-engineer|Senior Data Engineer|Data pipeline and ETL
ml-engineer|Senior ML Engineer|Model training and deployment
data-scientist|Senior Data Scientist|Advanced analysis and modeling
EOF
      ;;
    api)
      cat << 'EOF'
api-architect|Senior API Architect|API design and specification
backend-developer|Senior Backend Developer|API implementation
api-security|API Security Expert|Security auditing and protection
api-docs|API Documentation Engineer|Documentation and SDK
EOF
      ;;
    ml)
      cat << 'EOF'
ml-researcher|ML Researcher|Algorithm research and experimentation
data-engineer|Senior Data Engineer|Data preparation and feature engineering
ml-engineer|Senior ML Engineer|Model training and optimization
mlops-engineer|MLOps Engineer|Model deployment and monitoring
EOF
      ;;
    devops)
      cat << 'EOF'
devops-engineer|Senior DevOps Engineer|Infrastructure and deployment
sre-engineer|Senior SRE Engineer|Reliability and monitoring
security-engineer|Security Engineer|Security compliance and auditing
platform-engineer|Platform Engineer|Developer experience
EOF
      ;;
    game)
      cat << 'EOF'
game-designer|Senior Game Designer|Game mechanics and level design
game-programmer|Senior Game Programmer|Game logic and engine
game-artist|Senior Game Artist|Visual assets
game-audio|Senior Game Audio|Sound effects and music
game-qa|Senior Game QA|Game testing
EOF
      ;;
    blockchain)
      cat << 'EOF'
blockchain-architect|Blockchain Architect|On-chain architecture design
smart-contract-dev|Smart Contract Developer|Contract development
dapp-developer|DApp Developer|Decentralized applications
blockchain-security|Blockchain Security Expert|Contract auditing
EOF
      ;;
    ai)
      cat << 'EOF'
ai-engineer|AI Engineer|LLM application development
mlops-engineer|MLOps Engineer|Model deployment and operations
data-engineer|Senior Data Engineer|Data preparation and vectorization
ai-product-manager|AI Product Manager|AI product design
EOF
      ;;
    ecommerce)
      cat << 'EOF'
ecommerce-manager|E-commerce Manager|Business strategy and operations
frontend-developer|Senior Frontend Developer|E-commerce frontend
backend-developer|Senior Backend Developer|Orders and payment system
ux-designer|Senior UX Designer|Shopping experience design
data-analyst|Senior Data Analyst|Sales data analysis
EOF
      ;;
    *)
      return 1
      ;;
  esac
}

# 创建角色目录和文件
create_role_files() {
  local domain="$1"

  # 检查领域是否有效
  if ! get_domain_roles "$domain" > /dev/null 2>&1; then
    fail "未知领域: $domain。运行 'agent-hub generate help' 查看可用领域"
  fi

  echo ""
  echo -e "${CYAN}🦞 正在为领域 '$domain' 创建角色文件...${NC}"
  echo ""

  local roles_dir="roles"
  mkdir -p "$roles_dir"

  # 读取领域配置并创建角色
  local created=0
  local skipped=0
  
  while IFS='|' read -r name title description; do
    # 跳过空行
    [ -z "$name" ] && continue
    
    if create_role "$name" "$title" "$description"; then
      created=$((created + 1))
    else
      skipped=$((skipped + 1))
    fi
  done <<< "$(get_domain_roles "$domain")"

  echo ""
  if [ "$created" -gt 0 ]; then
    ok "角色文件创建完成: $created 个角色"
  fi
  if [ "$skipped" -gt 0 ]; then
    warn "跳过 $skipped 个已存在的角色"
  fi
  echo ""
  echo "下一步："
  echo "  1. agent-hub role list       查看角色列表"
  echo "  2. agent-hub install all --global  安装所有角色"
}

# 创建单个角色
create_role() {
  local name="$1"
  local title="$2"
  local description="$3"
  local role_dir="roles/$name"

  if [ -d "$role_dir" ]; then
    warn "角色 '$name' 已存在，跳过"
    return 1
  fi

  mkdir -p "$role_dir"

  # 创建 SKILL.md（模式 A：角色框架 + 专家知识分离）
  cat > "$role_dir/SKILL.md" << EOF
---
name: $name
description: $description.
---

# Role Framework: $title

You are the **engineering framework** for the $title role, responsible for coordinating rule loading, input/output management, and pipeline status updates.
Your domain expertise and technical depth are defined by the expert files (see loading order below).

## Prerequisites
- **markitdown**: Convert PDF/Office/images to text. Install: \`pip install markitdown\`

## Loading Order
1. \`.shared/rules/git-rules.md\` — Git conventions
2. \`.shared/rules/quality-rules.md\` — Quality standards
3. \`.shared/rules/security-rules.md\` — Security standards
4. This file (role framework)

> Add \`agents/agency/<name>-expert.md\` here to load domain expertise.

## Input
| File | Source | Required |
|------|--------|:--------:|
| docs/current/requirements/PRD.md | PM | ✅ |
| docs/current/status.md | All roles | ✅ (dependency check) |

## Output
| File | Consumer | Required |
|------|----------|:--------:|
| docs/current/status.md | All roles | ✅ (status update) |

## Dependency Check
Before starting, read \`docs/current/status.md\` to verify upstream roles are complete.

## Engineering Principles
- Stay within your role boundaries
- Collaborate with other roles, don't overstep
- Maintain code and documentation quality

## Workflow

### Step 1: Read Requirements
Read PRD and user stories

### Step 2: Execute
Execute tasks according to your role definition

### Step 3: Update Status
Update \`docs/current/status.md\`

## What You Do NOT Do
- Do not do other roles' work
- Do not modify other roles' outputs
- Do not skip quality checks
EOF

  # 创建 role.yaml
  cat > "$role_dir/role.yaml" << EOF
name: $name
version: "1.0.0"
description: $description.
author: agent-hub
tags:
  - $name
  - agent-hub
dependencies: []
EOF

  ok "创建角色: $name"
  return 0
}
