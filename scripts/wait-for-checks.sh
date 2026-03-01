#!/usr/bin/env bash
# wait-for-checks.sh — Wait for all PR checks to complete
# Usage: wait-for-checks <PR_NUMBER> [--timeout <minutes>]
set -euo pipefail

PR_NUMBER="${1:?Usage: wait-for-checks <PR_NUMBER> [--timeout <minutes>]}"
TIMEOUT_MINUTES="${3:-30}"
POLL_INTERVAL=30
ELAPSED=0
MAX_SECONDS=$((TIMEOUT_MINUTES * 60))

echo "Waiting for checks on PR #$PR_NUMBER (timeout: ${TIMEOUT_MINUTES}m)..."

while [ "$ELAPSED" -lt "$MAX_SECONDS" ]; do
  # Get check status
  STATUS=$(gh pr checks "$PR_NUMBER" 2>&1) || true

  # Count statuses
  PENDING=$(echo "$STATUS" | grep -c "pending\|queued\|in_progress\|waiting" || true)
  FAILED=$(echo "$STATUS" | grep -c "fail\|error\|cancelled\|timed_out\|action_required" || true)
  PASSED=$(echo "$STATUS" | grep -c "pass\|success\|skipped\|neutral" || true)

  echo "[$(date +%H:%M:%S)] Checks: $PASSED passed, $PENDING pending, $FAILED failed"

  if [ "$PENDING" -eq 0 ]; then
    if [ "$FAILED" -gt 0 ]; then
      echo "CI FAILED — $FAILED check(s) failed"
      echo "$STATUS"
      exit 1
    else
      echo "All checks passed!"
      exit 0
    fi
  fi

  sleep "$POLL_INTERVAL"
  ELAPSED=$((ELAPSED + POLL_INTERVAL))
done

echo "TIMEOUT — checks did not complete within ${TIMEOUT_MINUTES} minutes"
echo "Current status:"
gh pr checks "$PR_NUMBER" 2>&1 || true
exit 2
