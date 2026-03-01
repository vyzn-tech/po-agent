---
name: bug-fix-workflow
description: 9-phase workflow for fixing bugs. Covers investigation through verification and review request.
disable-model-invocation: true
---

# Bug Fix Workflow

Follow the phases in order.

## Phase 1-2: Investigation & Assessment

**Follow `/mandatory-gates` (Gates 1-3) first.**

Additionally during investigation:
1. Download and review any attached screenshots or logs
2. **Identify the affected user workflow** — what was the user trying to do?
3. If a URL or environment is specified, use Playwright to reproduce the bug
4. Document repro steps

**Wait for scope confirmation before proceeding (Gate 3)**

## Phase 3: Implementation

```bash
# Create branch and push immediately
git checkout -b fix/[short-description]
git commit --allow-empty -m "chore: init branch" && git push -u origin HEAD

# Commit after EVERY file change — uncommitted work is lost if session ends
git add <file> && git commit -m "WIP: description" && git push
```

## Phase 4: Validation

Run pre-push validation: `/code-quality`

If Playwright is available, verify the fix:
- Execute the original repro steps — bug should NOT reproduce
- Save screenshots to `/tmp/agent-artifacts/screenshots/`

## Phase 5: Create PR and Wait for CI

Use `/pr-creation` to create the PR.

```bash
# Wait for CI (inline — don't stop)
wait-for-checks <PR_NUMBER>
```

**After creating PR:** End your response and let CI run. The workflow will resume when CI completes.

## Phase 6: Resume — CI Results & Review Comments

When resumed after CI:
- **CI failed** → Fix the issues, push, end response (workflow auto-resumes)
- **CI passed** → Check for review comments using `/review-handling`:
  - If issues exist → fix, push, wait for CI again
  - If clean → proceed to Phase 7

## Phase 7: Preview (if available)

If your project has a preview deployment mechanism, trigger it and end your response.

## Phase 8: Resume — Verification

When resumed after preview:
- Verify on the preview environment
- Collect screenshot/video evidence
- If verification fails: fix, push, go back to CI

## Phase 9: Request Review

Post a summary of what was done and request human review.
