# 🦞 Agent Hub — AI 角色包管理器

**像 npm 管理 Node.js 包一样，管理 AI Agent 的角色和技能。**

Agent Hub 是一个 AI 角色包管理器，让你一次定义角色，即可安装到所有主流 AI Agent 平台（Reasonix、Qoder、Claude、Cursor、WorkBuddy、Codex、Gemini），免去手动复制和格式适配的烦恼。

---

## 目录

- [功能特性](#功能特性)
- [快速开始](#快速开始)
- [全部命令](#全部命令)
- [内置角色](#内置角色)
- [共享规则](#共享规则)
- [集成项目](#集成项目)
- [支持平台](#支持平台)
- [项目结构](#项目结构)
- [创建自定义角色](#创建自定义角色)
- [工作原理](#工作原理)
- [多平台支持](#多平台支持)
- [免责声明](#免责声明)
- [致谢](#致谢)
- [联系方式](#联系方式)

---

## 功能特性

- 🔍 **自动检测平台** — 自动扫描本地已安装的 AI Agent 平台，无需手动配置
- 📦 **一键安装角色** — 将角色同时部署到所有已检测平台的正确目录
- 🎯 **项目级 / 全局安装** — 支持仅当前项目生效或所有项目共享两种模式
- 🎭 **6 个内置角色** — 开箱即用的产品经理、设计师、前端、后端、测试、路由角色
- 📐 **4 套共享规则** — Git 规范、质量标准、安全编码、输出格式自动注入所有角色
- 🔌 **集成 6 个开源项目** — 深度集成 markitdown、ECC、taste-skill、headroom、harness、supermemory
- 🏭 **领域模板生成** — 支持 10 个领域（Web、Mobile、Data、API、ML、DevOps 等）一键生成角色配置
- 📤 **导入 / 导出** — 支持从其他项目导入角色，或导出角色为 YAML 分享
- 🔄 **流水线状态** — 追踪各角色的工作完成状态
- 🐧 **跨平台支持** — 完整支持 Linux、macOS、Windows（Git Bash / WSL）

---

## 快速开始

### 1. 安装 Agent Hub

#### 一键安装（推荐）

```bash
# Linux / macOS / Windows (Git Bash / WSL)
curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/install.sh | bash
```

安装脚本会自动：
- 克隆仓库到 `~/.agent-hub`
- 创建符号链接到 `~/.local/bin/agent-hub`
- 配置 `PATH` 环境变量

#### 手动安装

```bash
git clone https://github.com/phper666/agent-hub.git ~/.agent-hub
cd ~/.agent-hub
chmod +x agent-hub

# 添加到 PATH（根据你的 shell 选择）
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc   # bash
# echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.zshrc  # zsh
source ~/.bashrc
```

#### 卸载

```bash
curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/uninstall.sh | bash
```

### 2. 检测已安装的 Agent 平台

```bash
agent-hub detect

# 输出示例：
# ✅ reasonix
# ✅ qoder
# ✅ claude
# ✅ cursor
# ✅ workbuddy
# ✅ codex
# ✅ gemini
# ✅ 检测到 7 个平台
```

### 3. 初始化项目（可选）

```bash
cd your-project/
agent-hub init
```

这会在当前目录创建角色目录结构和配置文件 `agent-hub.yaml`。

### 4. 安装角色

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

安装完成后，在对应的 Agent 中新建会话，输入角色关键词即可激活：

```
用户：切换到产品经理
Agent：已切换到产品经理角色，加载规则：git-rules, quality-rules
用户：帮我分析这个需求...
Agent：（以产品经理的身份和能力回答）
```

---

## 全部命令

### 初始化

```bash
agent-hub init                                  # 在当前目录创建角色目录结构
```

### 平台检测

```bash
agent-hub detect                                # 检测本地已安装的 Agent 平台
```

### 角色管理

```bash
agent-hub role list                             # 列出所有角色（显示名称、描述、状态）
agent-hub role create <name>                    # 创建角色模板（生成 SKILL.md 骨架）
agent-hub role edit <name>                      # 用编辑器打开角色的 SKILL.md
agent-hub role delete <name>                    # 删除角色
agent-hub role info <name>                      # 查看角色详情
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

# 升级 agent-hub 自身
agent-hub upgrade
```

### 导入 / 导出

```bash
# 从其他项目导入角色
agent-hub import /path/to/role-directory

# 导出单个角色
agent-hub export pm
agent-hub export pm --output pm.yaml
```

### 领域生成

```bash
# 根据领域自动生成角色配置
agent-hub generate web              # Web 开发
agent-hub generate mobile           # 移动端开发
agent-hub generate data             # 数据分析
agent-hub generate api              # API 开发
agent-hub generate ml               # 机器学习
agent-hub generate devops           # DevOps
agent-hub generate game             # 游戏开发
agent-hub generate blockchain       # 区块链
agent-hub generate ai               # AI 应用
agent-hub generate ecommerce        # 电商
```

### 依赖管理

```bash
agent-hub deps install              # 安装依赖（markitdown 等）
agent-hub deps list                 # 列出依赖
```

### 流水线状态

```bash
agent-hub pipeline status           # 查看各角色的完成状态
agent-hub pipeline reset            # 重置状态
```

### 辅助

```bash
agent-hub version                   # 版本信息
agent-hub help                      # 显示帮助
```

---

## 内置角色

| 角色 | Emoji | 描述 | 子角色 |
|------|-------|------|--------|
| **pm** | 🤖 | 产品经理 — 需求分析、PRD、用户故事、产品规划 | — |
| **designer** | 🎨 | UI/UX 设计师 — 界面设计、原型、组件规范、设计系统 | `ui-designer` |
| **frontend** | 💻 | 前端工程师 — React/Vue/Angular 组件、页面、状态管理 | `frontend-developer` |
| **backend** | ⚙️ | 后端工程师 — API、数据库、服务端、认证、迁移 | `backend-architect`、`database-optimizer` |
| **qa** | 🧪 | 测试工程师 — 测试计划、集成测试、E2E 测试、质量保障 | `code-reviewer` |
| **router** | 🔀 | 角色路由 — 根据文件路径、任务关键词、项目阶段自动检测并切换角色 | — |

每个角色包含：

```
roles/<角色名>/
├── SKILL.md              # 角色人设、工作流、输入/输出定义
├── role.yaml             # 角色元数据配置
├── rules/                # 角色专属规则（可选）
└── agents/               # 子角色定义（可选）
```

---

## 共享规则

所有角色在安装时会自动注入以下全局共享规则：

| 规则文件 | 内容概述 | 来源 |
|---------|---------|------|
| `git-rules.md` | Git 提交规范（Conventional Commits）、分支管理、PR 标准、代码审查流程 | 原创 |
| `quality-rules.md` | 代码质量标准、测试覆盖率（≥80%）、代码审查规范、CI/CD 要求 | 原创 |
| `security-rules.md` | 安全编码规范、输入校验、认证授权、数据保护、API 安全 | 原创 |
| `output-rules.md` | 输出格式规范、简洁原则、状态标记、Token 优化技巧 | 基于 [headroom](https://github.com/chopratejas/headroom) |
| `code-standards.md` | KISS/DRY/YAGNI 原则、文件组织、错误处理、命名约定、测试要求（TDD） | 基于 [ECC](https://github.com/affaan-m/ECC) |

> 共享规则位于 `.shared/rules/` 目录，优先级低于角色专属规则。

---

## 集成项目

Agent Hub 集成了以下高质量开源项目，增强角色能力。所有集成项目版权归原作者所有，Agent Hub 仅作集成使用。

### 1. markitdown

| 属性 | 说明 |
|------|------|
| **项目地址** | https://github.com/microsoft/markitdown |
| **Stars** | 146.5k+ |
| **许可证** | MIT License |
| **集成方式** | 必备工具（所有角色的 SKILL.md 中声明依赖） |
| **用途** | 读取 PDF、Office 文档（Word/Excel/PPT）、图片等格式，提取纯文本内容 |
| **集成内容** | 作为所有角色的基础工具，用于读取需求文档、设计规范、参考资料等 |
| **集成位置** | `roles/*/SKILL.md`（所有角色） |

**安装方式**：

```bash
pip install markitdown
```

**使用场景**：
- PM 读取 PDF 格式的需求文档
- Designer 读取设计规范和品牌手册
- 所有角色读取参考资料和技术文档

---

### 2. superpowers（159k+ stars）

| 属性 | 说明 |
|------|------|
| **项目地址** | https://github.com/jnMetaCode/superpowers-zh（中文增强版） |
| **Stars** | 159k+（原版）/ 5.4k+（中文版） |
| **许可证** | MIT License |
| **集成方式** | 按角色独立集成（每个角色有自己的 skills 目录） |
| **用途** | AI 编程工作流方法论，提供系统化的开发最佳实践 |
| **集成内容** | 4 个核心 skills：test-driven-development（TDD）、systematic-debugging（系统化调试）、verification-before-completion（完成前验证）、subagent-driven-development（子 Agent 驱动开发） |
| **集成位置** | `roles/<role>/skills/`（按角色独立组织） |

**按角色分配**：

| 角色 | 集成的 Skills |
|------|--------------|
| **Designer** | — |
| **Frontend** | test-driven-development, subagent-driven-development, systematic-debugging |
| **Backend** | test-driven-development, subagent-driven-development, systematic-debugging |
| **QA** | test-driven-development, systematic-debugging, verification-before-completion |

**设计理念**：
- 每个角色只加载自己需要的 skills
- 避免所有角色共享同一套 skills（减少上下文污染）
- 按职责分离，提高专业性

---

### 3. ECC（Exceptional Coding Conventions）

| 属性 | 说明 |
|------|------|
| **项目地址** | https://github.com/affaan-m/ECC |
| **Stars** | 216k+ |
| **许可证** | MIT License |
| **集成方式** | 共享规则（`code-standards.md`） |
| **用途** | 代码规范和最佳实践指南 |
| **集成内容** | 核心原则（KISS、DRY、YAGNI）、不可变性原则、文件组织规范（≤800行/文件、≤50行/函数）、错误处理规范、输入验证规范、命名约定（camelCase/PascalCase/UPPER_SNAKE_CASE）、代码异味检查清单、Git 工作流、测试要求（TDD、80% 覆盖率、AAA 模式） |
| **集成位置** | `.shared/rules/code-standards.md` |

---

### 3. taste-skill

| 属性 | 说明 |
|------|------|
| **项目地址** | https://github.com/Leonxlnx/taste-skill |
| **Stars** | 44k+ |
| **许可证** | MIT License |
| **集成方式** | 角色专属规范（嵌入 Designer 和 Frontend 角色） |
| **用途** | UI 品位规范，防止 AI 生成千篇一律、缺乏设计感的界面 |
| **集成内容** | Brief Inference（先读房间，理解上下文）、Three Dials 三旋钮调节系统（`DESIGN_VARIANCE` 布局实验性 / `MOTION_INTENSITY` 动画深度 / `VISUAL_DENSITY` 信息密度）、Anti-Slop Rules（反平庸规则）、Pre-flight Checklist（完成前检查清单） |
| **集成位置** | `roles/designer/SKILL.md`、`roles/frontend/SKILL.md` |

---

### 4. headroom

| 属性 | 说明 |
|------|------|
| **项目地址** | https://github.com/chopratejas/headroom |
| **Stars** | 28k+ |
| **许可证** | Apache-2.0 License |
| **集成方式** | 共享规则（增强 `output-rules.md`） |
| **用途** | 精简输出规范，减少 60%–95% 的 Token 消耗 |
| **集成内容** | Token 优化原则、输出压缩技巧、状态报告格式、代码输出规范、文档输出规范、交互优化建议、Token 节省检查清单 |
| **集成位置** | `.shared/rules/output-rules.md` |

---

### 5. harness

| 属性 | 说明 |
|------|------|
| **项目地址** | https://github.com/revfactory/harness |
| **Stars** | 7k+ |
| **许可证** | Apache-2.0 License |
| **集成方式** | CLI 命令（`generate` 子命令） |
| **用途** | 根据开发领域自动生成角色配置和团队架构 |
| **集成内容** | 10 个领域的角色模板（web / mobile / data / api / ml / devops / game / blockchain / ai / ecommerce）、6 种团队架构模式（Pipeline 流水线 / Fan-out/Fan-in 扇出扇入 / Expert Pool 专家池 / Producer-Reviewer 生产者审查者 / Supervisor 监督者 / Hierarchical Delegation 层级委托） |
| **集成位置** | `lib/generate.sh` |

**使用方式**：

```bash
agent-hub generate web       # 生成 Web 开发领域的角色配置
agent-hub generate mobile    # 生成移动端开发领域的角色配置
```

---

### 6. supermemory

| 属性 | 说明 |
|------|------|
| **项目地址** | https://github.com/supermemoryai/supermemory |
| **Stars** | 27k+ |
| **许可证** | MIT License |
| **集成方式** | 共享技能（`memory-guide.md`） |
| **用途** | 记忆管理指南，让 AI 在对话间保持记忆，构建持久化上下文 |
| **集成内容** | 记忆类型定义（静态事实 / 动态上下文 / 项目上下文）、记忆管理原则（自动提取、时间感知、自动遗忘、矛盾解决）、实践指南（会话开始/中/结束）、记忆存储格式（Markdown / YAML）、MCP Server / API 工具推荐 |
| **集成位置** | `.shared/skills/memory-guide.md` |

---

### 集成方式汇总

| 集成项目 | 集成方式 | 影响范围 | 文件位置 |
|---------|---------|---------|---------|
| markitdown | 必备工具 | 所有角色 | `roles/*/SKILL.md` |
| superpowers | 按角色独立集成 | Designer、Frontend、Backend、QA | `roles/<role>/skills/` |
| ECC | 共享规则 | 所有角色 | `.shared/rules/code-standards.md` |
| taste-skill | 角色专属规范 | Designer、Frontend | `roles/designer/SKILL.md`、`roles/frontend/SKILL.md` |
| headroom | 共享规则 | 所有角色 | `.shared/rules/output-rules.md` |
| harness | CLI 命令 | 新角色生成 | `lib/generate.sh` |
| supermemory | 共享技能 | 所有角色 | `.shared/skills/memory-guide.md` |

---

## 支持平台

### AI Agent 平台

| 平台 | 检测方式 | 全局安装路径 | 项目安装路径 |
|------|---------|-------------|-------------|
| **Reasonix** | 目录检测 | `~/Library/Application Support/reasonix/skills` | `.reasonix/skills` |
| **Qoder** | 目录检测 | `~/.qoder/skills` | `.qoder/skills` |
| **Claude** | 目录检测 | `~/.claude/skills` | `.claude/skills` |
| **Cursor** | 目录检测 | `~/.cursor/skills` | `.cursor/skills` |
| **WorkBuddy** | 目录检测 | `~/.workbuddy/skills` | `.workbuddy/skills` |
| **Codex** | 目录检测 | `~/.codex/skills` | `.codex/skills` |
| **Gemini** | 目录检测 | `~/.gemini/skills` | `.gemini/skills` |

### 操作系统

| 操作系统 | 支持状态 | 说明 |
|---------|---------|------|
| **Linux** | ✅ 完全支持 | Ubuntu、Debian、CentOS、Fedora 等主流发行版 |
| **macOS** | ✅ 完全支持 | Intel 和 Apple Silicon (M1/M2/M3/M4) |
| **Windows (Git Bash)** | ✅ 完全支持 | 推荐安装 [Git for Windows](https://gitforwindows.org) |
| **Windows (WSL)** | ✅ 完全支持 | Windows Subsystem for Linux |
| **Windows (原生)** | ⚠️ 有限支持 | 需手动配置 PATH，推荐使用 Git Bash 或 WSL |

---

## 项目结构

```
agent-hub/
├── agent-hub                     # CLI 入口脚本（Bash）
├── agent-hub.yaml                # 项目配置文件
├── install.sh                    # 一键安装脚本
├── uninstall.sh                  # 一键卸载脚本
├── LICENSE                       # MIT 许可证
├── README.md                     # 项目文档
├── lib/                          # CLI 模块
│   ├── detect.sh                 # 平台检测模块
│   ├── install.sh                # 安装 / 卸载 / 更新 / 升级模块
│   ├── role.sh                   # 角色管理 / 导入 / 导出模块
│   ├── generate.sh               # 领域生成模块（基于 harness）
│   └── pipeline.sh               # 流水线状态模块
├── roles/                        # 内置角色
│   ├── pm/
│   │   ├── SKILL.md              # 产品经理人设与工作流
│   │   └── role.yaml             # 角色元数据
│   ├── designer/
│   │   ├── SKILL.md              # UI/UX 设计师人设与工作流
│   │   ├── role.yaml
│   │   ├── agents/
│   │   │   └── ui-designer.md    # 子角色：UI 设计师
│   │   └── skills/               # 设计师专属 skills
│   │       ├── tailwind-design-system/
│   │       └── frontend-ui-engineering/
│   ├── frontend/
│   │   ├── SKILL.md              # 前端工程师人设与工作流
│   │   ├── role.yaml
│   │   ├── agents/
│   │   │   └── frontend-developer.md
│   │   ├── rules/
│   │   │   ├── component-rules.md
│   │   │   ├── state-management-rules.md
│   │   │   └── style-rules.md
│   │   └── skills/               # 前端专属 skills
│   │       ├── test-driven-development/
│   │       ├── subagent-driven-development/
│   │       ├── systematic-debugging/
│   │       ├── tailwind-design-system/
│   │       └── frontend-ui-engineering/
│   ├── backend/
│   │   ├── SKILL.md              # 后端工程师人设与工作流
│   │   ├── role.yaml
│   │   ├── agents/
│   │   │   ├── backend-architect.md
│   │   │   └── database-optimizer.md
│   │   ├── rules/
│   │   │   ├── api-rules.md
│   │   │   ├── backend-security-rules.md
│   │   │   └── db-rules.md
│   │   └── skills/               # 后端专属 skills
│   │       ├── test-driven-development/
│   │       ├── subagent-driven-development/
│   │       └── systematic-debugging/
│   ├── qa/
│   │   ├── SKILL.md              # 测试工程师人设与工作流
│   │   ├── role.yaml
│   │   ├── agents/
│   │   │   └── code-reviewer.md
│   │   └── skills/               # QA 专属 skills
│   │       ├── test-driven-development/
│   │       ├── systematic-debugging/
│   │       └── verification-before-completion/
│   └── router/
│       ├── SKILL.md              # 角色路由（自动检测与切换）
│       └── role.yaml
├── .shared/                      # 全局共享资源
│   ├── rules/
│   │   ├── git-rules.md          # Git 提交与分支规范
│   │   ├── quality-rules.md      # 代码质量标准
│   │   ├── security-rules.md     # 安全编码规范
│   │   ├── output-rules.md       # 输出格式规范（含 headroom 优化）
│   │   └── code-standards.md     # 代码规范（基于 ECC）
│   └── skills/
│       └── memory-guide.md       # 记忆管理指南（基于 supermemory）
├── templates/                    # 角色模板
└── tests/                        # 测试
```

---

## 创建自定义角色

### 使用命令创建

```bash
# 创建角色模板
agent-hub role create my-role

# 编辑 SKILL.md
agent-hub role edit my-role
```

### 生成的模板结构

执行 `role create` 后会在 `roles/my-role/` 目录下生成以下文件：

**`roles/my-role/SKILL.md`**：

```yaml
---
name: my-role
description: TODO: 一句话描述这个角色的职责。
---

# Role: my-role

你是一个 TODO（填写角色名）。

## 核心原则

- TODO: 列出核心原则

## 工作流程

### 步骤 1: TODO

TODO: 描述工作流程

## 你不能做的事

- TODO: 列出限制
```

### 编写自定义角色的最佳实践

1. **填写 frontmatter** — `name` 和 `description` 用于 `role list` 展示
2. **定义加载顺序** — 在 SKILL.md 中列出需要加载的共享规则和技能
3. **定义输入/输出** — 明确角色需要读取和产出的文件
4. **定义工作流程** — 用步骤化的方式描述角色的工作流程
5. **定义限制** — 明确角色不能做的事，防止越界
6. **创建子角色**（可选） — 在 `agents/` 目录下创建子角色的 Markdown 文件
7. **创建专属规则**（可选） — 在 `rules/` 目录下创建角色专属规则

### 安装自定义角色

```bash
# 项目级安装
agent-hub install my-role --project

# 全局安装
agent-hub install my-role --global

# 指定平台安装
agent-hub install my-role --project --to claude,cursor
```

---

## 工作原理

Agent Hub 的核心工作流程分为三个阶段：

### 阶段 1：平台检测

```
agent-hub detect
    ↓
扫描本地目录，检测哪些 Agent 平台已安装
    ↓
输出已检测平台列表
```

检测方式为目录探测 — 检查每个平台对应的目录（如 `~/.claude/skills`）是否存在。

### 阶段 2：角色安装

```
agent-hub install pm --project
    ↓
读取 roles/pm/SKILL.md + rules/ + agents/
    ↓
复制到所有已检测平台的正确目录：
  → .reasonix/skills/pm/SKILL.md
  → .qoder/skills/pm/SKILL.md
  → .claude/skills/pm/SKILL.md
  → .cursor/skills/pm/SKILL.md
  → ...（其他平台）
同时复制 .shared/rules/ 中的共享规则
```

### 阶段 3：角色使用

```
用户在 Agent 中新建会话
    ↓
Agent 读取对应目录下的 SKILL.md
    ↓
加载角色人设 + 共享规则 + 专属规则
    ↓
以该角色身份和能力与用户交互
```

---

## 多平台支持

### Linux

开箱即用，无需额外配置。支持所有主流发行版（Ubuntu、Debian、CentOS、Fedora、Arch 等）。

```bash
curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/install.sh | bash
```

### macOS

完全支持 Intel 和 Apple Silicon 芯片。Shell 配置文件自动适配：

- **bash** → `~/.bash_profile`
- **zsh** → `~/.zshrc`（macOS 默认 shell）

```bash
curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/install.sh | bash
```

### Windows

推荐按优先级选择以下方案：

#### 方案一：Git Bash（推荐）

1. 下载安装 [Git for Windows](https://gitforwindows.org)
2. 打开 Git Bash 终端
3. 运行一键安装命令：

```bash
curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/install.sh | bash
```

4. 重启 Git Bash 使 PATH 生效

#### 方案二：WSL（推荐）

1. 启用 WSL：

```powershell
wsl --install
```

2. 安装 Ubuntu 发行版：

```powershell
wsl --install -d Ubuntu
```

3. 在 WSL 终端中运行安装命令：

```bash
curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/install.sh | bash
```

4. 使 PATH 生效：

```bash
source ~/.bashrc
```

#### 方案三：原生 Windows（有限支持）

原生 Windows 环境（CMD / PowerShell）需要：

1. 手动将 `$HOME/.local/bin` 添加到系统 PATH
2. 可能遇到路径分隔符和换行符兼容问题
3. 推荐改用 Git Bash 或 WSL 以获得最佳体验

---

## 免责声明

### 1. 集成项目免责声明

Agent Hub 集成了多个第三方开源项目。这些项目的版权归原作者所有，Agent Hub 仅作为集成和使用的工具，不对集成项目的功能、安全性或准确性做任何保证。

| 项目 | 版权所有 | 许可证 | 项目地址 |
|------|---------|--------|---------|
| markitdown | Microsoft Corporation | MIT License | https://github.com/microsoft/markitdown |
| superpowers | obra / jnMetaCode | MIT License | https://github.com/jnMetaCode/superpowers-zh |
| ECC | affaan-m | MIT License | https://github.com/affaan-m/ECC |
| taste-skill | Leonxlnx | MIT License | https://github.com/Leonxlnx/taste-skill |
| headroom | chopratejas | Apache-2.0 License | https://github.com/chopratejas/headroom |
| harness | revfactory | Apache-2.0 License | https://github.com/revfactory/harness |
| supermemory | supermemoryai | MIT License | https://github.com/supermemoryai/supermemory |

### 2. 使用免责声明

1. **按原样提供**：Agent Hub 及其集成的项目按"原样"提供，不作任何明示或暗示的保证。
2. **风险自担**：使用 Agent Hub 及其集成项目的风险由用户自行承担。
3. **不保证兼容性**：Agent Hub 不保证与所有 AI Agent 平台的完全兼容性。
4. **不保证输出质量**：Agent Hub 不保证使用集成项目后 AI 输出的质量或准确性。
5. **不承担损失**：Agent Hub 的作者和贡献者不对因使用本项目而产生的任何直接、间接、偶然、特殊或后果性损失承担责任。
6. **第三方项目**：Agent Hub 集成的第三方项目有其自己的许可和使用条款，用户应自行遵守。
7. **API 密钥安全**：用户应妥善保管自己的 API 密钥，Agent Hub 不对密钥泄露造成的损失负责。
8. **数据隐私**：Agent Hub 本身不收集或存储用户数据，但集成的第三方项目可能有自己的数据收集政策。

### 3. 贡献者免责声明

Agent Hub 的贡献者不对以下情况负责：

1. 因使用本项目而产生的任何损失
2. 因修改本项目而产生的问题
3. 因集成第三方项目而产生的兼容性问题
4. 因 AI 输出不准确而产生的决策错误

### 4. 许可证

Agent Hub 采用 [MIT License](LICENSE) 许可证。

MIT License 允许用户自由使用、复制、修改、合并、发布、分发、再许可和/或出售本软件的副本，并允许被提供软件的人这样做，但须满足以下条件：

上述版权声明和本许可声明应包含在本软件的所有副本或重要部分中。

本软件按"原样"提供，不作任何明示或暗示的保证，包括但不限于对适销性、特定用途的适用性和不侵权的保证。在任何情况下，作者或版权持有人均不对因本软件或本软件的使用或其他交易而产生的任何索赔、损害或其他责任负责，无论是在合同诉讼、侵权诉讼或其他诉讼中。

---

## 致谢

- [markitdown](https://github.com/microsoft/markitdown) — 微软出品的文档文本提取工具
- [superpowers](https://github.com/jnMetaCode/superpowers-zh) — AI 编程工作流方法论（159k+ stars）
- [ECC](https://github.com/affaan-m/ECC) — 高质量编码规范集合
- [taste-skill](https://github.com/Leonxlnx/taste-skill) — AI UI 品位规范
- [headroom](https://github.com/chopratejas/headroom) — Token 优化输出规范
- [harness](https://github.com/revfactory/harness) — AI Agent 团队编排框架
- [supermemory](https://github.com/supermemoryai/supermemory) — AI 记忆管理方案

---

## 联系方式

如有问题或建议，请通过以下方式联系：

- **GitHub Issues**: https://github.com/phper666/agent-hub/issues
- **GitHub Discussions**: https://github.com/phper666/agent-hub/discussions

---

<p align="center">
  <strong>Agent Hub v2.0.0</strong> · MIT License · Made with 🦞
</p>
