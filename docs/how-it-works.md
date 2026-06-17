# 工作原理

## 阶段 1：平台检测

```
agent-hub detect
    ↓
扫描本地目录，检测已安装的 Agent 平台
    ↓
输出已检测平台列表
```

## 阶段 2：角色安装

```
agent-hub install pm --project
    ↓
读取 roles/pm/SKILL.md + rules/ + agents/ + .shared/
    ↓
复制到目标平台目录：
  → .claude/skills/pm/SKILL.md
  → .cursor/skills/pm/SKILL.md
  → ...
同时复制 .shared/rules/ 和 .shared/skills/
```

## 阶段 3：角色使用

```
用户新建会话
    ↓
AI 读取 SKILL.md
    ↓
按 Core Loading Order 加载规则 + 技能
    ↓
按任务域从 Expert Selection Guide 加载专家
    ↓
以该角色身份交互
```

## 选择性加载

- **Core Loading Order** — 始终加载（约 16-20k tokens）
- **Expert Selection Guide** — 按任务域选择 1-3 个专家（每个 ~1.5k tokens）
- **轻量模式** — 小任务跳过 dev-methodology skills

## Token 优化沿革

经过多轮优化，Frontend（最重角色）的 Core 从 ~25k tokens 降至 ~20k tokens。详见 [token-optimization.md](token-optimization.md)。
