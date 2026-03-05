#!/bin/bash
# validate-all-skills.sh — Validates all skills in the skills/ directory
# Usage: validate-all-skills.sh [skills-directory]

set -uo pipefail

SKILLS_DIR="${1:-$(dirname "$0")/../skills}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOTAL=0
PASSED=0
FAILED=0

echo "=== Validating all skills in: $SKILLS_DIR ==="
echo ""

for skill_dir in "$SKILLS_DIR"/*/; do
  [ ! -d "$skill_dir" ] && continue
  TOTAL=$((TOTAL + 1))

  if "$SCRIPT_DIR/validate-skill.sh" "$skill_dir"; then
    PASSED=$((PASSED + 1))
  else
    FAILED=$((FAILED + 1))
  fi
  echo ""
done

echo "==============================="
echo "Total: $TOTAL | Passed: $PASSED | Failed: $FAILED"
echo "==============================="

[ "$FAILED" -gt 0 ] && exit 1
exit 0
