# Code Intelligence 工具速查卡片

## CodeGraph（默认 4 个工具 + 4 个隐藏）

| 工具 | 用途 | 提示 |
|------|------|------|
| `codegraph_explore` | 一次调用回答大多数问题 | 返回源码 + 关系图 |
| `codegraph_node` | 符号源码 + 调用链，或按路径读文件 | 传入函数名或文件路径 |
| `codegraph_search` | 全项目符号全文搜索 (FTS5) | 搜符号名 |
| `codegraph_callers` | 谁调了这个函数（含回调注册） | 同名函数按定义分组 |
| `codegraph_impact` ⚠️ | 变更影响半径 | 默认隐藏 |
| `codegraph_callees` ⚠️ | 函数调用了谁 | 默认隐藏 |

> ⚠️ 启用：`CODEGRAPH_MCP_TOOLS=explore,node,search,callers,impact,callees`

---

## code-review-graph（15/30 精选）

| 工具 | 用途 |
|------|------|
| `get_minimal_context_tool` | 超紧凑上下文（~100 token），优先调用 |
| `get_impact_radius_tool` | 改动的完整影响半径 |
| `get_review_context_tool` | Token 优化的审查上下文 |
| `detect_changes_tool` | 风险评分 + 变更影响分析 |
| `get_affected_flows_tool` | 哪些执行流受影响 |
| `query_graph_tool` | 调用者/被调用者/测试/导入/继承 |
| `get_hub_nodes_tool` | 架构热点（连接最多的节点） |
| `get_bridge_nodes_tool` | 架构瓶颈（介数中心性） |
| `get_knowledge_gaps_tool` | 未测试热点、薄弱社区 |
| `get_surprising_connections_tool` | 意外跨社区耦合 |
| `get_suggested_questions_tool` | 自动生成审查问题 |
| `refactor_tool` | 重命名预览、死代码检测 |
| `list_flows_tool` | 按关键度排序的执行流 |
| `traverse_graph_tool` | 从任意节点 BFS/DFS 探索 |
| `semantic_search_nodes_tool` | 按名称或语义搜索代码实体 |

> 完整列表见 [code-review-graph README](https://github.com/tirth8205/code-review-graph)
