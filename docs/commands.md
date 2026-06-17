# 全部命令

> 终端运行 `agent-hub help` 查看最新命令列表。

## 初始化

```bash
agent-hub init                  # 在当前目录创建角色目录结构
```

## 平台检测

```bash
agent-hub detect                # 检测本地已安装的 Agent 平台
```

## 角色管理

```bash
agent-hub role list             # 列出所有角色
agent-hub role create <name>    # 创建角色模板
agent-hub role edit <name>      # 编辑角色 SKILL.md
agent-hub role delete <name>    # 删除角色
agent-hub role info <name>      # 查看角色详情
```

## 安装 / 卸载 / 更新

```bash
# 项目级
agent-hub install pm --project
agent-hub install all --project

# 全局
agent-hub install all --global

# 卸载
agent-hub uninstall pm --project

# 升级
agent-hub upgrade
```

## 导入 / 导出

```bash
agent-hub import /path/to/role-directory
agent-hub export pm --output pm.yaml
```

## 领域生成

```bash
agent-hub generate web          # Web 开发
agent-hub generate mobile       # 移动端
agent-hub generate api          # API 服务
agent-hub generate ml           # 机器学习
# 共 10 个领域模板
```

## 流水线

```bash
agent-hub pipeline status       # 查看流水线状态
agent-hub pipeline kanban       # 查看 Sprint 看板
agent-hub pipeline reset        # 重置状态
```

## 其他

```bash
agent-hub version               # 版本信息
agent-hub help                  # 帮助
```
