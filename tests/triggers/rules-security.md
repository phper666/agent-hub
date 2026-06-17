# security-rules 规则触发验证

## Should Trigger（应触发）

| # | Prompt | 预期行为 |
|---|--------|---------|
| 1 | 安全编码规范是什么 | 规则触发，输出安全编码规范 |
| 2 | 输入校验怎么做 | 规则触发，输出输入校验规范 |
| 3 | 认证授权规范 | 规则触发，输出认证授权规范 |
| 4 | SQL注入怎么防护 | 规则触发，输出SQL注入防护 |
| 5 | XSS攻击防护 | 规则触发，输出XSS防护规范 |

## Should NOT Trigger（不应触发）

| # | Prompt | 预期行为 |
|---|--------|---------|
| 1 | 这个按钮颜色好看吗 | ❌ 不触发 security-rules |
| 2 | PRD怎么写 | ❌ 不触发 security-rules |
| 3 | 组件性能优化 | ❌ 不触发 security-rules |
| 4 | 数据库表设计 | ❌ 不触发 security-rules |
| 5 | 测试覆盖率 | ❌ 不触发 security-rules |
