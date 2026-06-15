#!/usr/bin/env bash
# ============================================================
#  Agent Hub 卸载脚本
#
#  用法：
#    curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/uninstall.sh | bash
#
#  或者下载后运行：
#    chmod +x uninstall.sh
#    ./uninstall.sh
# ============================================================

set -e

# 颜色
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'

info()  { echo -e "${BLUE}ℹ️  $1${NC}"; }
ok()    { echo -e "${GREEN}✅ $1${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $1${NC}"; }
fail()  { echo -e "${RED}❌ $1${NC}"; exit 1; }

# 配置
INSTALL_DIR="$HOME/.agent-hub"
BIN_DIR="$HOME/.local/bin"

# 确认卸载
confirm_uninstall() {
  echo ""
  echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║  🦞 Agent Hub 卸载程序                                     ║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""

  if [ ! -d "$INSTALL_DIR" ] && [ ! -f "$BIN_DIR/agent-hub" ]; then
    warn "Agent Hub 未安装"
    exit 0
  fi

  warn "即将卸载 Agent Hub，此操作不可撤销！"
  echo ""
  echo "将删除以下内容："
  echo "  - $INSTALL_DIR"
  echo "  - $BIN_DIR/agent-hub"
  echo ""
  read -p "确认卸载？(y/N): " -n 1 -r
  echo

  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    info "取消卸载"
    exit 0
  fi
}

# 卸载
uninstall() {
  echo ""
  info "开始卸载 Agent Hub..."
  echo ""

  # 删除安装目录
  if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    ok "已删除 $INSTALL_DIR"
  else
    info "安装目录不存在，跳过"
  fi

  # 删除符号链接
  if [ -f "$BIN_DIR/agent-hub" ]; then
    rm -f "$BIN_DIR/agent-hub"
    ok "已删除 $BIN_DIR/agent-hub"
  else
    info "符号链接不存在，跳过"
  fi

  # 检测 shell 配置文件
  local shell_rc=""
  local shell_name="$(basename "$SHELL")"

  case "$shell_name" in
    bash)
      shell_rc="$HOME/.bashrc"
      ;;
    zsh)
      shell_rc="$HOME/.zshrc"
      ;;
    fish)
      shell_rc="$HOME/.config/fish/config.fish"
      ;;
    *)
      warn "未知的 shell: $shell_name"
      ;;
  esac

  # 提示用户手动清理 PATH
  if [ -n "$shell_rc" ] && [ -f "$shell_rc" ]; then
    echo ""
    warn "请手动从 $shell_rc 中移除以下行："
    echo ""
    if [ "$shell_name" = "fish" ]; then
      echo "  set -gx PATH $BIN_DIR \$PATH"
    else
      echo "  export PATH=\"\$PATH:$BIN_DIR\""
    fi
    echo ""
    echo "或者运行以下命令自动移除："
    echo ""
    if [ "$shell_name" = "fish" ]; then
      echo "  sed -i '/set -gx PATH.*$BIN_DIR/d' $shell_rc"
    else
      echo "  sed -i '/export PATH=\"\$PATH:$BIN_DIR\"/d' $shell_rc"
    fi
  fi

  echo ""
  ok "卸载完成！"
  echo ""
  info "如果需要重新安装，请运行："
  echo "  curl -fsSL https://raw.githubusercontent.com/phper666/agent-hub/main/install.sh | bash"
  echo ""
}

# 主函数
main() {
  confirm_uninstall
  uninstall
}

main "$@"
