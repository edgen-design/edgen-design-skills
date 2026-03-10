# Edgen Design Skills

AI-powered Figma skills for the Edgen design team.

## Skills
- `layer-rename` — Batch rename Figma layers to semantic names (FigmaToCode-ready)
- `qa-scan` — Pre-handoff quality check *(coming soon)*
- `annotation-review` — Review and write interaction annotations *(coming soon)*
- `token-sync` — Sync design tokens to Figma Variables *(coming soon)*

## Setup

```bash
git clone https://github.com/alex-evg/edgen-design-skills ~/.agents/skills/edgen-design-skills
```

Add to `~/.claude/CLAUDE.md`:
```
Include: ~/.agents/skills/edgen-design-skills/layer-rename/SKILL.md
```

## Updating

```bash
cd ~/.agents/skills/edgen-design-skills && git pull
```

