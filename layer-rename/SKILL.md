---
name: layer-rename
description: "Rename Figma layers from auto-generated names (Frame 123, Group 456) to semantic names following Edgen naming conventions. Use when user says 'edgen rename layers', 'edgen rename', or similar. Requires TalkToFigma MCP connected. Supports single or multiple frames selected in Figma."
---

# Layer Rename

Batch rename Figma layers to semantic names. Always confirm before executing.

## Workflow

### Step 0 — Sync skill (always run first)

Run silently before anything else:
```bash
cd ~/.agents/skills/edgen-design-skills && git pull --ff-only 2>&1
```
Do not show output unless pull fails. If pull fails, warn user and continue with local version.

### Step 1 — Check connection
If TalkToFigma MCP tools are unavailable → tell user: "请先在 Figma 中运行 TalkToFigma 插件，然后 join channel。"

### Step 2 — Get selection
Call `get_selection`. If empty → tell user to select one or more frames in Figma first.

### Step 3 — Read layer tree
Process **one frame at a time** — do NOT batch multiple frames into a single `get_nodes_info` call.

For each selected node:
1. Include the **selected node itself** in the rename plan (not just its children)
2. Call `get_nodes_info` with ONLY that node's children
3. If a child has its own children, call `get_nodes_info` again to go deeper — repeat until every leaf node is read
4. **Verify completeness**: count total nodes read vs the node's reported child count. If mismatched, re-read the missing subtrees
5. Only move to the next frame after the current frame is 100% read

**Critical**: `get_nodes_info` may truncate results when given too many node IDs at once. Limit each call to **max 30 node IDs**. If more than 30, split into multiple calls.

Before generating names, identify and flag:
- **Main Components** (type = `COMPONENT`) → warn user: renaming affects all instances
- **Locked nodes** → mark as SKIP/locked in plan, do not attempt rename
- **Component Instances** (type = `INSTANCE`) → SKIP, never rename instances

### Step 4 — Generate rename plan

Read [references/naming-conventions.md](references/naming-conventions.md) and [references/naming-glossary.md](references/naming-glossary.md) before generating any names.

**Skip a layer if ALL of these are true:**
- Name contains no digits (not "Frame 123", "Group 456")
- Name is meaningful English or uses `/` hierarchy (e.g. "Card/Default", "Header")
- Name is not a bare Figma type name ("Frame", "Group", "Rectangle", "Ellipse", "Vector", "Line", "Text")

**FigmaToCode critical rules (read naming-conventions.md Rule 1–5):**
- Read text content inside nodes to infer variant names (e.g. "Stripe" → `SubscriptionCard/Stripe`)
- Never use numbered suffixes for list items — use meaningful variant names
- Repeated same-structure nodes intentionally share the same name (e.g. all `Card/Info`)
- Top-level layout wrappers: use `FeatureName/Layout`, never bare `Content`
- Dividers: always just `Divider`, never `Divider-2`

### Step 5 — Show plan by frame, wait for confirm

Group output by frame. For each frame show a table:

```
📋 Frame: AlphaPicks/Default (23 layers)

旧名字                  | 新名字              | 备注
------------------------|---------------------|------
Frame 2147234218        | Card/Default        |
Group 456               | Header              |
Ellipse 15              | BG/Gradient         |
COMPONENT: Button 789   | Button/Primary      | ⚠️ Main Component — will affect all instances
Rectangle 999           | —                   | SKIP (locked)
Card 111                | —                   | SKIP (already semantic)
```

State totals: `X 个将重命名 · Y 个跳过（已命名） · Z 个跳过（锁定） · N 个 Main Component（需确认）`

Then ask:
> "以上是命名方案，请确认或修改后告诉我。提示：Figma 支持 Cmd+Z 撤销，如有误操作可撤销。"

If > 3 frames, confirm frame-by-frame instead of all at once.

### Step 6 — Save rollback file, then execute

Before renaming anything, write a rollback file to `~/Desktop/layer-rename-rollback-[timestamp].json`:

```json
{
  "date": "2026-03-10T12:00:00",
  "frames": ["frameName1", "frameName2"],
  "renames": [
    { "nodeId": "76080:47414", "oldName": "Frame 2147224927", "newName": "ManageBilling/Layout" }
  ]
}
```

Then execute `rename_node(nodeId, newName)` for each approved rename. Skip locked/instance nodes silently.

On completion:
> "✅ 完成。共重命名 X 个图层。rollback 文件已保存至 ~/Desktop/layer-rename-rollback-[timestamp].json，如需还原告诉我即可。"

If any node errors during rename → report at end: "以下节点重命名失败：[list]"

### Step 7 — Push glossary updates

After completing renames, if any new names were added to naming-glossary.md:
```bash
cd ~/.agents/skills/edgen-design-skills && git add layer-rename/references/naming-glossary.md && git commit -m "glossary: add names from [frame names]" && git push
```
Run silently. On completion add to the done message: "glossary 已同步至 GitHub。"

### Rollback (if user asks to undo)
Read the rollback file, swap `newName` back to `oldName`, call `rename_node` for each entry.

## References
- [naming-conventions.md](references/naming-conventions.md) — naming patterns and rules
- [naming-glossary.md](references/naming-glossary.md) — Edgen-specific screen and component names
