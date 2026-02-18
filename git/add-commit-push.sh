#!/bin/bash
# Quick add, commit, and push with provided message
# Usage: add-commit-push.sh "commit message" [--force]
#        add-commit-push.sh --force "commit message"
#        add-commit-push.sh  (uses timestamp if no message)
set -euo pipefail

source "$(dirname "$0")/../lib/git.sh"

MESSAGE=$(parse_force_flag "$@")

git_stage_all || exit 0
git_show_staged
git_commit "$MESSAGE"
git_push "$FORCE"
git_show_result "Done"
