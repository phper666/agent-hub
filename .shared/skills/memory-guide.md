# 记忆管理指南（基于 supermemory 27k stars）

> 来源：https://github.com/supermemoryai/supermemory
> 让 AI 在对话间保持记忆，构建持久化上下文

---

## 核心概念

### 记忆 vs RAG

| 特性 | 记忆（Memory） | RAG |
|------|---------------|-----|
| **本质** | 提取和跟踪用户事实 | 检索文档块 |
| **状态** | 有状态，随时间演变 | 无状态，每次查询相同 |
| **个性化** | 为每个用户定制 | 所有用户结果相同 |
| **时间感知** | 理解"我刚搬到旧金山"覆盖"我住在纽约" | 不理解时间关系 |

**最佳实践**：同时使用记忆和 RAG，获取知识库检索 + 个性化上下文。

---

## 记忆类型

### 1. 静态事实（Static Facts）

长期稳定的用户信息：

```
- 用户是高级工程师
- 偏好深色模式
- 使用 Vim
- 喜欢 TypeScript
- 偏好函数式编程
```

### 2. 动态上下文（Dynamic Context）

近期活动和临时信息：

```
- 正在进行认证迁移
- 调试速率限制问题
- 今天有考试（临时）
- 上周讨论了 API 设计
```

### 3. 项目上下文（Project Context）

特定项目的信息：

```
- 项目：agent-hub
- 技术栈：Bash, YAML
- 当前阶段：阶段二
- 已完成：6 个角色，CLI 工具
```

---

## 记忆管理原则

### 1. 自动提取

AI 应自动从对话中提取重要信息：

**提取的内容**：
- ✅ 用户偏好（"我喜欢..."、"我偏好..."）
- ✅ 项目信息（"我们在做..."、"技术栈是..."）
- ✅ 决策记录（"我们决定..."、"选择 X 因为..."）
- ✅ 问题和解决方案（"遇到 X 问题，用 Y 解决"）

**不提取的内容**：
- ❌ 日常闲聊
- ❌ 临时调试信息
- ❌ 重复的信息
- ❌ 噪音

### 2. 时间感知

记忆应理解时间关系：

```
用户："我住在纽约"
→ 记忆：用户住在纽约

用户："我刚搬到旧金山"
→ 记忆：用户住在旧金山（覆盖之前的记忆）
```

### 3. 自动遗忘

临时信息应自动过期：

```
用户："我今天有考试"
→ 记忆：用户今天有考试（明天自动遗忘）

用户："我上周完成了项目"
→ 记忆：用户上周完成了项目（保留）
```

### 4. 矛盾解决

当新信息与旧信息矛盾时：

```
旧记忆：用户偏好 React
新信息：我现在更喜欢 Vue
→ 更新：用户偏好 Vue（覆盖旧记忆）
```

---

## 实践指南

### 会话开始时

1. **加载用户画像**：获取用户的静态事实和动态上下文
2. **注入系统提示**：将画像注入到系统提示中
3. **检查项目上下文**：加载当前项目的相关信息

```markdown
## 用户画像
- 高级工程师，偏好 TypeScript
- 正在做 agent-hub 项目
- 上次讨论：阶段二计划

## 当前项目
- 项目：agent-hub
- 阶段：阶段二
- 进度：6/6 步骤完成
```

### 会话中

1. **主动记录**：当用户分享重要信息时，主动记录
2. **更新上下文**：当信息变化时，更新记忆
3. **引用历史**：在回答中引用相关的记忆

```markdown
用户："我决定用 Vue 重构前端"
AI："好的，我会记住你偏好 Vue。之前我们讨论过 React，
    现在更新为 Vue。需要我帮你规划重构吗？"
```

### 会话结束时

1. **总结关键点**：总结本次会话的关键决策和进展
2. **更新记忆**：将新信息保存到记忆中
3. **标记待办**：如果有未完成的任务，标记为待办

```markdown
## 会话总结
- 完成了：步骤 2.1-2.6
- 决定：用 Vue 重构前端
- 待办：开始阶段三
```

---

## 记忆存储格式

### Markdown 格式

```markdown
# 用户记忆

## 静态事实
- 高级工程师
- 偏好 TypeScript
- 偏好函数式编程
- 使用 Vim

## 动态上下文
- 正在做 agent-hub 项目
- 当前阶段：阶段二
- 上次讨论：2024-01-15

## 项目上下文
### agent-hub
- 技术栈：Bash, YAML
- 状态：阶段二完成
- 下一步：阶段三

## 决策记录
- 2024-01-15：决定用 Vue 重构前端
- 2024-01-10：完成阶段二所有步骤
```

### YAML 格式

```yaml
user:
  static_facts:
    - role: senior_engineer
    - prefers: typescript
    - style: functional
    - editor: vim
  dynamic_context:
    - project: agent-hub
    - phase: phase-2
    - last_discussion: 2024-01-15

projects:
  agent-hub:
    stack: [bash, yaml]
    status: phase-2-complete
    next: phase-3

decisions:
  - date: 2024-01-15
    decision: use-vue-for-frontend-refactor
  - date: 2024-01-10
    decision: complete-phase-2
```

---

## 集成到 Agent Hub

### 所有角色共享

此记忆管理指南通过 `.shared/skills/` 自动注入到所有角色：

1. **PM**：记住产品需求和用户反馈
2. **Designer**：记住设计偏好和风格指南
3. **Frontend**：记住技术栈和框架偏好
4. **Backend**：记住架构决策和 API 设计
5. **QA**：记住测试策略和质量标准
6. **Router**：记住用户角色偏好和项目阶段

### 使用方式

1. **会话开始**：加载 `docs/current/memory.md`
2. **会话中**：主动记录重要信息
3. **会话结束**：更新 `docs/current/memory.md`

---

## 工具推荐

### MCP Server

```bash
# 安装 supermemory MCP server
npx -y install-mcp@latest https://mcp.supermemory.ai/mcp --client claude --oauth=yes
```

### 本地部署

```bash
# 本地运行 supermemory
curl -fsSL https://supermemory.ai/install | bash
```

### API 使用

```javascript
import Supermemory from "supermemory";

const client = new Supermemory();

// 存储对话
await client.add({
  content: "用户喜欢 TypeScript，偏好函数式编程",
  containerTag: "user_123",
});

// 获取用户画像
const { profile } = await client.profile({
  containerTag: "user_123",
});

// profile.static  → ["喜欢 TypeScript", "偏好函数式编程"]
// profile.dynamic → ["正在做 API 集成"]
```

---

## 最佳实践

### DO（推荐）

- ✅ 自动从对话中提取重要信息
- ✅ 理解时间关系，更新过时信息
- ✅ 自动遗忘临时信息
- ✅ 解决信息矛盾
- ✅ 在回答中引用相关记忆
- ✅ 按项目组织记忆

### DON'T（避免）

- ❌ 记录所有对话内容
- ❌ 保留过时的信息
- ❌ 忽略时间关系
- ❌ 重复记录相同信息
- ❌ 记录噪音和闲聊
- ❌ 混淆不同项目的记忆
