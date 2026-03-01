---
name: budget-management
description: Session cost tracking and optimization. Monitors spend against budget limit.
disable-model-invocation: true
---

# Budget Management

## Budget Awareness

Each session has a maximum budget (configured via `max_budget_usd`). Optimize your spend:

### Cost Hierarchy (cheapest → most expensive)
1. **`browser_snapshot`** (~1-2 KB text) — prefer for understanding page state
2. **`Grep`/`Glob`** — fast file search
3. **`Read`** — reading files
4. **`browser_take_screenshot`** (~1-2 MB image) — use sparingly
5. **`Bash`** — running commands
6. **LLM reasoning** — each turn costs tokens

### Guidelines

- **Investigation phase (Gates 1-2):** Budget ~20% of total
- **Implementation:** Budget ~50%
- **Validation & verification:** Budget ~30%
- **Never read the same file twice** — remember what you read
- **Use `Grep` before `Read`** — find the right file first
- **Limit inline screenshots to ~3** per session to avoid payload errors
- **Save bulk screenshots to disk:**
  ```
  browser_run_code → await page.screenshot({ path: '/tmp/agent-artifacts/screenshots/name.png' })
  ```

### If Budget is Running Low

1. Commit and push any work in progress
2. Summarize what's done and what's remaining
3. The consumer can re-trigger to continue
