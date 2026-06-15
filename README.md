# 🦞 Agent Hub — AI 角色包管理器

**像 npm 管理 Node.js 包一样，管理 AI Agent 的角色和技能。**

一次定义角色，安装到所有主流 AI Agent 平台。支持 Reasonix、Qoder、Claude、Cursor、WorkBuddy、Codex、Gemini。

**支持平台**: Linux · macOS · Windows (Git Bash / WSL)

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

### 1. 安装 Agent Hub

#### 一键安装（推荐）

```bash
# Linux / macOS / Windows (Git Bash / WSL)
curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/install.sh | bash
```

#### 手动安装

```bash
git clone https://github.com/phper666/agent-hub.git ~/.agent-hub
cd ~/.agent-hub
chmod +x agent-hub

# 添加到 PATH
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc  # 或 ~/.zshrc
source ~/.bashrc
```

#### 卸载

```bash
curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/uninstall.sh | bash
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
| **Linux** | ✅ 完全支持 | Ubuntu、Debian、CentOS、Fedora 等 |
| **macOS** | ✅ 完全支持 | Intel 和 Apple Silicon |
| **Windows (Git Bash)** | ✅ 完全支持 | 推荐安装 [Git for Windows](https://gitforwindows.org) |
| **Windows (WSL)** | ✅ 完全支持 | Windows Subsystem for Linux |
| **Windows (原生)** | ⚠️ 有限支持 | 需要手动配置 PATH，推荐使用 Git Bash 或 WSL |

#### Windows 用户说明

**推荐方案**: 使用 Git Bash 或 WSL

1. **Git Bash**（推荐）:
   - 下载安装 [Git for Windows](https://gitforwindows.org)
   - 打开 Git Bash，运行安装命令
   - 自动配置 PATH

2. **WSL**（推荐）:
   - 启用 WSL: `wsl --install`
   - 安装 Ubuntu: `wsl --install -d Ubuntu`
   - 在 WSL 中运行安装命令

3. **原生 Windows**（有限支持）:
   - 需要手动添加 `$HOME/.local/bin` 到系统 PATH
   - 可能遇到路径和换行符问题

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

---

## 集成项目

Agent Hub v2.0 集成了以下高质量开源项目，提升角色能力：

### 1. markitdown（146.5k stars）

**项目地址**: https://github.com/microsoft/markitdown

**集成方式**: 必备工具

**用途**: 读取 PDF、Office 文档、图片，提取文本内容

**使用场景**:
- PM 读取需求文档
- Designer 读取设计规范
- 所有角色读取参考资料

**安装**: `pip install markitdown`

**集成位置**: 所有角色的 SKILL.md

---

### 2. ECC（216k stars）

**项目地址**: https://github.com/affaan-m/ECC

**集成方式**: 共享规则（code-standards.md）

**用途**: 代码规范和最佳实践

**集成内容**:
- 核心原则（KISS、DRY、YAGNI）
- 文件组织规范
- 错误处理规范
- 输入验证规范
- 命名约定
- Git 工作流
- 测试要求（TDD、80% 覆盖率）

**集成位置**: `.shared/rules/code-standards.md`

---

### 3. taste-skill（44k stars）

**项目地址**: https://github.com/Leonxlnx/taste-skill

**集成方式**: 角色专属规范

**用途**: UI 品位规范，防止 AI 生成无聊、千篇一律的 UI

**集成内容**:
- Brief Inference（先读房间）
- Three Dials（三个调节旋钮）
  - DESIGN_VARIANCE: 布局实验性
  - MOTION_INTENSITY: 动画深度
  - VISUAL_DENSITY: 信息密度
- Anti-Slop Rules（反平庸规则）
- Pre-flight Checklist（完成前检查）

**集成位置**:
- `roles/designer/SKILL.md`
- `roles/frontend/SKILL.md`

---

### 4. headroom（28k stars）

**项目地址**: https://github.com/chopratejas/headroom

**集成方式**: 共享规则（output-rules.md 更新）

**用途**: 精简输出规范，减少 60-95% token 消耗

**集成内容**:
- Token 优化原则
- 输出压缩技巧
- 状态报告格式
- 代码输出规范
- 文档输出规范
- 交互优化
- Token 节省检查清单

**集成位置**: `.shared/rules/output-rules.md`

---

### 5. harness（7k stars）

**项目地址**: https://github.com/revfactory/harness

**集成方式**: CLI 命令（generate）

**用途**: 根据领域自动生成角色配置

**集成内容**:
- 10 个领域的角色模板
  - web（Web 开发）
  - mobile（移动端开发）
  - data（数据分析）
  - api（API 开发）
  - ml（机器学习）
  - devops（DevOps）
  - game（游戏开发）
  - blockchain（区块链）
  - ai（AI 应用）
  - ecommerce（电商）
- 6 种团队架构模式
  - Pipeline（流水线）
  - Fan-out/Fan-in（扇出/扇入）
  - Expert Pool（专家池）
  - Producer-Reviewer（生产者-审查者）
  - Supervisor（监督者）
  - Hierarchical Delegation（层级委托）

**使用方式**: `agent-hub generate <领域>`

**集成位置**: `lib/generate.sh`

---

### 6. supermemory（27k stars）

**项目地址**: https://github.com/supermemoryai/supermemory

**集成方式**: 共享技能（memory-guide.md）

**用途**: 记忆管理，让 AI 在对话间保持记忆

**集成内容**:
- 记忆类型（静态事实、动态上下文、项目上下文）
- 记忆管理原则（自动提取、时间感知、自动遗忘、矛盾解决）
- 实践指南（会话开始、会话中、会话结束）
- 记忆存储格式（Markdown、YAML）
- 工具推荐（MCP Server、本地部署、API）

**集成位置**: `.shared/skills/memory-guide.md`

---

## 集成方式汇总

| 集成项目 | 集成方式 | 影响范围 | 文件位置 |
|---------|---------|---------|---------|
| markitdown | 必备工具 | 所有角色 | `roles/*/SKILL.md` |
| ECC | 共享规则 | 所有角色 | `.shared/rules/code-standards.md` |
| taste-skill | 角色专属规范 | Designer, Frontend | `roles/designer/SKILL.md`, `roles/frontend/SKILL.md` |
| headroom | 共享规则 | 所有角色 | `.shared/rules/output-rules.md` |
| harness | CLI 命令 | 新角色生成 | `lib/generate.sh` |
| supermemory | 共享技能 | 所有角色 | `.shared/skills/memory-guide.md` |

---

## 免责声明

### 1. 集成项目免责声明

Agent Hub 集成了多个第三方开源项目。这些项目的版权归原作者所有，Agent Hub 仅作为集成和使用的工具。

**markitdown**:
- 版权所有: Microsoft Corporation
- 许可证: MIT License
- 项目地址: https://github.com/microsoft/markitdown

**ECC**:
- 版权所有: affaan-m
- 许可证: MIT License
- 项目地址: https://github.com/affaan-m/ECC

**taste-skill**:
- 版权所有: Leonxlnx
- 许可证: MIT License
- 项目地址: https://github.com/Leonxlnx/taste-skill

**headroom**:
- 版权所有: chopratejas
- 许可证: Apache-2.0 License
- 项目地址: https://github.com/chopratejas/headroom

**harness**:
- 版权所有: revfactory
- 许可证: Apache-2.0 License
- 项目地址: https://github.com/revfactory/harness

**supermemory**:
- 版权所有: supermemoryai
- 许可证: MIT License
- 项目地址: https://github.com/supermemoryai/supermemory

### 2. 使用免责声明

1. **按原样提供**: Agent Hub 及其集成的项目按"原样"提供，不作任何明示或暗示的保证。

2. **风险自担**: 使用 Agent Hub 及其集成项目的风险由用户自行承担。

3. **不保证兼容性**: Agent Hub 不保证与所有 AI Agent 平台的完全兼容性。

4. **不保证输出质量**: Agent Hub 不保证使用集成项目后 AI 输出的质量或准确性。

5. **不承担损失**: Agent Hub 的作者和贡献者不对因使用本项目而产生的任何直接、间接、偶然、特殊或后果性损失承担责任。

6. **第三方项目**: Agent Hub 集成的第三方项目有其自己的许可和使用条款，用户应自行遵守。

7. **API 密钥安全**: 用户应妥善保管自己的 API 密钥，Agent Hub 不对密钥泄露造成的损失负责。

8. **数据隐私**: Agent Hub 本身不收集或存储用户数据，但集成的第三方项目可能有自己的数据收集政策。

### 3. 贡献者免责声明

Agent Hub 的贡献者不对以下情况负责：

1. 因使用本项目而产生的任何损失
2. 因修改本项目而产生的问题
3. 因集成第三方项目而产生的兼容性问题
4. 因 AI 输出不准确而产生的决策错误

### 4. 许可证

Agent Hub 采用 MIT License 许可证。

MIT License 允许用户自由使用、复制、修改、合并、发布、分发、再许可和/或出售本软件的副本，并允许被提供软件的人这样做，但须满足以下条件：

上述版权声明和本许可声明应包含在本软件的所有副本或重要部分中。

本软件按"原样"提供，不作任何明示或暗示的保证，包括但不限于对适销性、特定用途的适用性和不侵权的保证。在任何情况下，作者或版权持有人均不对因本软件或本软件的使用或其他交易而产生的任何索赔、损害或其他责任负责，无论是在合同诉讼、侵权诉讼或其他诉讼中。

---

## 联系方式

如有问题或建议，请通过以下方式联系：

- GitHub Issues: https://github.com/phper666/agent-hub/issues
- Email: [待添加]

---

**最后更新**: 2024 年

**版本**: v2.0.0
