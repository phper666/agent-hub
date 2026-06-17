# 代码规范（基于 ECC 216k stars）

> 来源：https://github.com/affaan-m/ECC
> 适用于所有角色的通用代码规范

---

## 核心原则

### 不可变性（CRITICAL）

**总是创建新对象，永远不要修改现有对象：**

```javascript
// ❌ WRONG: modify(original, field, value) → 改变了原对象
// ✅ CORRECT: update(original, field, value) → 返回新对象
```

**原理：** 不可变数据防止隐藏的副作用，使调试更容易，并支持安全的并发。

### KISS（保持简单）

- 优先选择**实际可行的最简单方案**
- 避免过早优化
- 为**清晰性**而非巧妙性优化

### DRY（不要重复自己）

- 将重复的逻辑提取为**共享函数或工具**
- 避免 copy-paste 式的代码漂移
- 当重复是**真实的**（不是推测的）时引入抽象

### YAGNI（你不需要它）

- 在真正需要之前**不要构建**功能或抽象
- 避免投机性的泛化
- 从简单开始，当**压力真实存在**时再重构

---

## 文件组织

**许多小文件 > 少数大文件：**

| 指标 | 目标 |
|------|------|
| 文件行数 | 200-400 行典型，800 行最大 |
| 函数行数 | ≤50 行 |
| 嵌套层级 | ≤4 层 |

- 高内聚，低耦合
- 从大模块中提取工具函数
- 按功能/领域组织，而非按类型

---

## 错误处理

**总是全面处理错误：**

```javascript
// ❌ 错误示例
try {
  const data = await fetch(url);
} catch (e) {
  // 什么都不做
}

// ✅ 正确示例
try {
  const data = await fetch(url);
  if (!data.ok) {
    throw new Error(`HTTP ${data.status}: ${data.statusText}`);
  }
  return await data.json();
} catch (error) {
  logger.error('Failed to fetch data', { url, error: error.message });
  throw new UserFriendlyError('无法加载数据，请稍后重试');
}
```

**原则：**
- 在每个层级显式处理错误
- 在 UI 代码中提供用户友好的错误消息
- 在服务端记录详细的错误上下文
- 永远不要静默吞掉错误

---

## 输入验证

**总是在系统边界验证：**

```javascript
// 在入口点验证所有用户输入
function createUser(input) {
  // 验证
  if (!input.email || !isValidEmail(input.email)) {
    throw new ValidationError('邮箱格式无效');
  }
  if (!input.name || input.name.length < 2) {
    throw new ValidationError('姓名至少需要 2 个字符');
  }
  
  // 处理
  return db.users.create(sanitize(input));
}
```

**原则：**
- 在处理之前验证所有用户输入
- 使用 schema-based 验证（如 Zod、Yup、Joi）
- 快速失败并提供清晰的错误消息
- 永远不要信任外部数据（API 响应、用户输入、文件内容）

---

## 命名约定

| 类型 | 风格 | 示例 |
|------|------|------|
| 变量、函数 | camelCase | `getUserById`, `isValid` |
| 布尔值 | is/has/should/can 前缀 | `isLoading`, `hasPermission` |
| 接口、类型、组件 | PascalCase | `UserProfile`, `ButtonProps` |
| 常量 | UPPER_SNAKE_CASE | `MAX_RETRIES`, `API_TIMEOUT` |
| 自定义 hooks | use 前缀 | `useAuth`, `useFetch` |

---

## 代码异味检查清单

在标记工作完成前检查：

- [ ] 代码可读且命名良好
- [ ] 函数小巧（≤50 行）
- [ ] 文件聚焦（≤800 行）
- [ ] 无深层嵌套（≤4 层）
- [ ] 适当的错误处理
- [ ] 无硬编码值（使用常量或配置）
- [ ] 无不必要的可变性（使用不可变模式）

---

## Git 工作流

### 提交消息格式

```
<type>: <description>

<optional body>
```

**类型：** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `ci`

**示例：**
```
feat: add user authentication endpoint

- Implement JWT token generation
- Add login/register routes
- Include refresh token logic
```

### Pull Request 规范

1. 分析完整提交历史（不只是最新提交）
2. 使用 `git diff [base-branch]...HEAD` 查看所有变更
3. 起草全面的 PR 摘要
4. 包含测试计划
5. 使用 `-u` 标志推送新分支

---

## 测试要求

### 最低测试覆盖率：80%

**测试类型（全部必须）：**

1. **单元测试** - 独立的函数、工具、组件
2. **集成测试** - API 端点、数据库操作
3. **E2E 测试** - 关键用户流程

### 测试驱动开发（TDD）

> 详细规范见 `.shared/skills/test-driven-development/SKILL.md`（Frontend、Backend、QA 自动加载）。
> 核心：先写测试 → 看它失败 → 最少代码通过 → 重构。

### 测试命名

使用描述性名称解释被测试的行为：

```javascript
test('returns empty array when no markets match query', () => {});
test('throws error when API key is missing', () => {});
test('falls back to substring search when Redis is unavailable', () => {});
```

### 测试结构（AAA 模式）

```javascript
test('calculates similarity correctly', () => {
  // Arrange - 准备测试数据
  const vector1 = [1, 0, 0];
  const vector2 = [0, 1, 0];

  // Act - 执行被测试的操作
  const similarity = calculateCosineSimilarity(vector1, vector2);

  // Assert - 验证结果
  expect(similarity).toBe(0);
});
```

---

## 集成到 Agent Hub

此规范通过 `.shared/rules/` 自动注入到所有角色：

1. 安装角色时自动加载
2. 优先级低于角色专属规则
3. 与 git-rules、quality-rules、security-rules 共存
