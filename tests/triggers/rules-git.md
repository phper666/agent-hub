# git-rules 规则触发验证

## Should Trigger（应触发）

| # | Prompt | 预期行为 |
|---|--------|---------|
| 1 | Git提交规范是什么 | 规则触发，输出Git提交规范 |
| 2 | commit message怎么写 | 规则触发，输出commit message规范 |
| 3 | 分支管理策略 | 规则触发，输出分支管理规范 |
| 4 | PR标准是什么 | 规则触发，输出PR审批标准 |
| 5 | 代码合并流程 | 规则触发，输出合并流程规范 |

## Should NOT Trigger（不应触发）

| # | Prompt | 预期行为 |
|---|--------|---------|
| 1 | 帮我写个API | ❌ 不触发 git-rules |
| 2 | 测试覆盖率不够 | ❌ 不触发 git-rules |
| 3 | 这个按钮颜色不对 | ❌ 不触发 git-rules |
| 4 | 系统架构评审 | ❌ 不触发 git-rules |
| 5 | 写PRD | ❌ 不触发 git-rules |
