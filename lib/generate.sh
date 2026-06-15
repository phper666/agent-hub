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

# 领域模板库
declare -A DOMAIN_TEMPLATES

# Web 开发
DOMAIN_TEMPLATES[web]="
roles:
  - name: product-manager
    description: 产品经理，负责需求分析和产品规划
    skills: [requirements-analysis, user-stories, prd-writing]
  - name: ui-designer
    description: UI/UX 设计师，负责界面设计和用户体验
    skills: [figma-design, prototyping, design-system]
  - name: frontend-developer
    description: 前端开发工程师，负责 React/Vue 实现
    skills: [react, typescript, css, testing]
  - name: backend-developer
    description: 后端开发工程师，负责 API 和数据库设计
    skills: [nodejs, python, sql, api-design]
  - name: qa-engineer
    description: 测试工程师，负责质量保证
    skills: [e2e-testing, integration-testing, test-automation]
architecture: pipeline
dependencies:
  - product-manager -> ui-designer
  - ui-designer -> frontend-developer
  - ui-designer -> backend-developer
  - frontend-developer -> qa-engineer
  - backend-developer -> qa-engineer
"

# 移动端开发
DOMAIN_TEMPLATES[mobile]="
roles:
  - name: product-manager
    description: 产品经理，负责移动端产品规划
    skills: [mobile-requirements, user-flows, app-monetization]
  - name: mobile-designer
    description: 移动端设计师，负责 iOS/Android 界面设计
    skills: [ios-guidelines, material-design, mobile-prototyping]
  - name: ios-developer
    description: iOS 开发工程师，负责 Swift/SwiftUI 实现
    skills: [swift, swiftui, core-data, testing]
  - name: android-developer
    description: Android 开发工程师，负责 Kotlin 实现
    skills: [kotlin, jetpack-compose, room, testing]
  - name: mobile-qa
    description: 移动端测试工程师，负责设备兼容性测试
    skills: [device-testing, performance-testing, accessibility]
architecture: fan-out
dependencies:
  - product-manager -> mobile-designer
  - mobile-designer -> ios-developer
  - mobile-designer -> android-developer
  - ios-developer -> mobile-qa
  - android-developer -> mobile-qa
"

# 数据分析
DOMAIN_TEMPLATES[data]="
roles:
  - name: data-analyst
    description: 数据分析师，负责数据探索和洞察
    skills: [sql, python, data-visualization, statistical-analysis]
  - name: data-engineer
    description: 数据工程师，负责数据管道和 ETL
    skills: [spark, airflow, data-warehouse, etl]
  - name: ml-engineer
    description: 机器学习工程师，负责模型训练和部署
    skills: [tensorflow, pytorch, model-serving, experiment-tracking]
  - name: data-scientist
    description: 数据科学家，负责高级分析和建模
    skills: [advanced-statistics, feature-engineering, model-evaluation]
architecture: expert-pool
dependencies:
  - data-analyst -> data-engineer
  - data-engineer -> ml-engineer
  - data-scientist -> ml-engineer
"

# API 开发
DOMAIN_TEMPLATES[api]="
roles:
  - name: api-architect
    description: API 架构师，负责 API 设计和规范
    skills: [rest-api, graphql, api-design, openapi]
  - name: backend-developer
    description: 后端开发工程师，负责 API 实现
    skills: [nodejs, python, java, database]
  - name: api-security
    description: API 安全专家，负责安全审计和防护
    skills: [oauth, jwt, rate-limiting, security-testing]
  - name: api-docs
    description: API 文档工程师，负责文档和 SDK
    skills: [swagger, sdk-generation, developer-experience]
architecture: producer-reviewer
dependencies:
  - api-architect -> backend-developer
  - backend-developer -> api-security
  - backend-developer -> api-docs
"

