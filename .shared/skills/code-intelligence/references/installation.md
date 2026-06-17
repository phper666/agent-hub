# CodeGraph + code-review-graph 安装指南

> AI 可直接执行以下命令完成安装。用户说「帮我安装 CodeGraph 和 code-review-graph」触发。

---

## CodeGraph（日常开发必备）

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh

# 重启终端后
codegraph install        # 自动检测并配置所有 AI 编码工具
cd <project> && codegraph init  # 在项目中初始化（自动开始文件监听）
```

> **验证**：`codegraph status` 看图统计。之后无需手动 sync——文件保存后自动增量更新。
> **ZCode 用户**：安装后在 ZCode 设置 → 技能 → 导入，可一键导入。

---

## code-review-graph（审查增强）

```bash
pip install code-review-graph
# 或：pipx install code-review-graph

code-review-graph install   # 自动检测并配置所有平台
cd <project> && code-review-graph build  # 首次构建（500 文件约 10 秒）
code-review-graph watch     # 文件监听（也可用 code-review-graph update 手动更新）
```

> **验证**：`code-review-graph status` 查看统计。首次构建后 `code-review-graph update` 增量更新。

---

## 工具对比

| 维度 | CodeGraph | code-review-graph |
|------|-----------|-------------------|
| 定位 | 日常代码感知 | 深度架构审查 |
| 工具数 | 4 个核心 | 30 个 |
| 安装 | `curl \| sh`（自带运行时） | `pip install`（需 Python 3.10+） |
| 同步 | 自动（文件保存即更新） | 手动 build 或 watch 模式 |
| 特色 | 框架感知路由、零配置 | 影响半径、风险评分、社区检测 |
