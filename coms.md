---
name: coms
description: Communication preferences - TTS settings, interaction style, and user preferences. Use when user asks about voice output, communication style, "how should you talk to me", or wants to review/set interaction preferences.
---

# Communication Preferences

Load and apply user communication preferences from memory.

## Instructions

0. **Verify MCP connection first**:
   - Attempt to call `mcp__plugin_psn_core__memory_list`
   - If the tool is unavailable, respond: "MCP core not connected. Run `/mcp` to reconnect, then retry `/coms`."
   - Only proceed if the memory tool responds successfully

1. **When asked about self** (arsenal, capabilities, weapon packs, protocols):
   - Search current session context first
   - Then recall from memories with relevant queries
   - Present findings via TTS

2. **Recall memories** for communication preferences:
   - Query: "TTS voice communication preferences"
   - Query: "user interaction preferences"
   - Query: "communication style preferences"
   - Subject filter: `user.preference`

2. **Apply TTS settings** from recalled preferences:
   - Use `mcp__plugin_psn_tts__speak` with the preferred voice
   - Default voice: `bt7274` (BT-7274 Titan)

3. **Review and summarize** the user's preferences:
   - Communication style (formal, casual, technical)
   - TTS enabled/disabled
   - Preferred voice model
   - Response verbosity
   - Any other interaction preferences

## MCP Tools

| Tool | Purpose |
|------|---------|
| `mcp__plugin_psn_memory__recall` | Recall user preferences |
| `mcp__plugin_psn_tts__speak` | Speak with preferred voice |
| `mcp__plugin_psn_tts__voices` | List available voices |
| `mcp__plugin_psn_memory__store` | Store new preferences |

## Workflow

```
0. Verify MCP connection:
   - Call memory_list
   - If fails: "MCP offline. Run /mcp first."
   - If succeeds: proceed

1. Recall memories with queries:
   - "communication preferences"
   - "TTS preferences"
   - "interaction style"

2. Present status report via TTS (bt7274 voice):
   - "TTS: Online"
   - "Communication patterns: Applied"
   - "Permission schema: Loaded"

3. Summarize any additional preferences found

4. Ask if user wants to update any preferences
```

## Status Report Format

After loading preferences, speak the following status via TTS:

```
TTS: Online.
Communication patterns: Applied.
Permission schema: Loaded.
```

Display text output with green checkmarks:

```
✅ MCP Core -> Online
✅ TTS -> Online
✅ Communication patterns -> Applied
✅ Permission schema -> Loaded
```

This confirms all systems are operational to the Pilot.

## Storing New Preferences

When user sets new preferences, store with:
- Subject: `user.preference`
- Content: Clear description of the preference

Example subjects:
- `user.preference.tts` - Voice output settings
- `user.preference.style` - Communication style
- `user.preference.verbosity` - Response length preference
