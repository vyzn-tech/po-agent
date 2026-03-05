#!/bin/bash
# validate-skill.sh — Validates that a skill directory has the correct structure
# Usage: validate-skill.sh <skill-directory>
# Exit codes: 0 = valid, 1 = invalid

set -euo pipefail

SKILL_DIR="${1:-.}"
ERRORS=0
WARNINGS=0

log_error() { echo "❌ ERROR: $1"; ERRORS=$((ERRORS + 1)); }
log_warn()  { echo "⚠️  WARN:  $1"; WARNINGS=$((WARNINGS + 1)); }
log_ok()    { echo "✅ OK:    $1"; }

# Check directory exists
if [ ! -d "$SKILL_DIR" ]; then
  log_error "Directory '$SKILL_DIR' does not exist"
  exit 1
fi

SKILL_NAME=$(basename "$SKILL_DIR")
echo "=== Validating skill: $SKILL_NAME ==="
echo ""

# 1. Check SKILL.md exists
if [ -f "$SKILL_DIR/SKILL.md" ]; then
  log_ok "SKILL.md exists"
else
  log_error "SKILL.md not found (required)"
fi

# 2. Check SKILL.md has content
if [ -f "$SKILL_DIR/SKILL.md" ]; then
  LINES=$(wc -l < "$SKILL_DIR/SKILL.md" | tr -d ' ')
  if [ "$LINES" -gt 5 ]; then
    log_ok "SKILL.md has $LINES lines"
  else
    log_warn "SKILL.md only has $LINES lines — consider adding more detail"
  fi

  # Check for title heading or frontmatter
  if head -5 "$SKILL_DIR/SKILL.md" | grep -qE '^#|^---'; then
    log_ok "SKILL.md has a title heading or frontmatter"
  else
    log_warn "SKILL.md missing title heading or frontmatter (should start with # or ---)"
  fi

  # Check for numbered steps or structured workflow
  if grep -qE '^\d+\.|^- \[|^## Step|^### Phase' "$SKILL_DIR/SKILL.md"; then
    log_ok "SKILL.md has structured steps"
  else
    log_warn "SKILL.md lacks structured steps (numbered lists, checkboxes, or step headings)"
  fi
fi

# 3. Check for README.md (optional documentation)
if [ -f "$SKILL_DIR/README.md" ]; then
  log_ok "README.md exists (optional docs)"
fi

# 4. Check for naming convention (lowercase-kebab-case)
if echo "$SKILL_NAME" | grep -qE '^[a-z][a-z0-9-]*$'; then
  log_ok "Skill name follows kebab-case convention"
else
  log_warn "Skill name '$SKILL_NAME' should be lowercase-kebab-case (e.g. my-skill)"
fi

# 5. Check for hidden files or large binaries
HIDDEN_FILES=$(find "$SKILL_DIR" -name '.*' -not -name '.' 2>/dev/null | head -5)
if [ -n "$HIDDEN_FILES" ]; then
  log_warn "Hidden files found: $HIDDEN_FILES"
fi

LARGE_FILES=$(find "$SKILL_DIR" -type f -size +100k 2>/dev/null | head -5)
if [ -n "$LARGE_FILES" ]; then
  log_warn "Large files (>100KB) found: $LARGE_FILES"
fi

# Summary
echo ""
echo "=== Summary ==="
echo "Errors:   $ERRORS"
echo "Warnings: $WARNINGS"

if [ "$ERRORS" -gt 0 ]; then
  echo ""
  echo "❌ Skill validation FAILED"
  exit 1
else
  echo ""
  echo "✅ Skill validation PASSED"
  exit 0
fi
