---
name: pr-review
description: 在进行 PR 审查时使用，自动生成 PR 描述、审查代码、提供建议
---

# PR 审查技能（基于 pr-agent 11.6k stars）

> 来源：https://github.com/The-PR-Agent/pr-agent
> 适用于 QA 角色

## 概述

PR-Agent 是开源的 AI 驱动代码审查 Agent，支持 GitHub、GitLab、BitBucket、Azure DevOps。

**核心理念：** 单次 LLM 调用，快速低成本，自动化 PR 审查流程。

---

## 核心工具

### 1. /describe - 生成 PR 描述

自动生成结构化的 PR 描述：

```markdown
## PR 描述

**类型：** Feature
**标签：** api, authentication, security
**变更摘要：**
- 新增用户认证 API（JWT Token）
- 添加登录/注册端点
- 实现 Token 刷新机制

**逐步计划：**
1. 添加 JWT 工具类
2. 实现登录接口
3. 实现注册接口
4. 添加 Token 刷新
5. 编写测试
```

### 2. /review - 代码审查

自动审查代码变更：

```markdown
## 代码审查

### 严重问题
1. **[Critical]** 缺少输入验证
   - 文件：src/api/auth.ts:45
   - 描述：密码未进行强度校验
   - 建议：添加密码强度校验逻辑

### 改进建议
1. **[Medium]** 错误处理不完整
   - 文件：src/api/auth.ts:78
   - 描述：数据库异常未捕获
   - 建议：添加 try-catch 并返回友好错误

### 优点
- 代码结构清晰
- 测试覆盖完整
```

### 3. /improve - 代码改进

提供具体的代码优化方案：

```markdown
## 代码改进建议

### 1. 优化数据库查询
**当前代码：**
```typescript
const users = await db.query('SELECT * FROM users');
const activeUsers = users.filter(u => u.isActive);
```

**建议改进：**
```typescript
const activeUsers = await db.query(
  'SELECT * FROM users WHERE is_active = ?', 
  [true]
);
```

**理由：** 减少内存占用，提高查询效率
```

### 4. /ask - 问答

对 PR 提问并获取答案：

```bash
# 针对整个 PR 提问
/ask 这个 PR 的主要目的是什么？

# 针对特定代码行提问
/ask 这里为什么使用异步处理？
```

### 5. /update_changelog - 更新变更日志

自动更新 CHANGELOG.md：

```markdown
## [1.2.0] - 2024-01-15

### Added
- 用户认证 API（JWT Token）
- 登录/注册端点
- Token 刷新机制

### Changed
- 优化数据库查询性能

### Fixed
- 修复并发竞态条件
```

---

## 使用流程

### 1. PR 创建时

```bash
# 自动生成 PR 描述
/describe

# 自动审查代码
/review
```

### 2. 审查反馈后

```bash
# 获取改进建议
/improve

# 针对问题提问
/ask 这个安全问题如何修复？
```

### 3. PR 更新后

```bash
# 重新审查
/review

# 更新变更日志
/update_changelog
```

---

## 配置文件

### .pr_agent.toml

```toml
[config]
model = "gpt-4"
max_tokens = 4000

[review]
# 审查类别
categories = [
    "security",
    "performance",
    "code_quality",
    "testing",
    "documentation"
]

[describe]
# 自动生成标签
enable_auto_labels = true

[improve]
# 是否包含代码建议
enable_code_suggestions = true
```

---

## CI/CD 集成

### GitHub Actions

```yaml
name: PR Agent
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  pr_agent:
    runs-on: ubuntu-latest
    steps:
    - name: PR Agent
      uses: The-PR-Agent/pr-agent@main
      env:
        OPENAI_KEY: ${{ secrets.OPENAI_KEY }}
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### GitLab CI

```yaml
pr_agent:
  stage: review
  image: python:3.10
  script:
    - pip install pr-agent
    - pr-agent --pr_url $CI_MERGE_REQUEST_PROJECT_URL/-/merge_requests/$CI_MERGE_REQUEST_IID review
  only:
    - merge_requests
```

---

## 集成到 Agent Hub

### QA 角色使用

在 PR 审查阶段，使用以下工作流：

1. **描述生成**：调用 `/describe` 生成 PR 描述
2. **代码审查**：调用 `/review` 审查代码变更
3. **改进优化**：调用 `/improve` 获取改进建议
4. **问答澄清**：调用 `/ask` 解决疑问
5. **变更日志**：调用 `/update_changelog` 更新文档

### 审查报告模板

```markdown
## PR 审查报告

**PR 链接：** https://github.com/org/repo/pull/123
**审查时间：** 2024-01-15
**审查人：** QA Agent

### PR 描述
[自动生成的 PR 描述]

### 审查结果
- **通过：** ✅ 建议合并
- **问题数：** 2 Critical, 3 Warning
- **测试覆盖：** 85%

### 关键问题
1. [Critical] 安全问题 - 需要修复后合并
2. [Warning] 性能问题 - 建议优化

### 改进建议
[自动生成的改进建议]

### 决策
- [ ] 修复 Critical 问题后合并
- [ ] 忽略 Warning 问题
- [ ] 需要更多讨论
```

---

## 最佳实践

### DO（推荐）

- ✅ 在 PR 创建时立即调用 `/describe`
- ✅ 审查所有 Critical 和 Warning 问题
- ✅ 使用 `/ask` 澄清不明确的问题
- ✅ 定期更新变更日志

### DON'T（避免）

- ❌ 跳过审查直接合并
- ❌ 忽略 Critical 问题
- ❌ 不读审查建议就关闭 PR
- ❌ 手动编写 PR 描述（使用 `/describe`）
