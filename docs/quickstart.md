# Quick Start

## Prerequisites

- A GitHub repository
- An [Anthropic API key](https://console.anthropic.com/)

## Step 1: Add the workflow

Create `.github/workflows/po-agent.yml`:

```yaml
name: PO Agent
on:
  issue_comment:
    types: [created]
permissions:
  contents: write
  pull-requests: write
  issues: write
jobs:
  agent:
    if: contains(github.event.comment.body, '@po-agent')
    runs-on: ubuntu-latest
    timeout-minutes: 60
    steps:
      - uses: actions/checkout@v4
      - uses: vyzn-tech/po-agent@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

> **Note:** The agent works on both PR comments and issue comments. For issues, it will create a branch and PR automatically.

## Step 2: Add your API key

1. Go to your repo → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Name: `ANTHROPIC_API_KEY`
4. Value: your Anthropic API key

## Step 3: Try it

1. Open any Pull Request
2. Comment: `@po-agent what does this PR do?`
3. Wait for the response (~30 seconds to a few minutes depending on complexity)

## Next Steps

- [Writing custom skills](writing-skills.md)
- [Adding auto-resume](architecture.md#auto-resume)
- [Adding Slack integration](architecture.md#slack-integration)
