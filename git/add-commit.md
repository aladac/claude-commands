---
description: Stage all changes and commit with a brief 1-sentence summary
---

Quick commit workflow. Do not overanalyze.

1. Run `git add -A` to stage all changes
2. Run `git diff --cached --stat` to see what's staged
3. Run `git diff --cached` to see the actual changes (limit output if large)
4. Write a commit message:
   - ONE sentence only, max 72 characters
   - Use imperative mood ("Add", "Fix", "Update", not "Added", "Fixed")
   - Be specific but brief
   - No period at the end
5. Commit using: `git commit -m "Your message"`
6. Show the result with `git log -1 --oneline`

Do NOT:
- Ask for confirmation
- Write multi-line commit messages
- Overanalyze the changes
- Add Co-Authored-By
