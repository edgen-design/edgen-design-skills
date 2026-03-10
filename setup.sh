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

# 2. Build MCP server
echo "→ Building MCP server..."
cd "$HOME/Desktop/edgen-figma-to-code-mcp" && npm install && npm run build

# 3. Clone AI skills
if [ -d "$HOME/.agents/skills/edgen-design-skills" ]; then
  echo "✓ Skills already installed, pulling latest..."
  cd "$HOME/.agents/skills/edgen-design-skills" && git pull
else
  echo "→ Cloning AI skills..."
  mkdir -p "$HOME/.agents/skills"
  git clone https://github.com/edgen-design/edgen-design-skills.git "$HOME/.agents/skills/edgen-design-skills"
fi

# 4. Add to CLAUDE.md
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
echo ""
echo "   然後喺 .mcp.json 加入："
echo '   "TalkToFigma": {'
echo '     "command": "node",'
echo "     \"args\": [\"$HOME/Desktop/edgen-figma-to-code-mcp/dist/server.cjs\"]"
echo '   }'
