# Architect 角色触发验证

## Should Trigger（应触发）

| # | Prompt | 预期行为 |
|---|--------|---------|
| 1 | 设计系统架构 | 角色触发，输出系统架构方案 |
| 2 | 画个API Spec | 角色触发，输出API规范 |
| 3 | 技术选型建议 | 角色触发，提供技术选型建议 |
| 4 | 微服务怎么拆分 | 角色触发，设计微服务拆分方案 |
| 5 | 数据库选型 | 角色触发，评估数据库方案 |
| 6 | 系统性能瓶颈在哪 | 角色触发，分析性能瓶颈 |
| 7 | 画个时序图 | 角色触发，输出时序图 |
| 8 | 这个架构方案评审一下 | 角色触发，进行架构评审 |
| 9 | bounded context怎么划分 | 角色触发，进行DDD领域划分 |

## Should NOT Trigger（不应触发）

| # | Prompt | 预期行为 | 应由谁响应 |
|---|--------|---------|-----------|
| 1 | 帮我写个登录页面 | ❌ 不触发 Architect | 应由 Frontend/Designer 响应 |
| 2 | 修一个CSS bug | ❌ 不触发 Architect | 应由 Frontend 响应 |
| 3 | 写PRD | ❌ 不触发 Architect | 应由 PM 响应 |
| 4 | 写测试用例 | ❌ 不触发 Architect | 应由 QA 响应 |
| 5 | 这个按钮颜色 | ❌ 不触发 Architect | 应由 Designer 响应 |
| 6 | 部署流水线配置 | ❌ 不触发 Architect | 应由 Backend(DevOps) 响应 |
| 7 | Git分支策略 | ❌ 不触发 Architect | 应由 git-rules 规则响应 |

## 边界用例

| # | Prompt | 可能的响应角色 | 理由 |
|---|--------|--------------|------|
| 1 | 这个技术方案成本如何 | Architect 或 Delivery Director | 技术成本可由Architect评估但交付总监关注预算 |
| 2 | API应不应该版本化 | Architect 或 Backend | 架构决策vs后端实现细节 |
| 3 | 这个系统需要什么样的监控 | Architect 或 Backend(DevOps) | 架构设计需指定监控策略，但实现由DevOps负责 |
