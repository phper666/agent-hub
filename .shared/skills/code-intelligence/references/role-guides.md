# Code Intelligence 角色使用指南

> 按需加载。角色 SKILL.md 的 Expert Selection Guide 决定何时加载本文件。

---

## Architect（架构师）— 主力：CodeGraph

| 场景 | 工具 | 命令/操作 |
|------|------|----------|
| 了解项目结构 | CodeGraph | `codegraph_explore` |
| 追踪调用链 | CodeGraph | `codegraph_callers` / `codegraph_callees` ⚠️（callees 默认隐藏） |
| 评估重构影响 ⚠️ | code-review-graph | `get_impact_radius` — 仅大型重构 |
| 发现架构瓶颈 ⚠️ | code-review-graph | `get_hub_nodes` / `get_bridge_nodes` — 仅深度审计 |
| 架构可视化 ⚠️ | code-review-graph | `code-review-graph visualize` |

## Backend（后端开发）— 主力：CodeGraph

| 场景 | 工具 | 命令/操作 |
|------|------|----------|
| 追踪 API → Handler | CodeGraph | `codegraph_explore`（Django/Spring/Rails 等 17 框架） |
| 改函数前查调用者 | CodeGraph | `codegraph_callers <函数名>` |
| 查询符号定义 | CodeGraph | `codegraph_search <符号名>` |

## Frontend（前端开发）— 主力：CodeGraph

| 场景 | 工具 | 命令/操作 |
|------|------|----------|
| 查组件依赖 | CodeGraph | `codegraph_callers <组件名>` |
| 路由→页面映射 | CodeGraph | `codegraph_explore`（React Router/Nuxt/SvelteKit 等） |
| 查询符号定义 | CodeGraph | `codegraph_search <符号名>` |

## QA（测试工程师）— 主力：code-review-graph

| 场景 | 工具 | 命令/操作 |
|------|------|----------|
| 精准定位测试文件 | CodeGraph | `codegraph affected src/utils.ts --quiet` |
| PR 结构分析 🔥 | code-review-graph | `detect_changes` — 影响半径 + 风险评分 |
| 执行流影响 🔥 | code-review-graph | `get_affected_flows` |
| 架构热点检测 🔥 | code-review-graph | `get_hub_nodes` / `get_bridge_nodes` |
| 意外耦合检查 🔥 | code-review-graph | `get_surprising_connections` |
| 知识缺口扫描 🔥 | code-review-graph | `get_knowledge_gaps` |
| CI 集成 | CodeGraph | `git diff --name-only HEAD \| codegraph affected --stdin --quiet \| xargs pytest` |

---

## QA 四层审查流程

```
PR 来了，QA 触发 →
  Layer 1: open-code-review 检查清单（安全/质量/规范/测试）
  Layer 2: code-review-graph 结构分析（检测变更 → 影响半径 + 风险评分）
  Layer 3: Rules 2.1 多视角审查（开发者 + 架构 + 安全 + 性能）
  Layer 4: pr-agent 工作流交付（/describe → /review → PR 评论）
```
