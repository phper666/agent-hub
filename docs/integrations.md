# 集成项目详细说明

> 本文档包含 Agent Hub 所有集成项目的详细说明。
> 简要汇总请参考 [README.md](../README.md#集成项目)。

---

## 目录

1. [markitdown](#1-markitdown)
2. [superpowers](#2-superpowers)
3. [ECC](#3-ecc)
4. [taste-skill](#4-taste-skill)
5. [headroom](#5-headroom)
6. [harness](#6-harness)
7. [supermemory](#7-supermemory)
8. [spec-kit](#8-spec-kit)
9. [agency-agents](#9-agency-agents)
10. [open-code-review](#10-open-code-review)
11. [pr-agent](#11-pr-agent)
12. [Rules 2.1 bug-fix](#12-rules-21-bug-fix)
13. [Rules 2.1 code-review](#13-rules-21-code-review)

---

## 1. markitdown

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

## 2. superpowers

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

## 3. ECC

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

## 4. taste-skill

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

## 5. headroom

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

## 6. harness

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

## 7. supermemory

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

## 8. spec-kit

| 属性 | 说明 |
|------|------|
| **项目地址** | https://github.com/github/spec-kit |
| **Stars** | 112k+ |
| **许可证** | MIT License |
| **集成方式** | 共享技能（规格驱动开发） |
| **用途** | 规格驱动开发工具包，帮助定义清晰的规格、计划和任务 |
| **集成内容** | 4 个开发阶段：Constitution（项目原则）→ Specify（规格定义）→ Plan（实现计划）→ Tasks（任务拆分） |
| **集成位置** | `.shared/skills/spec-driven-development/SKILL.md` |
| **适用角色** | 所有角色（PM、Designer、Frontend、Backend、QA） |

**核心理念**：
- 规格成为可执行的，直接生成工作实现
- 先想清楚"做什么"和"为什么"，再决定"怎么做"
- 避免"vibe coding"（随意编码）

**按角色使用**：

| 角色 | 使用功能 | 用途 |
|------|---------|------|
| **PM** | Constitution + Specify + Plan + Tasks | 产品规格、产品计划、产品任务 |
| **Designer** | Specify + Plan + Tasks | 设计规格、设计计划、设计任务 |
| **Frontend** | Specify + Plan + Tasks | 前端规格、技术计划、技术任务 |
| **Backend** | Specify + Plan + Tasks | 后端规格、技术计划、技术任务 |
| **QA** | Specify + Plan + Tasks | 测试规格、测试计划、测试任务 |

**与现有集成的协同**：
- **spec-kit**：定义规格（做什么）→ 所有角色
- **superpowers**：执行工作流（怎么做）→ 所有开发者
- **open-code-review**：代码审查规范（审查什么）→ Frontend、Backend
- **pr-agent**：PR 审查工具（PR 阶段）→ Frontend、Backend
- **ECC**：代码规范（做得好）→ 所有开发者

---

## 9. agency-agents

| 属性 | 说明 |
|------|------|
| **项目地址** | https://github.com/msitarzewski/agency-agents |
| **Stars** | 113k+ |
| **许可证** | MIT License |
| **集成方式** | 角色专属 Agent（专家角色库） |
| **用途** | 165 个即插即用的 AI 专家角色，覆盖 18 个部门 |
| **集成内容** | 8 个软件开发相关角色（Frontend Developer、Backend Architect、Security Engineer、Code Reviewer、Database Optimizer、UI Designer、UX Researcher、Product Manager） |
| **集成位置** | `roles/*/agents/agency/` |
| **适用角色** | Frontend、Backend、Designer、PM、QA |

**集成的角色**：

| 角色 | 文件 | 描述 |
|------|------|------|
| Frontend Developer | `roles/frontend/agents/agency/frontend-developer-expert.md` | Expert in modern web technologies, React/Vue/Angular, UI implementation, and performance optimization |
| Backend Architect | `roles/backend/agents/agency/backend-architect-expert.md` | Senior architect specializing in scalable system design, database architecture, and API development |
| Security Engineer | `roles/qa/agents/agency/security-engineer-expert.md` | Application security specialist in threat modeling, code auditing, and security architecture |
| Code Reviewer | `roles/qa/agents/agency/code-reviewer-expert.md` | Code review specialist focused on code quality, best practices, and team collaboration |
| Database Optimizer | `roles/backend/agents/agency/database-optimizer-expert.md` | Database optimization specialist in performance tuning, indexing strategies, and query optimization |
| UI Designer | `roles/designer/agents/agency/ui-designer-expert.md` | UI design specialist focused on user interface design, visual design, and interaction design |
| UX Researcher | `roles/designer/agents/agency/ux-researcher-expert.md` | UX research specialist focused on user research, usability testing, and user experience optimization |
| Product Manager | `roles/pm/agents/agency/product-manager-expert.md` | Product management specialist focused on product strategy, requirements analysis, and prioritization |

**不集成的角色类别**：
- Marketing — Non-software development roles
- Finance — Non-software development roles
- Healthcare — Non-software development roles

---

## 10. open-code-review

| 属性 | 说明 |
|------|------|
| **项目地址** | https://github.com/alibaba/open-code-review |
| **Stars** | 7.2k+ |
| **许可证** | Apache-2.0 License |
| **集成方式** | 共享规则（代码审查规范） |
| **用途** | 开发阶段的代码审查规范，帮助开发者在提交代码前发现和修复问题 |
| **集成内容** | 审查规则系统（四层优先级链）、路径过滤系统（include/exclude）、审查检查清单（安全性/代码质量/规范性/测试）、审查输出格式 |
| **集成位置** | `.shared/rules/code-review-rules.md` |
| **适用角色** | Frontend、Backend（写代码时使用） |

**核心理念**：
- 确定性工程保证正确性
- Agent 处理动态决策
- 四层优先级链：用户指定 > 项目配置 > 全局配置 > 系统默认

**使用场景**：
- Frontend 开发者写 React/Vue 代码时审查
- Backend 开发者写 API/数据库代码时审查
- 提交代码前自动检查代码质量

---

## 11. pr-agent

| 属性 | 说明 |
|------|------|
| **项目地址** | https://github.com/The-PR-Agent/pr-agent |
| **Stars** | 11.6k+ |
| **许可证** | Apache-2.0 License |
| **集成方式** | 角色专属 Skill（PR 审查技能） |
| **用途** | AI 驱动的 PR 审查 Agent，自动化 PR 描述生成、代码审查、改进建议 |
| **集成内容** | 核心工具（/describe、/review、/improve、/ask、/update_changelog）、CI/CD 集成、审查报告模板 |
| **集成位置** | `roles/{frontend,backend}/skills/pr-review/SKILL.md` |
| **适用角色** | Frontend、Backend（开发者互相审查 PR） |

**核心工具**：

| 命令 | 功能 |
|------|------|
| `/describe` | 自动生成 PR 描述（标题、类型、标签、变更摘要） |
| `/review` | 自动代码审查，识别问题并提供建议 |
| `/improve` | 代码改进建议，提供具体的代码优化方案 |
| `/ask` | 对 PR 提问，获取代码相关问题的解答 |
| `/update_changelog` | 自动更新变更日志 |

**平台支持**：GitHub、GitLab、BitBucket、Azure DevOps、Gitea

**协作审查流程**（基于 collaborative-review skill）：
1. **分发审查任务**：并行启动 4 个专项 Agent（security/quality/performance/test）
2. **并行审查**：每个 Agent 独立审查，输出结构化报告
3. **汇总审查结果**：收集所有 Agent 的发现，去重和合并同类问题
4. **统一 Review**：解决冲突，确定优先级，输出最终审查决策

---

## 12. Rules 2.1 bug-fix

| 属性 | 说明 |
|------|------|
| **项目地址** | https://github.com/Mr-chen-05/rules-2.1-optimized |
| **Stars** | 92★ |
| **许可证** | MIT License |
| **集成方式** | 角色专属（Bug 修复工作流增强） |
| **用途** | 从 Issue → 重现 → 测试 → 修复 → 验证 → PR 的完整 Bug 闭环 |
| **集成内容** | Issue 模板、测试驱动修复代码示例、Commit 规范、调试记录模板 |
| **集成位置** | `roles/backend/agents/agency/backend-architect-expert.md`、`roles/frontend/agents/agency/frontend-developer-expert.md`、`roles/qa/skills/systematic-debugging/SKILL.md` |

**集成内容**：
- Backend Expert: 后端版的测试驱动修复流程（Python 代码 + Commit 规范）
- Frontend Expert: 前端版的修复流程（React/Jest 代码 + Commit 规范）
- QA Systematic Debugging: Issue 创建模板 + Git 分支 + 调试记录模板

---

## 13. Rules 2.1 code-review

| 属性 | 说明 |
|------|------|
| **项目地址** | https://github.com/Mr-chen-05/rules-2.1-optimized |
| **Stars** | 84★ |
| **许可证** | MIT License |
| **集成方式** | 角色专属（多角色代码审查流程合并） |
| **用途** | 从开发者、架构、安全、性能四个维度进行代码审查 |
| **集成内容** | 四角色审查清单 + 引导问题 + 4 级反馈分类 + 作者/团队最佳实践 |
| **集成位置** | `roles/qa/agents/agency/code-reviewer-expert.md` |

**集成内容**：
- 四角色审查视角：🧑‍💻 Developer / 🏗️ Architecture / 🔒 Security / ⚡ Performance
- 每个视角独立检查表和引导问题
- 反馈分类：🔴 Must Fix / 🟡 Suggestion / ❓ Question / 🟢 Kudos
- 作者最佳实践（PR < 400 行、自我审查）和团队审查文化

---

## 集成方式汇总

| 集成项目 | 集成方式 | 影响范围 | 文件位置 |
|---------|---------|---------|---------|
| markitdown | 必备工具 | 所有角色 | `roles/*/SKILL.md` |
| superpowers | 按角色独立集成 | Designer、Frontend、Backend、QA | `roles/<role>/skills/` |
| ECC | 共享规则 | 所有角色 | `.shared/rules/code-standards.md` |
| taste-skill | 角色专属规范 | Designer、Frontend | `roles/designer/SKILL.md`、`roles/frontend/SKILL.md` |
| headroom | 共享规则 | 所有角色 | `.shared/rules/output-rules.md` |
| harness | CLI 命令 | 新角色生成 | `lib/generate.sh` |
| supermemory | 共享技能 | 所有角色 | `.shared/skills/memory-guide.md` |
| spec-kit | 共享技能 | 所有角色 | `.shared/skills/spec-driven-development/SKILL.md` |
| agency-agents | 角色专属 Agent | Frontend、Backend、Designer、PM、QA | `roles/*/agents/agency/` |
| open-code-review | 共享规则 | Frontend、Backend | `.shared/rules/code-review-rules.md` |
| pr-agent | 角色专属 Skill | Frontend、Backend | `roles/{frontend,backend}/skills/pr-review/SKILL.md` |
| Rules 2.1 bug-fix | 角色专属 Expert + Skill | Backend、Frontend、QA | `roles/*/agents/agency/*-expert.md`、`roles/qa/skills/systematic-debugging/SKILL.md` |
| Rules 2.1 code-review | 角色专属 Expert | QA | `roles/qa/agents/agency/code-reviewer-expert.md` |

---

## 相关链接

- [README.md](../README.md) - 项目主页
- [共享规则](../.shared/rules/) - 全局共享规则
- [共享技能](../.shared/skills/) - 全局共享技能
