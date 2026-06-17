---
name: collaborative-review
description: 在进行代码审查时使用，多个 Agent 分别审查，汇总后再统一 review。Trigger on: "collaborative review", "multi-agent review", "distribute review".
---

# 多 Agent 协作审查

> 共享技能 — Frontend/Backend 自动加载
> QA 审查时也可通过 code-review-rules + code-review-graph 协同触发

## When to Load This Skill

| Role | Task Domain | Load? |
|------|------------|:-----:|
| Backend | Code review, PR review | ✅ Always — load full |
| Frontend | Code review, PR review | ✅ Always — load full |
| QA | PR review (complement to crg) | ⚠️ Load on demand |
| All other roles | N/A | ❌ Skip |

## 概述

单个 Agent 的审查容易有盲点。通过多个 Agent 分别审查，汇总后再统一 review，可以显著提高审查质量。

**核心理念：** 多视角审查 + 汇总去重 + 统一决策

---

## 协作审查流程

### 阶段 1：分发审查任务

将代码变更分发给多个专项 Agent：

| Agent | 审查重点 | 关注维度 |
|-------|---------|---------|
| **security-reviewer** | 安全性审查 | SQL 注入、XSS、密钥泄露、权限校验 |
| **quality-reviewer** | 代码质量 | 命名规范、代码重复、函数长度、复杂度 |
| **performance-reviewer** | 性能审查 | N+1 查询、内存泄漏、算法效率 |
| **test-reviewer** | 测试审查 | 覆盖率、边界情况、测试独立性 |

### 阶段 2：并行审查

每个 Agent 独立审查，输出结构化报告：

```markdown
## [Agent 名称] 审查报告

### 审查范围
- 文件数：15
- 变更行数：342

### 发现问题

#### Critical（必须修复）
1. **[安全性]** SQL 注入风险
   - 文件：src/api/user.ts:45
   - 描述：直接拼接用户输入到 SQL
   - 建议：使用参数化查询

#### Warning（建议修复）
1. **[性能]** N+1 查询问题
   - 文件：src/service/order.ts:78
   - 描述：循环中执行数据库查询
   - 建议：使用批量查询

#### Info（仅供参考）
1. **[质量]** 函数过长
   - 文件：src/utils/helper.ts:120-250
   - 描述：函数 130 行，建议拆分

### 审查结论
- 建议合并：❌ 否（需要修复 Critical 问题）
- 严重程度：High
```

### 阶段 3：汇总审查结果

收集所有 Agent 的审查报告，进行汇总：

```markdown
## 汇总审查报告

### 总体统计
- 审查 Agent 数：4
- 发现问题总数：12
  - Critical：3
  - Warning：5
  - Info：4

### 问题分类

#### 安全性问题（security-reviewer）
1. [Critical] SQL 注入风险 - user.ts:45
2. [Warning] 密钥硬编码 - config.ts:12

#### 代码质量（quality-reviewer）
1. [Warning] 命名不规范 - utils.ts:34
2. [Warning] 代码重复 - service.ts:56,78

#### 性能问题（performance-reviewer）
1. [Critical] N+1 查询 - order.ts:78
2. [Warning] 内存泄漏 - cache.ts:45

#### 测试问题（test-reviewer）
1. [Critical] 边界情况未覆盖 - validator.ts:23
2. [Info] 测试命名不清晰
```

### 阶段 4：统一 Review

汇总后进行最终 Review，解决冲突和优先级：

```markdown
## 最终审查决策

### 决策依据
1. 优先解决 Critical 问题
2. 同类问题合并处理
3. 权衡修复成本和收益

### 最终问题列表

#### 必须修复（合并前）
1. **SQL 注入风险** - user.ts:45
   - 来源：security-reviewer
   - 优先级：P0
   - 修复方案：使用参数化查询

2. **N+1 查询** - order.ts:78
   - 来源：performance-reviewer
   - 优先级：P0
   - 修复方案：使用批量查询

3. **边界情况未覆盖** - validator.ts:23
   - 来源：test-reviewer
   - 优先级：P0
   - 修复方案：添加边界测试

#### 建议修复（可后续）
1. 命名不规范 - utils.ts:34
2. 代码重复 - service.ts:56,78

### 最终结论
- **建议合并：** ❌ 否
- **原因：** 3 个 Critical 问题需要修复
- **下一步：** 修复后重新审查
```

---

## Agent 模板

### security-reviewer

```markdown
## 安全性审查 Agent

### 审查清单
- [ ] SQL 注入风险
- [ ] XSS 攻击风险
- [ ] CSRF 防护
- [ ] 敏感信息泄露（密钥、Token、密码）
- [ ] 权限校验缺失
- [ ] 输入验证缺失
- [ ] 文件上传安全
- [ ] 会话管理安全

### 输出格式
按严重程度分类：Critical > Warning > Info
```

### quality-reviewer

```markdown
## 代码质量审查 Agent

### 审查清单
- [ ] 命名规范（变量、函数、类）
- [ ] 注释完整性（复杂逻辑）
- [ ] 代码重复（DRY 原则）
- [ ] 函数长度（≤50 行）
- [ ] 文件长度（≤300 行）
- [ ] 嵌套层级（≤3 层）
- [ ] 圈复杂度（≤10）
- [ ] 依赖关系清晰

### 输出格式
按规范分类：命名、注释、结构、复杂度
```

### performance-reviewer

```markdown
## 性能审查 Agent

### 审查清单
- [ ] N+1 查询问题
- [ ] 内存泄漏风险
- [ ] 算法效率（时间复杂度）
- [ ] 数据库索引使用
- [ ] 缓存策略
- [ ] 异步处理合理性
- [ ] 资源释放（文件、连接、锁）

### 输出格式
按影响分类：数据库、内存、CPU、IO
```

### test-reviewer

```markdown
## 测试审查 Agent

### 审查清单
- [ ] 测试覆盖率 ≥ 80%
- [ ] 边界情况覆盖
- [ ] 错误场景覆盖
- [ ] 测试独立性（无依赖）
- [ ] 测试命名清晰
- [ ] Mock 使用合理
- [ ] 测试数据管理

### 输出格式
按类型分类：单元测试、集成测试、E2E 测试
```

---

## 集成到 Agent Hub

### QA 角色工作流

1. **接收代码变更**：从 git diff 获取变更内容
2. **分发审查任务**：并行启动 4 个专项 Agent
3. **收集审查报告**：汇总所有 Agent 的发现
4. **统一 Review**：解决冲突，确定优先级
5. **输出最终报告**：包含必须修复和建议修复的问题

### 使用场景

- **PR 审查**：合并前的完整审查
- **代码评审**：团队代码评审会议前的准备
- **安全审计**：安全相关的专项审查
- **性能优化**：性能相关的专项审查

---

## 最佳实践

### DO（推荐）

- ✅ 并行运行多个 Agent（提高效率）
- ✅ 每个 Agent 专注一个维度（提高深度）
- ✅ 汇总时去重和合并同类问题
- ✅ 最终 Review 时权衡修复成本

### DON'T（避免）

- ❌ 只用一个 Agent 审查（容易有盲点）
- ❌ 跳过汇总直接输出（信息冗余）
- ❌ 所有问题都标记为 Critical（优先级混乱）
- ❌ 不给出修复建议（只报告问题）
