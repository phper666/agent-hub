# 🦞 Agent Hub — AI 角色包管理器

**统一管理 AI Agent 角色（SKILL.md）的跨平台包管理工具。**

Agent Hub 帮助你在多个 AI Agent 平台之间统一管理角色定义文件，一次编写，随处安装。支持 Reasonix、Qoder、Claude、Cursor、WorkBuddy、Codex、Gemini 等主流平台。

---

## ✨ 功能特性

- 🔍 **自动检测** — 自动扫描本地已安装的 AI Agent 平台
- 📦 **一键安装** — 将角色（SKILL.md）批量安装到任意平台
- 🗑️ **快速卸载** — 从指定平台移除已安装的角色
- 🔄 **角色更新** — 更新已安装角色到最新版本
- 📥 **导入导出** — 从其他项目导入角色，或导出为 YAML 文件
- 🧩 **共享规则** — 支持全局规则和技能的共享复用
- 🔧 **依赖管理** — 自动安装 markitdown 等工具依赖

---

## 📋 支持平台

| 平台 | 全局安装路径 | 项目安装路径 |
|------|-------------|-------------|
| **Reasonix** | `~/Library/Application Support/reasonix/skills` | `.reasonix/skills` |
| **Qoder** | `~/.qoder/skills` | `.qoder/skills` |
| **Claude** | `~/.claude/skills` | `.claude/skills` |
| **Cursor** | `~/.cursor/skills` | `.cursor/skills` |
| **WorkBuddy** | `~/.workbuddy/skills` | `.workbuddy/skills` |
| **Codex** | `~/.codex/skills` | `.codex/skills` |
| **Gemini** | `~/.gemini/skills` | `.gemini/skills` |

---

## 🚀 安装

### 方式一：克隆仓库

```bash
git clone <repo-url> agent-hub
cd agent-hub
chmod +x agent-hub
```

### 方式二：添加到 PATH

```bash
# 将 agent-hub 添加到全局命令
sudo ln -s $(pwd)/agent-hub /usr/local/bin/agent-hub
```

### 依赖安装

```bash
# 安装工具依赖（markitdown 等）
./agent-hub deps install
```

---

## ⚡ 快速开始

### 1. 初始化项目

```bash
agent-hub init
```

这会在当前目录创建完整的项目结构：

```
my-project/
├── agent-hub.yaml        # 项目配置
├── roles/                # 角色目录
│   ├── pm/
│   ├── designer/
│   ├── frontend/
│   ├── backend/
│   └── qa/
├── .shared/              # 共享规则和技能
│   ├── rules/
│   └── skills/
├── templates/
├── tests/
└── docs/current/
```

### 2. 检测已安装的 Agent 平台

```bash
agent-hub detect
```

输出示例：
```
🔍 检测已安装的 Agent 平台

  ✅ reasonix
  ✅ claude
  ✅ cursor
  ✗ qoder (未安装)
  ✗ workbuddy (未安装)
  ✗ codex (未安装)
  ✗ gemini (未安装)

✅ 检测到 3 个平台: reasonix,claude,cursor
ℹ️  检测结果已保存到 .agent-hub-detected
```

### 3. 安装角色

```bash
# 安装单个角色到所有已检测平台
agent-hub install frontend --global

# 安装所有角色
agent-hub install all --global

# 安装到项目目录
agent-hub install backend --project
```

### 4. 查看角色列表

```bash
agent-hub role list
```

---

## 📖 命令参考

### 初始化

```bash
agent-hub init
```

初始化项目目录结构，创建配置文件 `agent-hub.yaml` 和默认角色模板。

### 平台检测

```bash
agent-hub detect
```

扫描本地系统，检测已安装的 AI Agent 平台。检测结果保存到 `.agent-hub-detected`。

### 角色管理

```bash
# 列出所有角色
agent-hub role list

# 创建新角色
agent-hub role create <name>

# 编辑角色的 SKILL.md
agent-hub role edit <name>

# 查看角色详情
agent-hub role info <name>

# 删除角色
agent-hub role delete <name>
```

### 安装 / 卸载 / 更新

```bash
# 安装角色到全局目录（所有已检测平台）
agent-hub install <role|all> --global

# 安装角色到项目目录
agent-hub install <role|all> --project

# 卸载角色
agent-hub uninstall <role|all> --global
agent-hub uninstall <role|all> --project

# 更新角色（先卸载再重新安装）
agent-hub update <role|all>
```

**安装模式说明：**
- `--global` — 安装到平台的全局目录（如 `~/.claude/skills/<role>/`），所有项目可用
- `--project` — 安装到当前项目目录（如 `.claude/skills/<role>/`），仅当前项目可用

### 导入 / 导出

```bash
# 从其他项目导入角色
agent-hub import <path>

# 导出角色为 YAML 文件
agent-hub export <role>
agent-hub export <role> --output <file>
```

### 依赖管理

```bash
# 安装所有依赖
agent-hub deps install

# 列出依赖
agent-hub deps list
```

### 流水线状态

```bash
# 查看项目状态
agent-hub pipeline status

# 重置状态
agent-hub pipeline reset
```

### 其他

```bash
# 查看版本
agent-hub version

# 查看帮助
agent-hub help
```

---

## 🏗️ 工作原理

Agent Hub 的核心工作流程：

```
roles/<name>/SKILL.md    ──→    <platform>/skills/<name>/SKILL.md
        ↑                                    ↑
   源角色定义                    Agent 平台读取角色配置
```

1. **角色（Role）** 是以 `SKILL.md` 为核心的角色定义文件，存放在 `roles/` 目录下
2. **安装** 时，Agent Hub 将 `SKILL.md` 以及相关的 rules/、skills/ 文件复制到目标平台的 skills 目录
3. **平台检测** 通过扫描各平台的标准安装路径来判断是否已安装
4. 每个角色可包含：
   - `SKILL.md` — 角色定义主文件（必需）
   - `rules/` — 角色专属规则（可选）
   - `skills/` — 角色专属技能（可选）
5. 共享的全局规则和技能放在 `.shared/` 目录，安装时一并复制

---

## 📁 项目结构

```
agent-hub/
├── agent-hub              # 主入口脚本
├── lib/
│   ├── detect.sh          # 平台检测模块
│   ├── install.sh         # 安装/卸载模块
│   ├── pipeline.sh        # 流水线状态模块
│   └── role.sh            # 角色管理模块
├── roles/                 # 角色定义目录
│   ├── pm/                # 产品经理角色
│   ├── designer/          # 设计师角色
│   ├── frontend/          # 前端开发角色
│   ├── backend/           # 后端开发角色
│   └── qa/                # 测试/QA 角色
├── .shared/
│   ├── rules/             # 全局共享规则
│   └── skills/            # 全局共享技能
├── templates/             # 角色模板
├── tests/                 # 测试
└── README.md              # 本文件
```

---

## 📄 许可证

MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