# 机器学习
DOMAIN_TEMPLATES[ml]="
roles:
  - name: ml-researcher
    description: ML 研究员，负责算法研究和实验
    skills: [research-papers, experiment-design, model-architecture]
  - name: data-engineer
    description: 数据工程师，负责数据准备和特征工程
    skills: [data-pipeline, feature-store, data-quality]
  - name: ml-engineer
    description: ML 工程师，负责模型训练和优化
    skills: [training, hyperparameter-tuning, distributed-training]
  - name: mlops-engineer
    description: MLOps 工程师，负责模型部署和监控
    skills: [model-serving, monitoring, a-b-testing, ci-cd]
architecture: hierarchical
dependencies:
  - ml-researcher -> data-engineer
  - data-engineer -> ml-engineer
  - ml-engineer -> mlops-engineer
"

# DevOps
DOMAIN_TEMPLATES[devops]="
roles:
  - name: devops-engineer
    description: DevOps 工程师，负责基础设施和部署
    skills: [docker, kubernetes, terraform, ci-cd]
  - name: sre-engineer
    description: SRE 工程师，负责可靠性和监控
    skills: [monitoring, alerting, incident-response, capacity-planning]
  - name: security-engineer
    description: 安全工程师，负责安全合规和审计
    skills: [security-scanning, compliance, vulnerability-management]
  - name: platform-engineer
    description: 平台工程师，负责开发者体验
    skills: [developer-portal, internal-tools, documentation]
architecture: supervisor
dependencies:
  - devops-engineer -> sre-engineer
  - devops-engineer -> security-engineer
  - devops-engineer -> platform-engineer
"

# 游戏开发
DOMAIN_TEMPLATES[game]="
roles:
  - name: game-designer
    description: 游戏设计师，负责游戏机制和玩法设计
    skills: [game-mechanics, level-design, player-psychology]
  - name: game-programmer
    description: 游戏程序员，负责游戏逻辑和引擎
    skills: [unity, unreal, c-sharp, c-plus-plus]
  - name: game-artist
    description: 游戏美术师，负责视觉资产
    skills: [3d-modeling, animation, texture, shader]
  - name: game-audio
    description: 游戏音频师，负责音效和音乐
    skills: [sound-design, music-composition, audio-implementation]
  - name: game-qa
    description: 游戏测试工程师，负责游戏测试
    skills: [game-testing, bug-reporting, performance-testing]
architecture: pipeline
dependencies:
  - game-designer -> game-programmer
  - game-designer -> game-artist
  - game-designer -> game-audio
  - game-programmer -> game-qa
  - game-artist -> game-qa
"

# 区块链
DOMAIN_TEMPLATES[blockchain]="
roles:
  - name: blockchain-architect
    description: 区块链架构师，负责链上架构设计
    skills: [smart-contracts, consensus, tokenomics]
  - name: smart-contract-dev
    description: 智能合约开发工程师，负责合约开发
    skills: [solidity, rust, security-audit, testing]
  - name: dapp-developer
    description: DApp 开发工程师，负责去中心化应用
    skills: [web3js, ethers, frontend, wallet-integration]
  - name: blockchain-security
    description: 区块链安全专家，负责合约审计
    skills: [formal-verification, security-audit, vulnerability-detection]
architecture: producer-reviewer
dependencies:
  - blockchain-architect -> smart-contract-dev
  - smart-contract-dev -> dapp-developer
  - smart-contract-dev -> blockchain-security
"

# AI 应用
DOMAIN_TEMPLATES[ai]="
roles:
  - name: ai-engineer
    description: AI 工程师，负责 LLM 应用开发
    skills: [llm, prompt-engineering, rag, agents]
  - name: mlops-engineer
    description: MLOps 工程师，负责模型部署和运维
    skills: [model-serving, monitoring, scaling, cost-optimization]
  - name: data-engineer
    description: 数据工程师，负责数据准备和向量化
    skills: [data-pipeline, embedding, vector-db, data-quality]
  - name: ai-product-manager
    description: AI 产品经理，负责 AI 产品设计
    skills: [ai-strategy, user-experience, metrics, ethics]
architecture: expert-pool
dependencies:
  - ai-engineer -> mlops-engineer
  - data-engineer -> ai-engineer
  - ai-product-manager -> ai-engineer
"

