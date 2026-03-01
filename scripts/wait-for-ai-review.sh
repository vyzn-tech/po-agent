#!/usr/bin/env bash
# wait-for-ai-review.sh — Wait for AI review bot to post comments
# Usage: wait-for-ai-review <PR_NUMBER> [--timeout <minutes>]
set -euo pipefail

PR_NUMBER="${1:?Usage: wait-for-ai-review <PR_NUMBER> [--timeout <minutes>]}"
TIMEOUT_MINUTES="${3:-15}"
POLL_INTERVAL=20
ELAPSED=0
MAX_SECONDS=$((TIMEOUT_MINUTES * 60))

# Get initial comment count
INITIAL_REVIEWS=$(gh pr view "$PR_NUMBER" --json reviewThreads --jq '.reviewThreads | length' 2>/dev/null || echo "0")
echo "Waiting for AI review on PR #$PR_NUMBER (current threads: $INITIAL_REVIEWS, timeout: ${TIMEOUT_MINUTES}m)..."

while [ "$ELAPSED" -lt "$MAX_SECONDS" ]; do
  sleep "$POLL_INTERVAL"
  ELAPSED=$((ELAPSED + POLL_INTERVAL))

  CURRENT_REVIEWS=$(gh pr view "$PR_NUMBER" --json reviewThreads --jq '.reviewThreads | length' 2>/dev/null || echo "0")

  if [ "$CURRENT_REVIEWS" -gt "$INITIAL_REVIEWS" ]; then
    NEW_COUNT=$((CURRENT_REVIEWS - INITIAL_REVIEWS))
    echo "AI review complete — $NEW_COUNT new review thread(s) found"
    exit 0
  fi

  echo "[$(date +%H:%M:%S)] Waiting... ($CURRENT_REVIEWS threads, was $INITIAL_REVIEWS)"
done

echo "TIMEOUT — no new review threads after ${TIMEOUT_MINUTES} minutes"
echo "Continuing without AI review..."
exit 0
