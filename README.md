# 🦞 Agent Hub — AI 角色包管理器

**像 npm 管包一样，管 AI Agent 的角色和技能。**

一次定义，安装到所有平台（Claude Code、Cursor、Codex、ZCode 等 9 个）。免去手动复制和格式适配。

---

## 功能特性

- 🎭 **8 个内置角色 + 13 个共享技能** — PM → Designer → Architect → Frontend/Backend → QA → Delivery Director，覆盖全流程
- 📦 **一键安装多平台** — `agent-hub install all --global` 部署到所有已检测 AI 工具
- 🔌 **集成 16+ 开源项目** — superpowers、spec-kit、ECC、pr-agent、CodeGraph 等
- 🧠 **按需加载，防 Token 爆炸** — Expert Selection Guide + 轻量模式，最重角色 Core ~20k tokens
- 🐧 **Linux / macOS / Windows** — 一条 curl 命令安装

---

## 快速开始

### 安装

```bash
curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/install.sh | bash
```

### 检测平台 + 安装角色

```bash
agent-hub detect                    # 扫描本地 AI 工具
agent-hub install all --global      # 安装全部角色
```

### 使用

```
在 AI 工具中新建会话，说 "切换到 Backend" 或 "用 Frontend 角色"
AI 自动加载该角色的规则、技能和专家知识
```

> 💡 装完后，对角色说 **「帮我安装 CodeGraph 和 code-review-graph」**，AI 会自动配置代码智能分析。

---

## 核心概念

### 角色 = SKILL.md + Expert

每个角色是一个 `SKILL.md`（工程框架：加载顺序、I/O 定义）加上按需加载的 Expert（领域专家：技术深度）。

```
安装 → AI 读 SKILL.md → 按 Core Loading Order 加载规则+技能 → 按任务域选 Expert
```

### .shared/ = 共享层

`rules/`（6 个）和 `skills/`（13 个）自动注入所有角色。每个技能内置 `## When to Load` 门控表，AI 按角色+任务域决定是否加载。

### 流水线是推荐，不是强制

```
PM → Designer → Architect → [Frontend + Backend] → QA → Delivery Director
```

`depends_on` / `after_complete` 只是 YAML 元数据。**你可以只用一个角色**——Agent Hub 是工具箱，不是生产线。

### 不想全流程？只用开发角色

```bash
agent-hub install backend --project     # 只装后端，跳过 PM/Designer/QA
agent-hub install frontend --project    # 只装前端
```

---

## 支持平台

Reasonix · Qoder · Claude Code · Cursor · WorkBuddy · Codex · Gemini · openCode · ZCode

---

## 文档

| 文档 | 内容 |
|------|------|
| [全部命令](docs/commands.md) | CLI 完整参考 |
| [内置角色](docs/roles.md) | 8 个角色 + 6 个共享规则 + DAG 流水线 |
| [集成项目](docs/integrations.md) | 16+ 个开源项目集成详情 |
| [项目结构](docs/project-structure.md) | 目录树 |
| [创建自定义角色](docs/custom-roles.md) | role create + SKILL.md 模板 |
| [工作原理](docs/how-it-works.md) | 检测→安装→使用三阶段 |
| [安装指南](docs/installation.md) | Linux / macOS / Windows |
| [流水线](docs/pipeline.md) | DAG 依赖、协同工作流、选择性加载 |
| [PR Review Actions](docs/github-actions/pr-review.yml.md) | GitHub Actions 配置模板 |

---

## 免责声明

Agent Hub 集成多个第三方开源项目。这些项目的版权归原作者所有。

Agent Hub 采用 [MIT License](LICENSE)。按"原样"提供，不提供任何明示或暗示的保证。

---

## 致谢

- [markitdown](https://github.com/microsoft/markitdown) · [superpowers](https://github.com/jnMetaCode/superpowers-zh) · [ECC](https://github.com/affaan-m/ECC) · [taste-skill](https://github.com/Leonxlnx/taste-skill) · [headroom](https://github.com/chopratejas/headroom) · [harness](https://github.com/revfactory/harness) · [supermemory](https://github.com/supermemoryai/supermemory) · [spec-kit](https://github.com/github/spec-kit) · [agency-agents](https://github.com/msitarzewski/agency-agents) · [open-code-review](https://github.com/alibaba/open-code-review) · [pr-agent](https://github.com/The-PR-Agent/pr-agent) · [CodeGraph](https://github.com/colbymchenry/codegraph) · [code-review-graph](https://github.com/tirth8205/code-review-graph)

---

## 联系方式

- **GitHub Issues**: https://github.com/phper666/agent-hub/issues
- **GitHub Discussions**: https://github.com/phper666/agent-hub/discussions

---

<p align="center">
  <strong>Agent Hub v3.0.0</strong> · MIT License · Made with 🦞
</p>
