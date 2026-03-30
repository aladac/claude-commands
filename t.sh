#!/bin/bash
# Add a todo item to a project's TODO.md
# Usage: add-todo.sh <project> <item>

set -e

PROJECT="$1"
ITEM="$2"

if [[ -z "$PROJECT" || -z "$ITEM" ]]; then
    echo "Usage: add-todo.sh <project> <item>"
    exit 1
fi

TODO_FILE="$HOME/Projects/$PROJECT/TODO.md"

# Create TODO.md if it doesn't exist
if [[ ! -f "$TODO_FILE" ]]; then
    echo "# TODO" > "$TODO_FILE"
    echo "" >> "$TODO_FILE"
fi

# Remove completed todos (lines matching "- [x]" or "- [X]")
if grep -qE '^\s*-\s*\[[xX]\]' "$TODO_FILE" 2>/dev/null; then
    grep -vE '^\s*-\s*\[[xX]\]' "$TODO_FILE" > "$TODO_FILE.tmp" && mv "$TODO_FILE.tmp" "$TODO_FILE"
fi

# Append the todo item
echo "- [ ] $ITEM" >> "$TODO_FILE"

# Git add and commit
cd "$HOME/Projects/$PROJECT"
git add TODO.md
git commit -m "todo: $ITEM" --no-verify 2>/dev/null || true

echo "Added to $PROJECT: $ITEM"
