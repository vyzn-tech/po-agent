# Architecture

## Overview

```
┌─────────────────┐     ┌─────────────────────────────┐     ┌─────────────────┐
│  Trigger Source  │────▶│  GitHub Actions Workflow     │────▶│  Response       │
│                 │     │                             │     │                 │
│  • PR comment   │     │  1. actions/checkout        │     │  • PR comment   │
│  • Slack msg    │     │  2. vyzn-tech/po-agent@v1   │     │  • Slack reply  │
│  • Webhook      │     │     ├─ detect source        │     │  • Webhook      │
│  • Manual       │     │     ├─ install Claude Code  │     │                 │
│                 │     │     ├─ link skills          │     │                 │
│                 │     │     ├─ compose prompt        │     │                 │
│                 │     │     ├─ run agent             │     │                 │
│                 │     │     └─ post response         │     │                 │
└─────────────────┘     └─────────────────────────────┘     └─────────────────┘
```

## Source Detection

The action reads `$GITHUB_EVENT_PATH` (the full event payload JSON) to detect the source:

| Event | Source | How detected |
|-------|--------|-------------|
| `issue_comment` (on PR) | `github` | Native GitHub event, `issue.pull_request` exists |
| `issue_comment` (on issue) | `github-issue` | Native GitHub event, no `issue.pull_request` |
| `repository_dispatch` with `text` + `channel_id` | `slack` | Slack webhook relay |
| `repository_dispatch` with `pr_number` + `trigger_result` | `resume` | Resume workflow |
| `repository_dispatch` with `work_item_id` + `comment_text` | `azure-devops` | AzDo webhook relay |
| `repository_dispatch` (other) | `webhook` | Generic webhook |
| `workflow_dispatch` | `manual` | Manual trigger |

## Skill Linking

```
Framework skills/              Your .po-agent/skills/
├── bug-fix-workflow ──────┐   ├── code-quality ─────────┐
├── code-quality ──── SKIP │   ├── db-access ────────────┤
├── pr-creation ───────────┤   └── deploy-staging ───────┤
├── review-handling ───────┤                              │
└── ...                    │                              │
                           ▼                              ▼
                    .claude/skills/ (runtime)
                    ├── bug-fix-workflow  (framework)
                    ├── code-quality      (YOUR override)
                    ├── pr-creation       (framework)
                    ├── review-handling   (framework)
                    ├── db-access         (YOUR extension)
                    └── deploy-staging    (YOUR extension)
```

## Auto-Resume

The resume system uses GitHub labels to track state:

1. Agent pushes code → ends response
2. CI runs
3. `po-agent-resume.yml` triggers on CI completion
4. Checks if PR has `po-agent:waiting-ci` label
5. Dispatches `po-agent-resume` event
6. Main workflow runs again with `source=resume`

Labels used:
- `po-agent:waiting-ci` — waiting for CI/preview
- `po-agent:in-progress` — agent is running
- `po-agent:attempt-N` — tracks resume attempts
- `po-agent:failed` — max attempts exceeded

## Slack Integration

```
Slack app_mention → Webhook Relay → repository_dispatch → PO Agent → Slack reply
                    (Azure Function,
                     Lambda, or any
                     HTTP endpoint)
```

Deploy the webhook relay from `webhooks/slack/`. It receives Slack events and forwards them as `repository_dispatch` with `event_type: "slack-message"`.

## Prompt Composition

```
CLAUDE.md              ← Your project context (read by Claude Code automatically)
prompts/core.md        ← Agent persona + skill routing table
prompts/source-*.md    ← Source-specific behavior
context                ← PR details, thread history, resume info
user message           ← The actual request
```

## Concurrency & Queue Management

To prevent multiple agent runs from conflicting with each other, use GitHub Actions concurrency groups:

```yaml
jobs:
  agent:
    concurrency:
      group: po-agent-pr-${{ github.event.issue.number || github.event.client_payload.pr_number }}
      cancel-in-progress: false  # Don't cancel running agents
    runs-on: ubuntu-latest
    # ...
```

### Recommended patterns:

| Pattern | Concurrency Group | Use Case |
|---------|------------------|----------|
| One agent per PR | `po-agent-pr-${{ issue.number }}` | Default — prevents concurrent edits to same branch |
| One agent per repo | `po-agent` | Strict — only one agent runs at a time |
| Unlimited | (no concurrency) | Parallel — multiple agents can run simultaneously |

### Rate Limiting

- The Anthropic API has rate limits. If you see `429 Too Many Requests` errors, reduce `max_budget_usd` or add delays between triggers.
- For high-traffic repos, consider using `cancel-in-progress: true` to avoid queuing many runs.
- The resume system tracks attempts (up to `max_attempts`, default 10) to prevent infinite loops.

## Inputs Reference

| Input | Description | Default |
|-------|-------------|---------|
| `anthropic_api_key` | Anthropic API key (required) | — |
| `max_budget_usd` | Max spend per session | `5.0` |
| `model` | Claude model to use | `claude-sonnet-4-20250514` |
| `anthropic_base_url` | Custom API base URL (for proxies) | — |
| `timeout_minutes` | Timeout awareness for the agent | `0` (disabled) |
| `dry_run` | Stop after investigation, no code changes | `false` |
| `investigation_model` | Model for read-only tasks | — |
| `implementation_model` | Model for code-writing tasks | — |
| `trigger_word` | Keyword to invoke agent | `@po-agent` |
| `secrets` | Newline-separated KEY=VALUE env vars | — |
| `github_token` | GitHub token | `github.token` |
| `claude_cli_version` | Claude Code CLI version | `latest` |
