#!/usr/bin/env bash
# ============================================================
#  Agent Hub 安装脚本
#
#  用法：
#    # Linux/macOS
#    curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/install.sh | bash
#
#    # Windows (Git Bash / WSL)
#    curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/install.sh | bash
#
#  或者下载后运行：
#    chmod +x install.sh
#    ./install.sh
# ============================================================

set -e

# 颜色（支持 Windows Terminal 和 Git Bash）
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'

info()  { echo -e "${BLUE}ℹ️  $1${NC}"; }
ok()    { echo -e "${GREEN}✅ $1${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $1${NC}"; }
fail()  { echo -e "${RED}❌ $1${NC}"; exit 1; }

# 配置
REPO="phper666/agent-hub"
INSTALL_DIR="$HOME/.agent-hub"
BIN_DIR="$HOME/.local/bin"
VERSION="latest"

# 检测操作系统
detect_os() {
  local os="$(uname -s)"
  case "$os" in
    Linux*)     echo "linux";;
    Darwin*)    echo "macos";;
    CYGWIN*|MINGW*|MSYS*) echo "windows";;
    *)          echo "unknown";;
  esac
}

# 检测架构
detect_arch() {
  local arch="$(uname -m)"
  case "$arch" in
    x86_64|amd64)  echo "x64";;
    arm64|aarch64)  echo "arm64";;
    *)              echo "unknown";;
  esac
}

# 检测 shell 环境
detect_shell() {
  # 优先使用 SHELL 环境变量
  if [ -n "$SHELL" ]; then
    basename "$SHELL"
  # Windows Git Bash
  elif [ -n "$MSYSTEM" ]; then
    echo "bash"
  # WSL
  elif grep -qi microsoft /proc/version 2>/dev/null; then
    echo "bash"
  else
    echo "unknown"
  fi
}

# 检测是否在 Windows 环境
is_windows() {
  local os=$(detect_os)
  [ "$os" = "windows" ]
}

# 检测是否在 WSL 环境
is_wsl() {
  grep -qi microsoft /proc/version 2>/dev/null
}

# 检测是否在 Git Bash 环境
is_git_bash() {
  [ -n "$MSYSTEM" ]
}

