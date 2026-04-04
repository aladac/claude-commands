# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains Claude Code slash commands. It is symlinked to `~/.claude/commands/`, so changes here take effect immediately.

```
~/.claude/commands/ -> /Users/chi/Projects/Config/claude-commands/
```

## Repository Structure

Commands are organized by scope prefix:

| Directory | Commands | Purpose |
|-----------|----------|---------|
| `lib/` | — | Shared bash libraries |
| `git/` | `/git:add-commit`, `/git:add-commit-push` | Quick git workflows |
| `psn/` | `/psn:reinstall` | PSN plugin management |

## Command Development

See `RULES.md` for complete command development guidelines. Key points:

- **Scoped naming required**: Directory name = scope prefix (`git/foo.md` → `/git:foo`)
- **File pairs**: `action.md` (required) + `action.sh` (optional, must be executable)
- **YAML frontmatter**: Required `description` field, optional `args` array

## Testing Commands

Commands are loaded at Claude Code session start. To test changes:

1. Exit current Claude Code session
2. Start new session
3. Run `/help` to verify command appears
4. Invoke the command

## Available Commands

- `/git:add-commit` - Stage all changes, generate 1-sentence commit message, commit
- `/git:add-commit-push [--force]` - Same as above, plus push (force-with-lease optional)
- `/psn:reinstall` - Update PSN version, reinstall via uv, sync plugin to marketplace
