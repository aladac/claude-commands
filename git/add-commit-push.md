---
description: Stage, commit with brief summary, and push (optional --force)
args:
  - name: force
    description: "Use --force-with-lease for push"
    type: boolean
    default: false
---

Quick commit and push workflow. Do not overanalyze.

1. Run `git add -A` to stage all changes
2. Run `git diff --cached --stat` to see what's staged
3. Run `git diff --cached` to see the actual changes (limit output if large)
4. Write a commit message:
   - ONE sentence only, max 72 characters
   - Use imperative mood ("Add", "Fix", "Update", not "Added", "Fixed")
   - Be specific but brief
   - No period at the end
5. Commit using: `git commit -m "Your message"`
6. Push to remote:
   - If `$ARGUMENTS` contains "force" or "--force": use `git push --force-with-lease`
   - Otherwise: use `git push`
7. Show the result with `git log -1 --oneline`

Do NOT:
- Ask for confirmation
- Write multi-line commit messages
- Overanalyze the changes
- Add Co-Authored-By
