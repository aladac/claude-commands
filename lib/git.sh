#!/bin/bash
# Shared git functions for command scripts
# Source this file: source "$(dirname "$0")/../lib/git.sh"

# Stage all changes and return 1 if nothing to commit
git_stage_all() {
    git add -A
    if git diff --cached --quiet; then
        echo "No changes to commit"
        return 1
    fi
    return 0
}

# Show staged changes summary
git_show_staged() {
    echo "=== Staged changes ==="
    git diff --cached --stat
    echo ""
}

# Commit with message
git_commit() {
    local message="${1:-"Update $(date +%Y-%m-%d\ %H:%M)"}"
    git commit -m "$message"
}

# Push to remote
git_push() {
    local force="${1:-false}"
    echo ""
    if [[ "$force" == "true" ]]; then
        echo "=== Pushing (force-with-lease) ==="
        git push --force-with-lease
    else
        echo "=== Pushing ==="
        git push
    fi
}

# Show last commit
git_show_result() {
    local label="${1:-Committed}"
    echo ""
    echo "=== $label ==="
    git log -1 --oneline
}

# Parse --force/-f flag from arguments, returns remaining args via stdout
# Usage: MESSAGE=$(parse_force_flag "$@") ; FORCE is set as side effect
parse_force_flag() {
    FORCE=false
    local message=""
    for arg in "$@"; do
        case $arg in
            --force|-f)
                FORCE=true
                ;;
            *)
                if [[ -z "$message" ]]; then
                    message="$arg"
                fi
                ;;
        esac
    done
    echo "$message"
}
