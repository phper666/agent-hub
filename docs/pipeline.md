# DAG 流水线

## 角色依赖图

```
PM          → depends_on: []               → after: [designer]
Designer    → depends_on: [pm]             → after: [architect]
Architect   → depends_on: [pm, designer]   → after: [backend, frontend]
Backend     → depends_on: [architect]      → after: [qa]
Frontend    → depends_on: [architect]      → after: [qa]
QA          → depends_on: [backend, frontend] → after: [delivery-director]
Delivery Director → orchestrates all, reports to CEO
```

## 选择性加载

每个 SKILL.md 将加载分为两部分：
- **Core Loading Order** — 始终加载的规则 + 技能（约 16-20k tokens）
- **Expert Selection Guide** — 按任务域选择 1-3 个 Expert（每个 ~1.5k tokens）

## 使用方式

### 全流程（新项目）

```
PM → Designer → Architect → [Backend + Frontend] → QA → DD
```

推荐用 Delivery Director 作为入口，由它调度整个流水线。

### 单角色（日常开发）

大部分场景只激活 1-2 个角色：

```bash
agent-hub install backend --project    # 只装后端
agent-hub install frontend --project   # 只装前端
```

### 协同工作流

```
PM 用 spec-kit 定义规格
    ↓
Designer 用 taste-skill 设计界面
    ↓
Architect 用 agency-agents + Rules 2.1 设计架构
    ↓
Backend / Frontend 用 superpowers + CodeGraph 并行开发
    ↓
QA 用 code-review-graph 影响分析 + Smart Routing 测试
    ↓
Delivery Director 调度全团 → CEO Brief
```

## 注意事项

- `depends_on` 和 `after_complete` 是推荐流，不强制
- `pipeline status` 只读 status.md，不自动调度
- 可以跳过任意上游角色，直接使用下游角色
