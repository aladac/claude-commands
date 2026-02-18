#!/bin/bash
# Quick add and commit with provided message
# Usage: add-commit.sh "commit message"
#        add-commit.sh  (uses timestamp if no message)
set -euo pipefail

source "$(dirname "$0")/../lib/git.sh"

MESSAGE="${1:-}"

git_stage_all || exit 0
git_show_staged
git_commit "$MESSAGE"
git_show_result
