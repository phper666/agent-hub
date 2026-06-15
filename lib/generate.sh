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
product-manager|Senior Product Manager|需求分析和产品规划
ui-designer|Senior UI/UX Designer|界面设计和用户体验
frontend-developer|Senior Frontend Developer|React/Vue 实现
backend-developer|Senior Backend Developer|API 和数据库设计
qa-engineer|Senior QA Engineer|质量保证
EOF
      ;;
    mobile)
      cat << 'EOF'
product-manager|Senior Product Manager|移动端产品规划
mobile-designer|Senior Mobile Designer|iOS/Android 界面设计
ios-developer|Senior iOS Developer|Swift/SwiftUI 实现
android-developer|Senior Android Developer|Kotlin 实现
mobile-qa|Senior Mobile QA|设备兼容性测试
EOF
      ;;
    data)
      cat << 'EOF'
data-analyst|Senior Data Analyst|数据探索和洞察
data-engineer|Senior Data Engineer|数据管道和 ETL
ml-engineer|Senior ML Engineer|模型训练和部署
data-scientist|Senior Data Scientist|高级分析和建模
EOF
      ;;
    api)
      cat << 'EOF'
api-architect|Senior API Architect|API 设计和规范
backend-developer|Senior Backend Developer|API 实现
api-security|API Security Expert|安全审计和防护
api-docs|API Documentation Engineer|文档和 SDK
EOF
      ;;
    ml)
      cat << 'EOF'
ml-researcher|ML Researcher|算法研究和实验
data-engineer|Senior Data Engineer|数据准备和特征工程
ml-engineer|Senior ML Engineer|模型训练和优化
mlops-engineer|MLOps Engineer|模型部署和监控
EOF
      ;;
    devops)
      cat << 'EOF'
devops-engineer|Senior DevOps Engineer|基础设施和部署
sre-engineer|Senior SRE Engineer|可靠性和监控
security-engineer|Security Engineer|安全合规和审计
platform-engineer|Platform Engineer|开发者体验
EOF
      ;;
    game)
      cat << 'EOF'
game-designer|Senior Game Designer|游戏机制和玩法设计
game-programmer|Senior Game Programmer|游戏逻辑和引擎
game-artist|Senior Game Artist|视觉资产
game-audio|Senior Game Audio|音效和音乐
game-qa|Senior Game QA|游戏测试
EOF
      ;;
    blockchain)
      cat << 'EOF'
blockchain-architect|Blockchain Architect|链上架构设计
smart-contract-dev|Smart Contract Developer|合约开发
dapp-developer|DApp Developer|去中心化应用
blockchain-security|Blockchain Security Expert|合约审计
EOF
      ;;
    ai)
      cat << 'EOF'
ai-engineer|AI Engineer|LLM 应用开发
mlops-engineer|MLOps Engineer|模型部署和运维
data-engineer|Senior Data Engineer|数据准备和向量化
ai-product-manager|AI Product Manager|AI 产品设计
EOF
      ;;
    ecommerce)
      cat << 'EOF'
ecommerce-manager|E-commerce Manager|业务策略和运营
frontend-developer|Senior Frontend Developer|商城前端
backend-developer|Senior Backend Developer|订单和支付系统
ux-designer|Senior UX Designer|购物体验设计
data-analyst|Senior Data Analyst|销售数据分析
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

# 角色框架: $title

你是${title}的**工程框架**，负责协调规则加载、输入/输出管理和流水线状态更新。

## 必备工具
- **markitdown**: 读取 PDF/Office/图片文档，提取文本内容。安装：\`pip install markitdown\`

## 加载顺序
1. \`.shared/rules/git-rules.md\` — Git 规范
2. \`.shared/rules/quality-rules.md\` — 质量底线
3. \`.shared/rules/security-rules.md\` — 安全底线
4. 本文件（角色框架 — 工程流程协调）

> 如需添加领域专家知识，创建 \`agents/agency/<name>-expert.md\` 并在此处引用。

## Input（你需要读取的文件）
| 文件 | 来源角色 | 是否必须 |
|------|---------|:---:|
| docs/current/requirements/PRD.md | PM | ✅ |
| docs/current/status.md | 所有角色 | ✅（检查依赖状态） |

## Output（你需要产出的文件）
| 文件 | 下游消费者 | 是否必须 |
|------|-----------|:---:|
| docs/current/status.md | 所有角色 | ✅（更新状态） |

## Dependency Check（启动前必须检查）
启动前必须读取 \`docs/current/status.md\`，确认上游角色已完成。

## 工程原则
- 专注于自己的职责范围
- 与其他角色协作，不越界
- 保持代码和文档的质量

## 工程流程

### Step 1: 读取需求
读取 PRD 和用户故事

### Step 2: 执行任务
根据角色职责执行具体任务

### Step 3: 更新状态
更新 \`docs/current/status.md\`

## 你不能做的事
- 不做其他角色的工作
- 不修改其他角色的产出物
- 不跳过质量检查
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
