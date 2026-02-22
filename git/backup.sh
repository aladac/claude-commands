#!/bin/bash
# Backup all git repos in ~/Projects - add, commit, push
set -uo pipefail

PROJECTS_DIR="$HOME/Projects"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M")

echo "=== Backing up repos in $PROJECTS_DIR ==="
echo ""

pushed=()
skipped=()
failed=()

for dir in "$PROJECTS_DIR"/*/; do
    [[ -d "$dir/.git" ]] || continue

    repo=$(basename "$dir")
    cd "$dir" || continue

    # Stage all changes
    git add -A 2>/dev/null

    # Check if there are changes to commit
    if git diff --cached --quiet 2>/dev/null; then
        skipped+=("$repo")
        continue
    fi

    echo "[$repo]"
    git diff --cached --stat

    # Commit
    if ! git commit -m "Backup $TIMESTAMP" 2>/dev/null; then
        failed+=("$repo (commit)")
        continue
    fi

    # Push
    if git push 2>/dev/null; then
        pushed+=("$repo")
    else
        failed+=("$repo (push)")
    fi
    echo ""
done

echo "=== Summary ==="
echo "Pushed: ${#pushed[@]} repos"
[[ ${#pushed[@]} -gt 0 ]] && printf "  - %s\n" "${pushed[@]}"

echo "Skipped (no changes): ${#skipped[@]} repos"

if [[ ${#failed[@]} -gt 0 ]]; then
    echo "Failed: ${#failed[@]} repos"
    printf "  - %s\n" "${failed[@]}"
fi