# 检查依赖
check_dependencies() {
  local deps=("git" "curl")
  local missing=()

  for dep in "${deps[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
      missing+=("$dep")
    fi
  done

  if [ ${#missing[@]} -gt 0 ]; then
    # Windows 特殊处理
    if is_windows; then
      fail "缺少依赖: ${missing[*]}。请安装 Git for Windows (https://gitforwindows.org)"
    else
      fail "缺少依赖: ${missing[*]}。请先安装这些工具。"
    fi
  fi
}

# 检查是否已安装
check_existing() {
  if [ -d "$INSTALL_DIR" ]; then
    warn "检测到已安装 Agent Hub"
    read -p "是否重新安装？(y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      info "取消安装"
      exit 0
    fi
    info "将覆盖现有安装..."
  fi
}

# 克隆或更新仓库
clone_or_update() {
  if [ -d "$INSTALL_DIR/.git" ]; then
    info "更新现有仓库..."
    cd "$INSTALL_DIR"
    git fetch origin main
    git reset --hard origin/main
    git clean -fd
  else
    info "克隆仓库..."
    rm -rf "$INSTALL_DIR"
    git clone "https://github.com/$REPO.git" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
  fi
}

# 创建 bin 目录和符号链接
setup_symlink() {
  mkdir -p "$BIN_DIR"

  # 创建启动脚本
  cat > "$BIN_DIR/agent-hub" << 'EOF'
#!/usr/bin/env bash
# Agent Hub 启动脚本
SCRIPT_DIR="$HOME/.agent-hub"
exec "$SCRIPT_DIR/agent-hub" "$@"
EOF

  chmod +x "$BIN_DIR/agent-hub"
  chmod +x "$INSTALL_DIR/agent-hub"

  # Windows 特殊处理：创建 .cmd 文件
  if is_windows; then
    cat > "$BIN_DIR/agent-hub.cmd" << 'EOF'
@echo off
REM Agent Hub 启动脚本 (Windows)
"%USERPROFILE%\.agent-hub\agent-hub" %*
EOF
    ok "已创建 Windows 启动脚本: $BIN_DIR/agent-hub.cmd"
  fi
}

# 配置 PATH
setup_path() {
  local shell_rc=""
  local shell_name=$(detect_shell)

  # Windows 特殊处理
  if is_windows; then
    setup_path_windows
    return
  fi

  case "$shell_name" in
    bash)
      shell_rc="$HOME/.bashrc"
      # macOS 使用 .bash_profile
      if [ "$(detect_os)" = "macos" ] && [ -f "$HOME/.bash_profile" ]; then
        shell_rc="$HOME/.bash_profile"
      fi
      ;;
    zsh)
      shell_rc="$HOME/.zshrc"
      ;;
    fish)
      shell_rc="$HOME/.config/fish/config.fish"
      ;;
    *)
      warn "未知的 shell: $shell_name。请手动添加 $BIN_DIR 到 PATH。"
      return
      ;;
  esac

  # 检查是否已添加到 PATH
  if grep -q "$BIN_DIR" "$shell_rc" 2>/dev/null; then
    info "PATH 已配置"
    return
  fi

  # 添加到 PATH
  if [ "$shell_name" = "fish" ]; then
    echo "set -gx PATH $BIN_DIR \$PATH" >> "$shell_rc"
  else
    echo "" >> "$shell_rc"
    echo "# Agent Hub" >> "$shell_rc"
    echo "export PATH=\"\$PATH:$BIN_DIR\"" >> "$shell_rc"
  fi

  ok "已添加到 PATH（重启终端后生效）"
}

# Windows PATH 配置
setup_path_windows() {
  info "检测到 Windows 环境"

  if is_git_bash; then
    # Git Bash
    local shell_rc="$HOME/.bashrc"
    if grep -q "$BIN_DIR" "$shell_rc" 2>/dev/null; then
      info "PATH 已配置"
      return
    fi
    echo "" >> "$shell_rc"
    echo "# Agent Hub" >> "$shell_rc"
    echo "export PATH=\"\$PATH:$BIN_DIR\"" >> "$shell_rc"
    ok "已添加到 Git Bash PATH（重启终端后生效）"
  elif is_wsl; then
    # WSL
    local shell_rc="$HOME/.bashrc"
    if grep -q "$BIN_DIR" "$shell_rc" 2>/dev/null; then
      info "PATH 已配置"
      return
    fi
    echo "" >> "$shell_rc"
    echo "# Agent Hub" >> "$shell_rc"
    echo "export PATH=\"\$PATH:$BIN_DIR\"" >> "$shell_rc"
    ok "已添加到 WSL PATH（重启终端后生效）"
  else
    # 原生 Windows (CMD/PowerShell)
    warn "检测到原生 Windows 环境"
    echo ""
    echo "请手动添加以下目录到系统 PATH："
    echo "  $BIN_DIR"
    echo ""
    echo "或者使用 Git Bash / WSL 运行 Agent Hub。"
    echo ""
    echo "推荐安装 Git for Windows: https://gitforwindows.org"
  fi
}

# 验证安装
verify_installation() {
  info "验证安装..."

  if [ -f "$INSTALL_DIR/agent-hub" ] && [ -x "$INSTALL_DIR/agent-hub" ]; then
    ok "安装成功！"
  else
    fail "安装失败，请检查错误信息"
  fi
}

