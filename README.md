# 🦞 Agent Hub — AI 角色包管理器

**像 npm 管理 Node.js 包一样，管理 AI Agent 的角色和技能。**

一次定义角色，安装到所有主流 AI Agent 平台。支持 Reasonix、Qoder、Claude、Cursor、WorkBuddy、Codex、Gemini。

---

## 它是什么

Agent Hub 解决的问题：你有多个 AI Agent 平台（Reasonix、Qoder、Claude 等），每个平台都有自己的角色/技能目录结构。如果你想让所有平台都有一个"产品经理"角色，你需要手动把 SKILL.md 复制到每个平台的目录里，格式还不一样。

Agent Hub 帮你自动化这件事：

```
你定义角色（SKILL.md）
    ↓
agent-hub install pm --global
    ↓
自动写入所有已检测平台的正确目录
    ↓
打开任意 Agent，直接使用该角色
```

---

## 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/your-username/agent-hub.git
cd agent-hub
chmod +x agent-hub
```

### 2. 添加到 PATH（可选）

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
export PATH="$PATH:/path/to/agent-hub"

# 然后就可以在任意目录使用
agent-hub help
```

### 3. 检测已安装的 Agent

```bash
agent-hub detect

# 输出：
# ✅ reasonix
# ✅ qoder
# ✅ claude
# ✅ cursor
# ✅ workbuddy
# ✅ codex
# ✅ gemini
# ✅ 检测到 7 个平台
```

### 4. 安装角色到项目

```bash
cd your-project/

# 安装所有角色到当前项目
agent-hub install all --project

# 只安装 PM 角色到指定平台
agent-hub install pm --project --to reasonix,claude

# 全局安装（所有项目都能用）
agent-hub install all --global
```

### 5. 使用角色

安装后，在对应的 Agent 里新建会话，输入角色关键词即可激活：

```
Reasonix / Qoder / Claude 中：
  用户：切换到产品经理
  Agent：已切换到产品经理角色，加载规则：git-rules, quality-rules
  用户：帮我分析这个需求...
  Agent：（以产品经理的身份和能力回答）
```

---

## 全部命令

### 初始化

```bash
agent-hub init                    # 在当前目录创建角色目录结构
```

### 平台检测

```bash
agent-hub detect                  # 检测本地已安装的 Agent 平台
```

### 角色管理

```bash
agent-hub role list               # 列出所有角色（显示名称、描述、状态）
agent-hub role create <name>      # 创建角色模板（生成 SKILL.md 骨架）
agent-hub role edit <name>        # 用编辑器打开角色的 SKILL.md
agent-hub role delete <name>      # 删除角色
agent-hub role info <name>        # 查看角色详情
```

### 安装 / 卸载 / 更新

```bash
# 项目级安装（只在当前项目生效）
agent-hub install pm --project
agent-hub install all --project
agent-hub install pm --project --to reasonix,claude

# 全局安装（所有项目都能用）
agent-hub install pm --global
agent-hub install all --global

# 卸载
agent-hub uninstall pm --project
agent-hub uninstall all --global

# 更新（卸载 + 重装）
agent-hub update pm --project
agent-hub update all --global
```

### 导入 / 导出

```bash
# 从其他项目导入角色
agent-hub import /path/to/skills-install-sh

# 导出单个角色
agent-hub export pm
agent-hub export pm --output pm.yaml
```

### 依赖管理

```bash
agent-hub deps install            # 安装依赖（markitdown 等）
agent-hub deps list               # 列出依赖
```

### 流水线状态

```bash
agent-hub pipeline status         # 查看各角色的完成状态
agent-hub pipeline reset          # 重置状态
```

### 升级

```bash
agent-hub upgrade                 # 检查并升级 agent-hub 自身
```

---

## 内置角色

| 角色 | Emoji | 描述 |
|------|-------|------|
| **pm** | 🤖 | 产品经理 — 需求分析、PRD、用户故事 |
| **designer** | 🎨 | UI/UX 设计师 — 界面设计、原型、组件规范 |
| **frontend** | 💻 | 前端工程师 — React/Vue/Angular 组件、页面、状态管理 |
| **backend** | ⚙️ | 后端工程师 — API、数据库、服务端、认证 |
| **qa** | 🧪 | 测试工程师 — 测试计划、集成测试、E2E 测试、质量保障 |
| **router** | 🔀 | 角色路由 — 自动检测当前任务应该切换到哪个角色 |