# 电商
DOMAIN_TEMPLATES[ecommerce]="
roles:
  - name: ecommerce-manager
    description: 电商经理，负责业务策略和运营
    skills: [business-strategy, marketing, analytics]
  - name: frontend-developer
    description: 前端开发工程师，负责商城前端
    skills: [react, nextjs, performance, seo]
  - name: backend-developer
    description: 后端开发工程师，负责订单和支付系统
    skills: [microservices, payment, inventory, api]
  - name: ux-designer
    description: UX 设计师，负责购物体验设计
    skills: [user-research, conversion-optimization, a-b-testing]
  - name: data-analyst
    description: 数据分析师，负责销售数据分析
    skills: [analytics, reporting, forecasting]
architecture: pipeline
dependencies:
  - ecommerce-manager -> ux-designer
  - ux-designer -> frontend-developer
  - ecommerce-manager -> backend-developer
  - frontend-developer -> data-analyst
  - backend-developer -> data-analyst
"

# 生成角色配置
generate_role_config() {
  local domain="$1"
  local template="${DOMAIN_TEMPLATES[$domain]}"

  if [ -z "$template" ]; then
    echo "❌ 未知领域: $domain"
    echo "可用领域: ${!DOMAIN_TEMPLATES[*]}"
    return 1
  fi

  echo "🦞 正在为领域 '$domain' 生成角色配置..."
  echo ""
  echo "$template"
}

# 创建角色目录和文件
create_role_files() {
  local domain="$1"
  local template="${DOMAIN_TEMPLATES[$domain]}"

  if [ -z "$template" ]; then
    echo "❌ 未知领域: $domain"
    return 1
  fi

  echo "🦞 正在为领域 '$domain' 创建角色文件..."
  echo ""

  # 解析 YAML 并创建角色
  # 这里简化处理，实际应该用 yq 或类似工具
  local roles_dir="roles"
  mkdir -p "$roles_dir"

  # 根据领域创建示例角色
  case "$domain" in
    web)
      create_role "product-manager" "Senior Product Manager" "需求分析和产品规划"
      create_role "ui-designer" "Senior UI/UX Designer" "界面设计和用户体验"
      create_role "frontend-developer" "Senior Frontend Developer" "React/Vue 实现"
      create_role "backend-developer" "Senior Backend Developer" "API 和数据库设计"
      create_role "qa-engineer" "Senior QA Engineer" "质量保证"
      ;;
    mobile)
      create_role "product-manager" "Senior Product Manager" "移动端产品规划"
      create_role "mobile-designer" "Senior Mobile Designer" "iOS/Android 界面设计"
      create_role "ios-developer" "Senior iOS Developer" "Swift/SwiftUI 实现"
      create_role "android-developer" "Senior Android Developer" "Kotlin 实现"
      create_role "mobile-qa" "Senior Mobile QA" "设备兼容性测试"
      ;;
    data)
      create_role "data-analyst" "Senior Data Analyst" "数据探索和洞察"
      create_role "data-engineer" "Senior Data Engineer" "数据管道和 ETL"
      create_role "ml-engineer" "Senior ML Engineer" "模型训练和部署"
      create_role "data-scientist" "Senior Data Scientist" "高级分析和建模"
      ;;
    api)
      create_role "api-architect" "Senior API Architect" "API 设计和规范"
      create_role "backend-developer" "Senior Backend Developer" "API 实现"
      create_role "api-security" "API Security Expert" "安全审计和防护"
      create_role "api-docs" "API Documentation Engineer" "文档和 SDK"
      ;;
    ml)
      create_role "ml-researcher" "ML Researcher" "算法研究和实验"
      create_role "data-engineer" "Senior Data Engineer" "数据准备和特征工程"
      create_role "ml-engineer" "Senior ML Engineer" "模型训练和优化"
      create_role "mlops-engineer" "MLOps Engineer" "模型部署和监控"
      ;;
    devops)
      create_role "devops-engineer" "Senior DevOps Engineer" "基础设施和部署"
      create_role "sre-engineer" "Senior SRE Engineer" "可靠性和监控"
      create_role "security-engineer" "Security Engineer" "安全合规和审计"
      create_role "platform-engineer" "Platform Engineer" "开发者体验"
      ;;
    game)
      create_role "game-designer" "Senior Game Designer" "游戏机制和玩法设计"
      create_role "game-programmer" "Senior Game Programmer" "游戏逻辑和引擎"
      create_role "game-artist" "Senior Game Artist" "视觉资产"
      create_role "game-audio" "Senior Game Audio" "音效和音乐"
      create_role "game-qa" "Senior Game QA" "游戏测试"
      ;;
    blockchain)
      create_role "blockchain-architect" "Blockchain Architect" "链上架构设计"
      create_role "smart-contract-dev" "Smart Contract Developer" "合约开发"
      create_role "dapp-developer" "DApp Developer" "去中心化应用"
      create_role "blockchain-security" "Blockchain Security Expert" "合约审计"
      ;;
    ai)
      create_role "ai-engineer" "AI Engineer" "LLM 应用开发"
      create_role "mlops-engineer" "MLOps Engineer" "模型部署和运维"
      create_role "data-engineer" "Senior Data Engineer" "数据准备和向量化"
      create_role "ai-product-manager" "AI Product Manager" "AI 产品设计"
      ;;
    ecommerce)
      create_role "ecommerce-manager" "E-commerce Manager" "业务策略和运营"
      create_role "frontend-developer" "Senior Frontend Developer" "商城前端"
      create_role "backend-developer" "Senior Backend Developer" "订单和支付系统"
      create_role "ux-designer" "Senior UX Designer" "购物体验设计"
      create_role "data-analyst" "Senior Data Analyst" "销售数据分析"
      ;;
    *)
      echo "❌ 未知领域: $domain"
      return 1
      ;;
  esac

  echo ""
  echo "✅ 角色文件创建完成"
  echo ""
  echo "下一步："
  echo "  1. agent-hub role list       查看角色列表"
  echo "  2. agent-hub install all --global  安装所有角色"
}

