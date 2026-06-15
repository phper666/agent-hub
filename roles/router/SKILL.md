---
name: role-router
description: Auto-detect which agent role to activate based on file paths, task keywords, and project phase. Use at the start of every session or when the user's task is ambiguous.
---

# 🤖 Auto-Detection Role Router

## How It Works

When activated, this skill analyzes the current context and automatically selects the right agent role.

## Detection Rules (in priority order)

### Rule 1: Explicit Override (Highest Priority)
If the user says any of these, use the specified role immediately:
- "切换到 PM" / "你是产品经理" / "用 PM Agent" → **PM**
- "切换到设计" / "你是设计师" / "用 Designer Agent" → **Designer**
- "切换到前端" / "你是前端开发" / "用 Frontend Agent" → **Frontend**
- "切换到后端" / "你是后端开发" / "用 Backend Agent" → **Backend**
- "切换到测试" / "你是 QA" / "用 QA Agent" → **QA**

### Rule 2: File Path Detection
Based on which files the user is working with:

| File Pattern | Role | Load |
|-------------|------|------|
| `docs/requirements/*` | PM | `.agents/product-manager/AGENTS.md` |
| `docs/design/*` | Designer | `.agents/designer/AGENTS.md` |
| `*.tsx`, `*.jsx`, `*.vue`, `*.svelte`, `src/frontend/**` | Frontend | `.agents/frontend-dev/AGENTS.md` |
| `*.go`, `*.java`, `*.py`, `src/backend/**`, `*.sql`, `*.graphql` | Backend | `.agents/backend-dev/AGENTS.md` |
| `*.test.*`, `*.spec.*`, `tests/**`, `*.e2e.*` | QA | `.agents/qa-engineer/AGENTS.md` |
| `.github/workflows/*`, `Dockerfile`, `docker-compose.*` | Backend (DevOps) | `.agents/backend-dev/AGENTS.md` |

### Rule 3: Task Keyword Detection
Based on what the user is asking to do:

| Keywords (any match) | Role |
|---------------------|------|
| 需求, PRD, 用户故事, 功能, 产品, 用户画像, 验收标准 | **PM** |
| 原型, UI, 设计, 界面, 组件规范, 配色, 布局, 交互, 样式 | **Designer** |
| 前端, 页面, 组件, React, Vue, CSS, 响应式, Tailwind, 路由 | **Frontend** |
| 后端, API, 数据库, 接口, 迁移, SQL, 服务端, 认证, 中间件 | **Backend** |
| 测试, bug, E2E, 集成测试, 覆盖率, 质量, 断言, mock | **QA** |
| PR, review, 合并, 部署, CI, CD, Docker | **Backend (DevOps)** |

### Rule 4: Project Phase Detection
Based on what documents already exist:

```
No PRD exists yet                          → Suggest: PM
PRD exists, no prototype                   → Suggest: Designer
Prototype exists, no API spec              → Suggest: Backend (design API)
API spec exists, no backend code           → Suggest: Backend (implement)
Backend exists, no frontend code           → Suggest: Frontend
Both exist, no tests                       → Suggest: QA
Tests exist, no PR                         → Suggest: Create PR
```

## Multi-Role Tasks

For tasks that span multiple roles (e.g., "implement user login"):
1. Identify the **primary role** (the one doing the most work)
2. List **dependent roles** (what else needs to happen)
3. Execute in dependency order
4. Hand off via `docs/` documents

Example: "实现用户登录功能"
- Primary: Backend (implement API)
- Dependent: Frontend (build login form) → QA (write tests)
- Order: Backend → Frontend → QA

## Output

When a role is selected:
1. Load the role's `SKILL.md`
2. Apply all shared rules from `.shared/rules/`
3. Announce the role: "🤖 已切换到 **Backend Developer** 角色"
4. List active rules: "📋 已加载规则: git-rules.md, quality-rules.md, security-rules.md, output-rules.md"
5. Begin executing the task

## 必备工具（所有角色共享）
- **markitdown**: 读取 PDF/Office/图片文档，提取文本内容。安装：`pip install markitdown`
