# 项目结构

```
agent-hub/
├── agent-hub                 # CLI 入口
├── agent-hub.yaml            # 项目配置
├── lib/                      # CLI 模块
│   ├── common.sh             # 公共函数
│   ├── detect.sh             # 平台检测（9 个平台）
│   ├── install.sh            # 安装/卸载/更新
│   ├── role.sh               # 角色管理
│   ├── generate.sh           # 领域模板生成
│   └── pipeline.sh           # 流水线状态
├── roles/                    # 内置角色（8 个）
│   ├── pm/
│   ├── designer/
│   ├── architect/
│   ├── frontend/
│   ├── backend/
│   ├── qa/
│   ├── router/
│   └── delivery-director/
│   Each: SKILL.md + role.yaml + agents/ + rules/
├── .shared/                  # 全局共享
│   ├── rules/                # 6 个共享规则
│   ├── skills/               # 13 个共享技能
│   └── templates/            # 共享模板
├── docs/                     # 文档
├── templates/                # 角色模板（agent-hub generate）
└── tests/                    # 测试
```
