# Command Development Rules

## Directory Structure

Commands are organized by scope in subdirectories:

```
commands/
├── RULES.md           # This file
├── lib/               # Shared script libraries
│   └── git.sh         # Git helper functions
├── git/               # /git:* commands
│   ├── add-commit.md
│   └── add-commit.sh
├── psn/               # /psn:* commands
│   ├── reinstall.md
│   └── reinstall.sh
└── docs/              # /docs:* commands
    └── ...
```

## Naming Convention

### Scoped Commands (Required)

All commands MUST be scoped with a prefix:

- `/git:add-commit` not `/add-commit`
- `/psn:reinstall` not `/reinstall`
- `/docs:sync` not `/sync`

Directory name = scope prefix.

### File Naming

- Command file: `{action}.md` (e.g., `add-commit.md`)
- Script file: `{action}.sh` (e.g., `add-commit.sh`)
- Names use kebab-case

## File Structure

### Command File (.md)

Every command has a markdown file with YAML frontmatter:

```yaml
---
description: Brief description shown in /help
args:                           # Optional
  - name: force
    description: "Use force push"
    type: boolean
    default: false
---

Instructions for Claude to follow when command is invoked.
```

### Script File (.sh)

Every command SHOULD have a matching executable script:

```bash
#!/bin/bash
# Brief description
# Usage: script.sh [args]
set -euo pipefail

# Implementation
```

Scripts must be executable (`chmod +x`).

### Shared Libraries (lib/)

Reusable functions live in `lib/`. Source them in scripts:

```bash
#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/../lib/git.sh"

git_stage_all || exit 0
git_show_staged
git_commit "$MESSAGE"
```

Available libraries:
- `lib/git.sh` - Git operations (stage, commit, push, show)

## When to Use Scripts vs Instructions

| Approach | Use When |
|----------|----------|
| Script only | Deterministic operations, no AI judgment needed |
| Instructions only | AI must analyze/generate content |
| Both | Script handles mechanics, AI generates input (e.g., commit messages) |

## Examples

### Script-heavy (reinstall)
```markdown
---
description: Reinstall PSN
---
```bash
~/.claude/commands/psn/reinstall.sh
```
```

### Instruction-heavy (add-commit)
```markdown
---
description: Stage and commit with brief summary
---

1. Run `git add -A`
2. Analyze changes
3. Generate 1-sentence commit message
4. Commit
```

## Checklist

- [ ] Scoped directory (`git/`, `psn/`, `docs/`)
- [ ] Command file (`action.md`)
- [ ] Script file (`action.sh`) if applicable
- [ ] Script is executable
- [ ] Frontmatter has description
- [ ] kebab-case naming
