#!/bin/bash
# Quick add, commit, and push with provided message
# Usage: add-commit-push.sh "commit message" [--force]
#        add-commit-push.sh --force "commit message"
#        add-commit-push.sh  (uses timestamp if no message)
set -euo pipefail

FORCE=false
MESSAGE=""

# Parse arguments
for arg in "$@"; do
    case $arg in
        --force|-f)
            FORCE=true
            ;;
        *)
            if [[ -z "$MESSAGE" ]]; then
                MESSAGE="$arg"
            fi
            ;;
    esac
done

# Default message if none provided
MESSAGE="${MESSAGE:-"Update $(date +%Y-%m-%d\ %H:%M)"}"

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

# Push
echo ""
if $FORCE; then
    echo "=== Pushing (force-with-lease) ==="
    git push --force-with-lease
else
    echo "=== Pushing ==="
    git push
fi

# Show result
echo ""
echo "=== Done ==="
git log -1 --oneline
