---
name: ci-wait-resume
description: Wait for CI checks to complete inline. Use when you need to block until CI/preview/review finishes.
allowed-tools: Bash
---

# CI Wait & Resume

## Inline Wait (blocking)

After pushing code or creating a PR, wait for CI checks inline:

```bash
wait-for-checks <PR_NUMBER>
```

This script polls `gh pr checks` until all checks complete or timeout.

## Wait for AI Review

If your project uses an AI code reviewer:

```bash
wait-for-ai-review <PR_NUMBER>
```

## Auto-Resume (non-blocking)

If auto-resume is configured (via `po-agent-resume.yml`), you can instead:

1. End your response with a clear status
2. The resume workflow will re-trigger the agent when CI completes

Use the `<!-- WAITING_FOR_HUMAN -->` token ONLY when waiting for human input.
For CI/automated processes, either wait inline or let auto-resume handle it.

## Which to Use

| Scenario | Approach |
|----------|----------|
| Quick CI (<5 min expected) | Inline wait with `wait-for-checks` |
| Long CI (>5 min) + auto-resume configured | End response, let auto-resume trigger |
| Waiting for human input | End response with `<!-- WAITING_FOR_HUMAN -->` |