# 显示安装后信息
show_post_install() {
  echo ""
  echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║  🦞 Agent Hub 安装完成！                                   ║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "${GREEN}安装位置:${NC} $INSTALL_DIR"
  echo -e "${GREEN}执行文件:${NC} $BIN_DIR/agent-hub"

  # Windows 特殊提示
  if is_windows; then
    echo ""
    if is_git_bash; then
      echo -e "${YELLOW}检测到 Git Bash 环境${NC}"
      echo "请重启 Git Bash 使 PATH 生效。"
    elif is_wsl; then
      echo -e "${YELLOW}检测到 WSL 环境${NC}"
      echo "请运行: source ~/.bashrc"
    else
      echo -e "${YELLOW}检测到原生 Windows 环境${NC}"
      echo "推荐使用 Git Bash 或 WSL 运行 Agent Hub。"
    fi
  fi

  echo ""
  echo -e "${YELLOW}快速开始:${NC}"
  echo ""
  echo "  1. 重启终端，或运行以下命令使 PATH 生效："

  if is_windows; then
    if is_git_bash; then
      echo "     source ~/.bashrc"
    elif is_wsl; then
      echo "     source ~/.bashrc"
    else
      echo "     # 重启 CMD 或 PowerShell"
    fi
  else
    local shell_name=$(detect_shell)
    case "$shell_name" in
      zsh)  echo "     source ~/.zshrc";;
      bash) echo "     source ~/.bashrc";;
      fish) echo "     source ~/.config/fish/config.fish";;
      *)    echo "     # 重启终端";;
    esac
  fi

  echo ""
  echo "  2. 检测已安装的 Agent 平台："
  echo "     agent-hub detect"
  echo ""
  echo "  3. 初始化项目："
  echo "     cd your-project"
  echo "     agent-hub init"
  echo ""
  echo "  4. 安装角色："
  echo "     agent-hub install all --global"
  echo ""
  echo "  5. 根据领域生成角色（可选）："
  echo "     agent-hub generate web"
  echo ""
  echo -e "${CYAN}更多信息:${NC} https://github.com/$REPO"
  echo ""
}

# 卸载函数
uninstall() {
  echo ""
  info "卸载 Agent Hub..."
  echo ""

  # 删除安装目录
  if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    ok "已删除 $INSTALL_DIR"
  fi

  # 删除符号链接
  if [ -f "$BIN_DIR/agent-hub" ]; then
    rm -f "$BIN_DIR/agent-hub"
    ok "已删除 $BIN_DIR/agent-hub"
  fi

  # 删除 Windows .cmd 文件
  if [ -f "$BIN_DIR/agent-hub.cmd" ]; then
    rm -f "$BIN_DIR/agent-hub.cmd"
    ok "已删除 $BIN_DIR/agent-hub.cmd"
  fi

  # 提示用户手动清理 PATH
  warn "请手动从 shell 配置文件中移除以下行："
  echo "  export PATH=\"\$PATH:$BIN_DIR\""
  echo ""
  ok "卸载完成"
}

# 主函数
main() {
  echo ""
  echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║  🦞 Agent Hub 安装程序                                     ║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""

  # 检查是否卸载
  if [ "$1" = "--uninstall" ] || [ "$1" = "-u" ]; then
    uninstall
    exit 0
  fi

  # 检测环境
  local os=$(detect_os)
  local arch=$(detect_arch)
  info "检测到系统: $os ($arch)"

  # Windows 特殊提示
  if is_windows; then
    if is_git_bash; then
      info "运行环境: Git Bash"
    elif is_wsl; then
      info "运行环境: WSL (Windows Subsystem for Linux)"
    else
      warn "运行环境: 原生 Windows（推荐使用 Git Bash 或 WSL）"
    fi
  fi

  # 检查依赖
  check_dependencies

  # 检查已安装
  check_existing

  # 克隆或更新
  clone_or_update

  # 设置符号链接
  setup_symlink

  # 配置 PATH
  setup_path

  # 验证安装
  verify_installation

  # 显示安装后信息
  show_post_install
}

main "$@"
