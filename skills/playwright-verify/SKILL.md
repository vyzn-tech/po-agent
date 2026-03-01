---
name: playwright-verify
description: Browser verification using Playwright MCP. Navigate, interact, screenshot.
allowed-tools: Bash
---

# Playwright Verification

## Available Tools

| Tool | Purpose | Use when |
|------|---------|----------|
| `browser_navigate` | Navigate to a URL | Starting verification |
| `browser_snapshot` | Accessibility tree (~1-2 KB text) | Understanding page state — **preferred** |
| `browser_click` | Click elements | Interacting with UI |
| `browser_type` | Type into fields | Filling forms |
| `browser_take_screenshot` | Capture page as image (~1-2 MB) | Visual confirmation — **sparingly** |
| `browser_run_code` | Execute JavaScript | Saving screenshots to disk |

## Best Practices

### Prefer `browser_snapshot` over `browser_take_screenshot`
- `browser_snapshot` returns text (~1-2 KB) — use for understanding state
- `browser_take_screenshot` returns an image (~1-2 MB) — use only for visual confirmation

### Limit inline screenshots to ~3 per session
Exceeding this risks 413 payload errors that terminate the session.

### Save bulk evidence to disk

```javascript
// browser_run_code:
await page.screenshot({ path: '/tmp/agent-artifacts/screenshots/step-name.png', fullPage: true });
```

Save to `/tmp/agent-artifacts/screenshots/` — the workflow auto-uploads these.

## Verification Flow

1. Navigate to the target URL
2. Use `browser_snapshot` to understand page state
3. Interact and verify the change works
4. Save evidence screenshots to disk
5. Use `browser_take_screenshot` for the ONE key screenshot (max ~3 inline)
