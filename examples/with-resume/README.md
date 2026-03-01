# With Auto-Resume

PO Agent with auto-resume — the agent automatically continues when CI completes.

## Setup

1. Copy both workflow files to `.github/workflows/` in your repo
2. Edit `po-agent-resume.yml` — change `"CI"` to your CI workflow name
3. Add `ANTHROPIC_API_KEY` to your repo secrets
