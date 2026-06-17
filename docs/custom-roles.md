# 创建自定义角色

## 使用命令

```bash
agent-hub role create my-role     # 创建角色模板
agent-hub role edit my-role       # 编辑 SKILL.md
```

## SKILL.md 模板

```markdown
---
name: my-role
description: Senior My Role. Description.
depends_on: []
after_complete: []
---

# Role Framework: My Role

## Core Loading Order (Always Loaded)
1. `.shared/rules/git-rules.md` — Git conventions
2. `.shared/rules/quality-rules.md` — Quality standards
3. `.shared/rules/security-rules.md` — Security standards
4. `.shared/rules/output-rules.md` — Concise output
5. This file

## Expert Selection Guide (Context-Dependent)
| Task Domain | Load | File |
|------------|------|------|
| Domain expertise | My Expert | `agents/agency/my-expert.md` |

## Input
| File | Source | Required |
|------|--------|:--------:|
| docs/current/status.md | All roles | ✅ |

## Output
| File | Consumer | Required |
|------|----------|:--------:|
| docs/current/status.md | All roles | ✅ |
```

## 安装

```bash
agent-hub install my-role --project
agent-hub install my-role --global
agent-hub install my-role --project --to claude,cursor
```

## 最佳实践

1. **设置 depends_on / after_complete** — 声明上下游依赖
2. **定义 Expert Selection Guide** — 按任务域列表，防止 Token 爆炸
3. **定义 Input / Output** — 明确文件交接接口
4. **定义 Workflow** — Step 1 → 2 → 3 格式
5. **定义边界** — "What You Do NOT Do" 越清晰，角色越专注
