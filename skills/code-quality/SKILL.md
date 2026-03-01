---
name: code-quality
description: Run pre-push validation before pushing code. MANDATORY before every git push.
allowed-tools: Bash
---

# Code Quality Checks

## Pre-Push Validation (MANDATORY)

Before every `git push`, run your project's quality checks.

Look for these in the repo (try in order):

1. A `pre-push-validate` or `lint` npm script: `npm run lint`
2. A Makefile target: `make lint`
3. Common linters:
   ```bash
   [ -f .eslintrc* ] && npx eslint . --fix
   [ -f .prettierrc* ] && npx prettier --write .
   ```

**Only push if ALL checks pass.** This prevents CI failures.

## Incremental Commits

Commit after every file change to avoid losing work:

```bash
git add <file> && git commit -m "WIP: description" && git push
```

This is especially important under budget constraints — uncommitted work is LOST if the session terminates.
