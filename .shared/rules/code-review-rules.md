# 代码审查规范（基于 open-code-review 7.2k stars）

> 来源：https://github.com/alibaba/open-code-review
> 适用于所有角色（代码审查由 QA 角色主导执行）

## 概述

Open Code Review 是阿里巴巴开源的 AI 驱动代码审查工具，采用确定性工程 + Agent 混合架构。

**核心理念：** 确定性工程保证正确性，Agent 处理动态决策。

---

## 审查规则系统

### 四层优先级链

| 优先级 | 来源 | 说明 |
|--------|------|------|
| 1（最高） | 用户指定 | CLI 显式覆盖 |
| 2 | 项目配置 | `.open-code-review/rule.json` |
| 3 | 全局配置 | `~/.open-code-review/rule.json` |
| 4（最低） | 系统默认 | 内置规则 |

### 规则文件格式

```json
{
  "rules": [
    {
      "path": "src/api/**/*.{java,kt}",
      "rule": "所有新方法必须对必需参数进行空值校验"
    },
    {
      "path": "**/*mapper*.xml",
      "rule": "检查 SQL 注入风险、参数错误和缺失的闭合标签"
    },
    {
      "path": "**/*.test.{js,ts}",
      "rule": "测试必须覆盖 happy path、edge case 和 error case"
    }
  ]
}
```

---

## 审查检查清单

### 1. 安全性检查

- [ ] SQL 注入风险
- [ ] XSS 攻击风险
- [ ] 敏感信息泄露（密钥、Token、密码）
- [ ] 权限校验缺失
- [ ] 输入验证缺失

### 2. 代码质量检查

- [ ] 空值校验（必需参数）
- [ ] 异常处理完整性
- [ ] 资源释放（文件、连接、锁）
- [ ] 并发安全（线程安全、竞态条件）
- [ ] N+1 查询问题

### 3. 规范性检查

- [ ] 命名规范（变量、函数、类）
- [ ] 注释完整性（复杂逻辑）
- [ ] 代码重复（DRY 原则）
- [ ] 函数长度（≤50 行）
- [ ] 文件长度（≤300 行）

### 4. 测试检查

- [ ] 测试覆盖率 ≥ 80%
- [ ] 测试独立性（无依赖）
- [ ] 测试命名清晰
- [ ] 边界情况覆盖

---

## 路径过滤系统

### Include/Exclude 配置

```json
{
  "include": ["src/**/*.{java,kt}"],
  "exclude": [
    "**/*Test.java",
    "**/*_test.go",
    "**/*.test.{js,ts}"
  ]
}
```

**规则：**
- `exclude` 优先于 `include`
- 支持 `**` 递归匹配
- 支持 `{java,kt}` 花括号展开

### 默认排除模式

```
*_test.go
**/Test.java
**/*.test.{js,jsx,ts,tsx}
**/*.spec.{js,jsx,ts,tsx}
**/__tests__/**
**/test/**
```

---

## 审查工作流

### 1. 本地开发（提交前）

```bash
# 审查工作区变更
ocr review

# 审查特定文件
ocr review --include "src/api/**"
```

### 2. 分支对比

```bash
# 审查分支差异
ocr review --base main --head feature/new-api
```

### 3. CI/CD 集成

```yaml
# GitHub Actions
- name: Code Review
  uses: alibaba/open-code-review@v1
  with:
    base: ${{ github.event.pull_request.base.sha }}
    head: ${{ github.event.pull_request.head.sha }}
```

---

## 审查输出格式

### 结构化评论

```markdown
**问题类型：** 安全性 - SQL 注入风险
**严重程度：** Critical
**文件：** src/api/user/UserMapper.xml
**行号：** 42
**描述：** 直接拼接用户输入到 SQL 语句中，存在 SQL 注入风险
**建议：** 使用参数化查询或 MyBatis 的 `#{}` 语法

```xml
<!-- ❌ 错误 -->
SELECT * FROM users WHERE name = '${name}'

<!-- ✅ 正确 -->
SELECT * FROM users WHERE name = #{name}
```
```

---

## 集成到 Agent Hub

### QA 角色使用

在代码审查时，遵循以下优先级：

1. **项目规则**（`.open-code-review/rule.json`）
2. **全局规则**（`~/.open-code-review/rule.json`）
3. **本文档的检查清单**
4. **通用最佳实践**

### 审查报告格式

```markdown
## 代码审查报告

### 总结
- 审查文件数：15
- 发现问题：3 Critical, 5 Warning, 8 Info
- 建议修复：8 个问题需要修复后才能合并

### Critical 问题
1. [安全性] SQL 注入风险 - UserMapper.xml:42
2. [安全性] 密钥硬编码 - Config.java:18
3. [并发] 竞态条件 - Counter.java:35

### Warning 问题
...

### Info 问题
...
```
