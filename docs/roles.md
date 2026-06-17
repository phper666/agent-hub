# 内置角色

Agent Hub 内置 8 个角色，覆盖软件开发全流程。

| 角色 | Emoji | 描述 |
|------|:----:|------|
| **pm** | 🤖 | 产品经理 — 需求分析、PRD、用户故事 |
| **designer** | 🎨 | UI/UX 设计师 — 界面、原型、设计系统 |
| **architect** | 🏛️ | 软件架构师 — 系统设计、API Spec、技术选型 |
| **frontend** | 💻 | 前端工程师 — React/Vue/Angular、组件开发 |
| **backend** | ⚙️ | 后端工程师 — API、数据库、服务端 |
| **qa** | 🧪 | 测试工程师 — 测试计划、质量保障 |
| **router** | 🔀 | 角色路由 — 自动检测任务类型并切换角色 |
| **delivery-director** | 📋 | 交付总监 — CEO 唯一对接人，调度全团 |

## 共享规则

| 文件 | 内容 |
|------|------|
| `git-rules.md` | Git 提交规范、分支管理、PR 标准 |
| `quality-rules.md` | 代码质量标准、测试覆盖率、CI/CD 要求 |
| `security-rules.md` | 安全编码、输入校验、认证授权 |
| `output-rules.md` | 输出格式规范、Token 优化（基于 headroom） |
| `code-standards.md` | KISS/DRY/YAGNI 原则、文件组织、命名约定（基于 ECC） |
| `code-review-rules.md` | 代码审查规范、四层优先级链（基于 open-code-review） |

## 共享技能（13 项）

详见 `.shared/skills/`。每个技能含 `## When to Load This Skill` 门控表，按角色+任务域自动激活。

## DAG 流水线

```
PM → Designer → Architect → [Backend + Frontend] → QA → Delivery Director
```

> 流水线是推荐工作流，不是硬编码调度器。单角色独立使用完全正常。

详见 [pipeline.md](pipeline.md)
