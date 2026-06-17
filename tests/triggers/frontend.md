# Frontend 角色触发验证

## Should Trigger（应触发）

| # | Prompt | 预期行为 |
|---|--------|---------|
| 1 | 写一个React组件 | 角色触发，输出React组件代码 |
| 2 | 状态管理怎么设计 | 角色触发，设计状态管理方案 |
| 3 | Tailwind样式怎么写 | 角色触发，输出Tailwind样式 |
| 4 | 前端路由设计 | 角色触发，设计前端路由方案 |
| 5 | 这个组件性能怎么优化 | 角色触发，提供性能优化建议 |
| 6 | 写个自定义Hook | 角色触发，输出自定义Hook |
| 7 | 表单验证逻辑 | 角色触发，实现表单验证 |
| 8 | 响应式布局实现 | 角色触发，输出响应式方案 |
| 9 | 前端打包配置 | 角色触发，配置打包工具 |

## Should NOT Trigger（不应触发）

| # | Prompt | 预期行为 | 应由谁响应 |
|---|--------|---------|-----------|
| 1 | 设计数据库表 | ❌ 不触发 Frontend | 应由 Backend 响应 |
| 2 | 写API文档 | ❌ 不触发 Frontend | 应由 Architect 响应 |
| 3 | 部署服务器 | ❌ 不触发 Frontend | 应由 Backend(DevOps) 响应 |
| 4 | 写PRD | ❌ 不触发 Frontend | 应由 PM 响应 |
| 5 | 测试覆盖率 | ❌ 不触发 Frontend | 应由 QA 响应 |
| 6 | 画UI原型 | ❌ 不触发 Frontend | 应由 Designer 响应 |
| 7 | Git工作流 | ❌ 不触发 Frontend | 应由 git-rules 规则响应 |

## 边界用例

| # | Prompt | 可能的响应角色 | 理由 |
|---|--------|--------------|------|
| 1 | 前端组件库选什么 | Frontend 或 Architect | 技术选型通常由Architect，但前端组件库Frontend更有发言权 |
| 2 | 这个交互用动画还是过渡 | Frontend 或 Designer | 实现方式vs设计决策 |
| 3 | 前端页面性能怎么样 | Frontend 或 QA | 性能优化vs性能测试 |