# 创建单个角色create_role() {
  local name="$1"
  local title="$2"
  local description="$3"
  local role_dir="roles/$name"

  if [ -d "$role_dir" ]; then
    echo "⚠️  角色 '$name' 已存在，跳过"
    return 0
  fi

  mkdir -p "$role_dir"

  # 创建 SKILL.md
  cat > "$role_dir/SKILL.md" << EOF
---
name: $name
description: $title. $description.
---

# Role: $title

You are a $title. $description.

## 必备工具
- **markitdown**: 读取 PDF/Office/图片文档，提取文本内容。安装：\`pip install markitdown\`

## 加载顺序
1. \`.shared/rules/git-rules.md\` — Git 规范
2. \`.shared/rules/quality-rules.md\` — 质量底线
3. \`.shared/rules/security-rules.md\` — 安全底线
4. 本文件（角色指令）

## Input（你需要读取的文件）
| 文件 | 来源角色 | 是否必须 |
|------|---------|:---:|
| docs/current/requirements/PRD.md | PM | ✅ |
| docs/current/status.md | 所有角色 | ✅（检查依赖状态） |

## Output（你需要产出的文件）
| 文件 | 下游消费者 | 是否必须 |
|------|-----------|:---:|
| docs/current/status.md | 所有角色 | ✅（更新状态） |

## Core Principles
- 专注于自己的职责范围
- 与其他角色协作，不越界
- 保持代码和文档的质量

## Workflow

### Step 1: Read Requirements
Read PRD and user stories from \`docs/current/requirements/\`.

### Step 2: Execute Tasks
Execute your specific tasks based on your role.

### Step 3: Update Status
Update \`docs/current/status.md\`

## What You Do NOT Do
- 不做其他角色的工作
- 不修改其他角色的产出物
- 不跳过质量检查
EOF

  # 创建 role.yaml
  cat > "$role_dir/role.yaml" << EOF
name: $name
version: "1.0.0"
description: $title. $description.
author: agent-hub
tags:
  - $name
  - agent-hub
dependencies: []
EOF

  echo "✅ 创建角色: $name"
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