每个角色包含：
- `SKILL.md` — 角色人设和工作流程
- `rules/` — 角色专属规则
- `agents/` — 子角色定义
- `.shared/rules/` — 全局共享规则（安装时自动注入）

---

## 共享规则

所有角色安装时自动注入以下全局规则：

| 规则文件 | 内容 |
|---------|------|
| `git-rules.md` | Git 提交规范、分支管理、PR 标准 |
| `quality-rules.md` | 代码质量标准、测试覆盖率、代码审查 |
| `security-rules.md` | 安全编码规范、输入校验、认证授权 |
| `output-rules.md` | 输出格式规范、简洁原则、状态标记 |

---

## 创建自定义角色

```bash
# 创建角色模板
agent-hub role create my-role

# 编辑 SKILL.md
agent-hub role edit my-role
```

生成的 `roles/my-role/SKILL.md`：

```yaml
---
name: my-role
description: TODO: 一句话描述这个角色的职责。
---

# Role: my-role

你是一个 TODO（填写角色名）。

## Core Principles
- TODO: 列出核心原则

## Workflow

### Step 1: TODO
TODO: 描述工作流程

## 你不能做的事
- TODO: 列出限制
```

---

## 项目结构

```
agent-hub/
├── agent-hub                     # CLI 入口（Bash）
├── agent-hub.yaml                # 项目配置
├── README.md
├── lib/
│   ├── detect.sh                 # 平台检测模块
│   ├── install.sh                # 安装/卸载/更新/升级模块
│   ├── role.sh                   # 角色管理/导入/导出模块
│   └── pipeline.sh               # 流水线状态模块
├── roles/
│   ├── pm/SKILL.md               # 产品经理
│   ├── designer/SKILL.md         # UI/UX 设计师
│   ├── frontend/SKILL.md         # 前端工程师
│   ├── backend/SKILL.md          # 后端工程师
│   ├── qa/SKILL.md               # 测试工程师
│   └── router/SKILL.md           # 角色路由
├── .shared/
│   └── rules/
│       ├── git-rules.md
│       ├── quality-rules.md
│       ├── security-rules.md
│       └── output-rules.md
├── templates/                    # 角色模板
└── tests/                        # 测试
```

---

## 支持平台

| 平台 | 检测方式 | 全局安装路径 | 项目安装路径 |
|------|---------|-------------|-------------|
| **Reasonix** | 目录检测 | `~/Library/Application Support/reasonix/skills` | `.reasonix/skills` |
| **Qoder** | 目录检测 | `~/.qoder/skills` | `.qoder/skills` |
| **Claude** | 目录检测 | `~/.claude/skills` | `.claude/skills` |
| **Cursor** | 目录检测 | `~/.cursor/skills` | `.cursor/skills` |
| **WorkBuddy** | 目录检测 | `~/.workbuddy/skills` | `.workbuddy/skills` |
| **Codex** | 目录检测 | `~/.codex/skills` | `.codex/skills` |
| **Gemini** | 目录检测 | `~/.gemini/skills` | `.gemini/skills` |

---

## 工作原理

```
1. agent-hub detect
   扫描本地目录，检测哪些 Agent 平台已安装

2. agent-hub install pm --project
   读取 roles/pm/SKILL.md
   → 复制到 .reasonix/skills/pm/SKILL.md
   → 复制到 .qoder/skills/pm/SKILL.md
   → 复制到 .claude/skills/pm/SKILL.md
   → ...（所有检测到的平台）
   同时复制 rules/、agents/、.shared/rules/

3. 用户在 Agent 中使用
   Agent 读取 SKILL.md → 加载角色人设 → 以该角色身份工作
```

---

## 许可证

MIT License

---

## 致谢

角色定义格式参考 [skills-install-sh](https://github.com/your-username/skills-install-sh) 项目。
