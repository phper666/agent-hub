# Error Handling Protocol

> 所有角色自动加载（内联于各角色 SKILL.md）。此处为共享参考版本。

| Exception | Handling |
|-----------|----------|
| **Required input file missing** | ❌ Stop and report: "Missing [file], waiting for [upstream role]" |
| **Input file present but empty** | ⚠️ Stop and report: "[file] is empty, check with [upstream role]" |
| **Input in unexpected format** | Try to parse; if fails, report and ask for clarification |
| **Tool/API failure** (markitdown, etc.) | Retry once; if still fails, proceed with available data and note the gap |
| **Timeout during task** | Save partial output, mark status as ⚠️ Partial |
