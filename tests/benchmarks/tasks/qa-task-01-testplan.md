# QA Task 01: Test Plan — 用户登录功能

## 角色
QA (测试工程师)

## 前置条件
需要 PM Task 02 产出的 User Stories 和 Backend 产出的 API 实现

## 输入 Prompt

```
你是一个 QA 工程师。为用户登录功能编写完整的测试计划：

## 测试范围
- 邮箱 + 密码登录
- Google OAuth 登录
- GitHub OAuth 登录
- 忘记密码 / 重置密码流程
- 二次验证（TOTP）

## 要求
- 按测试金字塔组织：单元测试 → 集成测试 → E2E 测试
- 包含：Happy Path、Edge Cases、Error Cases、Security Tests
- 每个测试用例格式：Test ID / 标题 / 前置条件 / 步骤 / 预期结果
- 标注优先级（Critical / High / Medium / Low）
- 输出到 docs/current/reports/test-plan.md
```

## 评估重点
- 测试覆盖度（是否涵盖所有功能点和异常场景）
- 测试用例的具体性和可执行性
- 优先级划分的合理性
- 安全测试的覆盖（SQL 注入、XSS、CSRF、暴力破解）
