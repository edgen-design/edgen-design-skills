// Edgen Layer Rename Plugin
// Receives a JSON rename plan from the UI and executes all renames in one go.
// Captures old names before renaming so rollback JSON is generated automatically.

figma.showUI(__html__, { width: 480, height: 600, title: "Edgen Layer Rename" });

figma.ui.onmessage = async (msg) => {
  if (msg.type === "execute-renames") {
    const renames = msg.renames; // [{ nodeId, newName }]
    const results = [];
    const rollback = [];
    let successCount = 0;
    let failCount = 0;

    for (const item of renames) {
      try {
        const node = await figma.getNodeByIdAsync(item.nodeId);
        if (!node) {
          results.push({ nodeId: item.nodeId, status: "error", reason: "Node not found" });
          failCount++;
          continue;
        }

        // Skip instances (IDs starting with "I")
        if (node.type === "INSTANCE") {
          results.push({ nodeId: item.nodeId, status: "skipped", reason: "Instance — skipped" });
          continue;
        }

        const oldName = node.name;

        // Skip if already has the target name
        if (oldName === item.newName) {
          results.push({ nodeId: item.nodeId, status: "skipped", reason: "Already named correctly" });
          continue;
        }

        rollback.push({ nodeId: item.nodeId, oldName, newName: item.newName });
        node.name = item.newName;
        results.push({ nodeId: item.nodeId, oldName, newName: item.newName, status: "ok" });
        successCount++;
      } catch (e) {
        results.push({ nodeId: item.nodeId, status: "error", reason: String(e) });
        failCount++;
      }
    }

    figma.ui.postMessage({
      type: "done",
      successCount,
      failCount,
      results,
      rollback,
    });
  }

  if (msg.type === "close") {
    figma.closePlugin();
  }
};
