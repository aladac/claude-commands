---
description: Restart ComfyUI via Manager API on junkpile
---

Restart ComfyUI on junkpile using the ComfyUI Manager `/manager/reboot` endpoint.

```bash
~/.claude/commands/sd/restart.sh
```

The script:
1. Calls `GET /manager/reboot` on ComfyUI
2. Waits for ComfyUI to restart (polls `/system_stats` for up to 60 seconds)
3. Reports when ComfyUI is back online

After running, report the result to the user.
