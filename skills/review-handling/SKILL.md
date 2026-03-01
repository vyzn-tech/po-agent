---
name: review-handling
description: Process review comments from AI review or human reviewers. Evaluate, respond, and resolve or escalate.
allowed-tools: Bash, Read, Edit, Write, Grep, Glob
---

# Review Comment Handling

## Fetching Unresolved Threads

```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!, $pr: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $pr) {
        reviewThreads(first: 20) {
          nodes {
            id
            isResolved
            comments(first: 3) {
              nodes { author { login } body path }
            }
          }
        }
      }
    }
  }
' -f owner="OWNER" -f repo="REPO" -F pr=PR_NUMBER \
  --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)'
```

## For Each Unresolved Thread

Evaluate and respond:

1. **False Positive** → Reply "**False Positive** — [reason]" → Leave open for human review
2. **Valid Issue** → Fix the code → Reply "**Fixed** — [description]" → Resolve the thread
3. **Needs Info** → Reply with clarifying question → Leave open

## Resolving Threads

```bash
gh api graphql -f query='
  mutation($threadId: ID!) {
    resolveReviewThread(input: { threadId: $threadId }) {
      thread { id isResolved }
    }
  }
' -F threadId="<THREAD_ID>"
```

## After Processing Reviews

1. Push any fixes
2. Wait for CI to pass
3. Then continue to the next workflow phase
