---
name: code-quality
description: Run project-specific pre-push validation. MANDATORY before every git push.
allowed-tools: Bash
---

# Code Quality

Before every `git push`, run:

```bash
npm run lint:fix
npm run test
```

Both must pass. Only then push.
