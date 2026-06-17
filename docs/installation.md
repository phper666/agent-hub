# 安装指南

## Linux

```bash
curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/install.sh | bash
```

## macOS

支持 Intel 和 Apple Silicon。自动适配 bash/zsh。

```bash
curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/install.sh | bash
```

## Windows

### 方案一：Git Bash（推荐）

1. 安装 [Git for Windows](https://gitforwindows.org)
2. 打开 Git Bash
3. 运行: `curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/install.sh | bash`

### 方案二：WSL

```powershell
wsl --install
wsl --install -d Ubuntu
```

然后在 WSL 中运行安装命令。

### 方案三：原生 Windows

有限支持。推荐使用 Git Bash 或 WSL。

## 卸载

```bash
curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/uninstall.sh | bash
```
