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
| `issue_comment` | `github` | Native GitHub event |
| `repository_dispatch` with `text` + `channel_id` | `slack` | Slack webhook relay |
| `repository_dispatch` with `pr_number` + `trigger_result` | `resume` | Resume workflow |
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
