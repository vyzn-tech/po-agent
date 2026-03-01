# Webhook Relays

Webhook relays receive events from external services (Slack, Azure DevOps, Jira, etc.) and forward them to your GitHub repo as `repository_dispatch` events.

## How It Works

```
External Service → Webhook Relay → GitHub repository_dispatch → PO Agent workflow
```

The relay functions are lightweight HTTP handlers that:
1. Receive a webhook POST from the external service
2. Validate the payload
3. Forward it as a `repository_dispatch` event to your GitHub repo

## Available Relays

### Slack (`slack/`)
Receives Slack `app_mention` events and dispatches `slack-message` events.

### Azure DevOps (`azure-devops/`)
Receives Azure DevOps work item comment webhooks and dispatches `azure-devops-comment` events.

## Deployment

Each relay can be deployed as:
- **Azure Function** (Node.js)
- **AWS Lambda** (Node.js)
- **Cloudflare Worker**
- Any HTTP endpoint

See the individual relay directories for deployment instructions.

## Writing Your Own Relay

A relay just needs to POST to the GitHub API:

```bash
curl -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/OWNER/REPO/dispatches" \
  -d '{
    "event_type": "my-custom-event",
    "client_payload": {
      "text": "the message",
      "channel_id": "optional-for-slack",
      "any_field": "passed through to the agent"
    }
  }'
```

The PO Agent action reads `client_payload` and passes all fields to the agent.
