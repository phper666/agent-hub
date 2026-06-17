# Delivery Director 角色触发验证

## Should Trigger（应触发）

| # | Prompt | 预期行为 |
|---|--------|---------|
| 1 | 统筹这个项目 | 角色触发，输出项目统筹方案 |
| 2 | 调度一下开发团队 | 角色触发，调度团队成员 |
| 3 | 看看整体进度 | 角色触发，输出项目进度报告 |
| 4 | 这个Sprint进展如何 | 角色触发，输出Sprint进展 |
| 5 | 帮我协调前后端 | 角色触发，进行跨角色协调 |
| 6 | 现在有什么风险 | 角色触发，识别项目风险 |
| 7 | 里程碑到了吗 | 角色触发，检查里程碑状态 |
| 8 | 汇报一下进度 | 角色触发，输出进度汇报 |
| 9 | 创建新Sprint | 角色触发，创建新的Sprint迭代 |
| 10 | 全部做完了吗 | 角色触发，验收整体交付状态 |

## Should NOT Trigger（不应触发）

| # | Prompt | 预期行为 | 应由谁响应 |
|---|--------|---------|-----------|
| 1 | 具体写一个API | ❌ 不触发 Delivery Director | 应由 Backend 响应 |
| 2 | 画个按钮 | ❌ 不触发 Delivery Director | 应由 Designer 响应 |
| 3 | 修bug | ❌ 不触发 Delivery Director | 应由 Frontend/QA 响应 |
| 4 | 写测试 | ❌ 不触发 Delivery Director | 应由 QA 响应 |
| 5 | PRD审查 | ❌ 不触发 Delivery Director | 应由 PM 响应 |
| 6 | 帮我部署一下 | ❌ 不触发 Delivery Director | 应由 Backend(DevOps) 响应 |
| 7 | 这个组件怎么优化 | ❌ 不触发 Delivery Director | 应由 Frontend 响应 |

## 边界用例

| # | Prompt | 可能的响应角色 | 理由 |
|---|--------|--------------|------|
| 1 | 项目什么时候可以交付 | Delivery Director 或 PM | 交付日期可整体把控也涉及需求完整性 |
| 2 | 人手够不够 | Delivery Director 或 Router | 资源调度vs角色分配 |
| 3 | 客户反馈怎么处理 | Delivery Director 或 PM | 客户沟通可由PM初步处理但重大反馈需交付总监决策 |
