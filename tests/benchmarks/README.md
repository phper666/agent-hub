# Agent Hub 基准测试

## 目的

通过标准化任务，量化评估 agent-hub 角色对 AI 输出质量的提升效果。

## 测试方法

对每个测试任务：
1. **Baseline 运行**：在不安装 agent-hub 角色的情况下，用相同的 prompt 让 AI 完成任务
2. **With Agent Hub 运行**：安装对应角色后，用相同的 prompt 再次运行
3. **盲评**：评分者不知道哪份输出是 baseline、哪份是 with-agent-hub
4. **计算提升比**：对比两组的四维评分

## 评分维度

| 维度 | 1 分 | 3 分 | 5 分 |
|------|------|------|------|
| **完整性 (Completeness)** | 缺失主要章节 | 覆盖核心需求 | 边界条件全部考虑 |
| **技术准确性 (Technical Accuracy)** | 包含事实性错误 | 基本正确 | 专家级准确度 |
| **格式规范性 (Format Quality)** | 无结构纯文本 | 基本遵循模板 | 专业排版、可执行 |
| **实用性 (Practicality)** | 不可执行 | 稍作修改可用 | 开箱即用 |

## 目标

基于 Harness benchmark (+60%, 49.5→79.3, n=15) 的保守外推，目标提升：
- PM 角色: +25-35%（PRD 质量）
- Backend 角色: +30-40%（API 实现质量）
- QA 角色: +20-30%（测试计划质量）

## 贡献

1. 按 `tasks/` 目录下的模板编写新的测试任务
2. 分别运行 baseline 和 with-agent-hub
3. 按评分标准盲评
4. 将结果放入 `results/` 目录
5. 提交 PR 更新本 README 的统计数据
