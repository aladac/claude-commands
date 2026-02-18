#!/bin/bash
# Quick add and commit with provided message
# Usage: add-commit.sh "commit message"
#        add-commit.sh  (uses timestamp if no message)
set -euo pipefail

MESSAGE="${1:-"Update $(date +%Y-%m-%d\ %H:%M)"}"

# Stage all changes
git add -A

# Check if there are staged changes
if git diff --cached --quiet; then
    echo "No changes to commit"
    exit 0
fi

# Show what's being committed
echo "=== Staged changes ==="
git diff --cached --stat
echo ""

# Commit
git commit -m "$MESSAGE"

# Show result
echo ""
echo "=== Committed ==="
git log -1 --oneline
