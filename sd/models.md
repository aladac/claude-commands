---
description: List available ComfyUI models (checkpoints and LoRAs)
---

List all available models from junkpile with CivitAI metadata and file sizes.

```bash
~/.claude/commands/sd/models.sh
```

The script outputs JSON sorted by filename. Display as a markdown table:

| Name | Filename | Size | Type |
|------|----------|------|------|
| {model_name} | {filename} | {size} | {model_type} |

Include a summary: "**X checkpoints, Y LoRAs**"
