# code-review-rules 规则触发验证

## Should Trigger（应触发）

| # | Prompt | 预期行为 |
|---|--------|---------|
| 1 | 代码审查规范是什么 | 规则触发，输出代码审查规范 |
| 2 | PR review要注意什么 | 规则触发，输出PR审查要点 |
| 3 | 审查优先级怎么定 | 规则触发，输出审查优先级 |
| 4 | Code Review流程 | 规则触发，输出Code Review流程 |
| 5 | 审查清单有哪些 | 规则触发，输出审查Checklist |

## Should NOT Trigger（不应触发）

| # | Prompt | 预期行为 |
|---|--------|---------|
| 1 | 写一个React组件 | ❌ 不触发 code-review-rules |
| 2 | 数据库设计 | ❌ 不触发 code-review-rules |
| 3 | 产品需求分析 | ❌ 不触发 code-review-rules |
| 4 | 系统架构设计 | ❌ 不触发 code-review-rules |
| 5 | 配置CI/CD | ❌ 不触发 code-review-rules |
