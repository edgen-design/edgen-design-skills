#!/bin/bash
set -e

echo "=== Edgen Design Tools Setup ==="

# 1. Clone MCP server
if [ -d "$HOME/Desktop/edgen-figma-to-code-mcp" ]; then
  echo "✓ MCP server already installed, pulling latest..."
  cd "$HOME/Desktop/edgen-figma-to-code-mcp" && git pull
else
  echo "→ Cloning MCP server..."
  git clone https://github.com/edgen-design/edgen-figma-to-code-mcp.git "$HOME/Desktop/edgen-figma-to-code-mcp"
fi

# 2. Install bun (needed for socket server)
if ! command -v bun &>/dev/null; then
  echo "→ Installing bun..."
  curl -fsSL https://bun.sh/install | bash
  export PATH="$HOME/.bun/bin:$PATH"
else
  echo "✓ bun already installed"
fi

# 3. Build MCP server
echo "→ Building MCP server..."
cd "$HOME/Desktop/edgen-figma-to-code-mcp" && bun install && bun run build

# 4. Clone AI skills
if [ -d "$HOME/.agents/skills/edgen-design-skills" ]; then
  echo "✓ Skills already installed, pulling latest..."
  cd "$HOME/.agents/skills/edgen-design-skills" && git pull
else
  echo "→ Cloning AI skills..."
  mkdir -p "$HOME/.agents/skills"
  git clone https://github.com/edgen-design/edgen-design-skills.git "$HOME/.agents/skills/edgen-design-skills"
fi

# 5. Auto-start socket server on login (LaunchAgent)
mkdir -p "$HOME/Library/LaunchAgents"
PLIST="$HOME/Library/LaunchAgents/com.edgen.figma-socket.plist"
BUN_PATH=$(which bun 2>/dev/null || echo "$HOME/.bun/bin/bun")
cat > "$PLIST" << PLIST_EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.edgen.figma-socket</string>
  <key>ProgramArguments</key>
  <array>
    <string>$BUN_PATH</string>
    <string>run</string>
    <string>$HOME/Desktop/edgen-figma-to-code-mcp/src/socket.ts</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>$HOME/Library/Logs/edgen-figma-socket.log</string>
  <key>StandardErrorPath</key>
  <string>$HOME/Library/Logs/edgen-figma-socket.log</string>
</dict>
</plist>
PLIST_EOF
launchctl unload "$PLIST" 2>/dev/null || true
launchctl load "$PLIST"
echo "✓ Socket server registered as LaunchAgent (auto-starts on login, running now)"

# 6. Register MCP globally (works in any folder)
echo "→ Registering TalkToFigma MCP globally..."
if command -v claude &>/dev/null; then
  claude mcp add --global TalkToFigma node "$HOME/Desktop/edgen-figma-to-code-mcp/dist/server.cjs"
  if claude mcp list 2>/dev/null | grep -q "TalkToFigma"; then
    echo "✓ TalkToFigma MCP registered globally"
  else
    echo ""
    echo "⚠️  MCP 自動註冊失敗，請手動執行："
    echo "   claude mcp add --global TalkToFigma node $HOME/Desktop/edgen-figma-to-code-mcp/dist/server.cjs"
    echo ""
  fi
else
  echo ""
  echo "⚠️  claude CLI 未找到，請手動執行："
  echo "   claude mcp add --global TalkToFigma node $HOME/Desktop/edgen-figma-to-code-mcp/dist/server.cjs"
  echo ""
fi

# 7. Add to CLAUDE.md
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
mkdir -p "$HOME/.claude"
INCLUDE_LINE="Include: ~/.agents/skills/edgen-design-skills/layer-rename/SKILL.md"
if ! grep -qF "$INCLUDE_LINE" "$CLAUDE_MD" 2>/dev/null; then
  echo "" >> "$CLAUDE_MD"
  echo "$INCLUDE_LINE" >> "$CLAUDE_MD"
  echo "✓ Added skill to CLAUDE.md"
else
  echo "✓ CLAUDE.md already configured"
fi

echo ""
echo "✅ 完成！最後一步需要手動："
echo ""
echo "   Figma → Plugins → Development → Import plugin from manifest"
echo "   選擇：$HOME/Desktop/edgen-figma-to-code-mcp/src/cursor_mcp_plugin/manifest.json"
