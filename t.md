---
description: Add a todo item to a project's TODO.md
---

Add a checkbox todo item to `~/Projects/{project}/TODO.md`.

## Usage

```
/t <project> "<todo item>"
```

## Execution

Run the script:
```bash
~/.claude/commands/t.sh "$project" "$item"
```

Then confirm via TTS (user prefers voice feedback).

## Examples

```
/t psn "Fix memory consolidation bug"
/t hu "Add --verbose flag"
```
