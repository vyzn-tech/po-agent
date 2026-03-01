---
name: merge-conflicts
description: Resolve merge conflicts by rebasing. Use when PR mergeable status is CONFLICTING.
allowed-tools: Bash
---

# Merge Conflict Resolution

## Check Status

```bash
gh pr view <PR_NUMBER> --json mergeable --jq '.mergeable'
```

- **MERGEABLE** → No conflicts
- **CONFLICTING** → Must resolve conflicts FIRST
- **UNKNOWN** → Wait 30 seconds and retry

## Resolve

```bash
git fetch origin main   # or your base branch
git rebase origin/main

# For each conflicting file:
# 1. Find markers: <<<<<<<, =======, >>>>>>>
# 2. Edit to keep correct code
# 3. git add <file>
# 4. git rebase --continue

git push --force-with-lease
```

## Critical

- **Always resolve conflicts BEFORE other changes**
- Use `--force-with-lease` (never `--force`)
- After resolving, verify the build still works
