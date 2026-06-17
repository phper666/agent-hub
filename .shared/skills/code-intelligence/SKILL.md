---
name: code-intelligence
description: Code intelligence tools (CodeGraph + code-review-graph) — structural code analysis, impact radius, dependency tracing. Trigger on: "install codegraph", "install code-review-graph", "trace callers", "impact analysis", "what depends on", "what tests are affected".
---

# Code Intelligence 最佳实践

> 两个互补工具：**CodeGraph**（日常开发，极简自动） + **code-review-graph**（深度审查，结构分析）
> Progressive Disclosure: SKILL.md (core) → references/role-guides.md (per-role) → references/tool-reference.md (cards)

## When to Load This Skill

| Role | Task Domain | Load? |
|------|------------|:-----:|
| Architect | Dependency tracing, refactor impact, arch audit | ✅ Load references/role-guides.md + references/tool-reference.md |
| Backend | API tracing, caller lookup, symbol search | ✅ Load references/role-guides.md |
| Frontend | Component deps, route mapping, symbol search | ✅ Load references/role-guides.md |
| QA | PR impact analysis, risk scoring, affected tests | ✅ Load full + references/installation.md |
| PM / Designer / Router / DD | All | ❌ Skip |

## 角色-工具矩阵

| 角色 | CodeGraph | code-review-graph | 原则 |
|------|:---:|:---:|------|
| **Architect** | ✅ 日常主力 | ⚠️ 深度审计时偶尔用 | 日常用 CG，重构审计才碰 crg |
| **Backend** | ✅ 日常主力 | ❌ | 追踪调用链 GC 足够 |
| **Frontend** | ✅ 日常主力 | ❌ | 组件依赖 GC 足够 |
| **QA** | ✅ 定位测试 | ✅ **审查核心引擎** | CG 找测试，crg 分析影响 |
| **其他** | ❌ | ❌ | 不碰代码 |

> 核心原则：**写代码用 CodeGraph，审代码靠 QA+code-review-graph**

## 安装

详见 → `references/installation.md`（AI 可直接执行其中命令）

## DO / DON'T

### ✅ DO
- CodeGraph 回答「这个代码怎么工作的」— Architect/Backend/Frontend
- code-review-graph 回答「改这个会有什么后果」— **仅 QA**
- PR 审查四层并用：标准 → 结构分析(crg) → 多视角 → 工作流

### ❌ DON'T
- ❌ Backend/Frontend 不要碰 code-review-graph
- ❌ 不要用 crg 替代 open-code-review 检查清单
- ❌ 不要跳过结构分析直接贴 PR 评论
- ❌ PR 审查只看 diff 不追踪依赖
