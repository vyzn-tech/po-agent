---
name: pr-creation
description: Create GitHub pull requests with proper format.
allowed-tools: Bash
---

# Pull Request Creation

## Branch Naming

```
fix/short-description    # Bug fixes
feat/short-description   # Features
```

## PR Creation

```bash
gh pr create \
  --title "Description of change" \
  --body "## Summary
- What changed and why

## Test plan
- [ ] How to verify this works" \
  --base main
```

Keep the title concise (<70 chars). Include context in the body.

## After Creating PR

1. Run `/code-quality` to verify everything passes
2. Push any remaining changes
3. Wait for CI: `wait-for-checks <PR_NUMBER>` or let auto-resume handle it
