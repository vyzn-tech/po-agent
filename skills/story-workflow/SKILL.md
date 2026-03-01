---
name: story-workflow
description: 9-phase workflow for implementing user stories. Covers requirements through verification.
disable-model-invocation: true
---

# User Story Workflow

Follow the phases in order.

## Phase 1-2: Requirements & Assessment

**Follow `/mandatory-gates` (Gates 1-3) first.**

Additionally:
1. Identify all acceptance criteria
2. Break down into subtasks
3. Evaluate UX impact — does this change visible user behavior?

**Wait for scope confirmation before proceeding (Gate 3)**

## Phase 3: Implementation

```bash
# Create branch and push immediately
git checkout -b feat/[short-description]
git commit --allow-empty -m "chore: init branch" && git push -u origin HEAD

# Commit after EVERY file change
git add <file> && git commit -m "WIP: description" && git push
```

Work through subtasks in order. Commit frequently.

## Phase 4: Validation

Run `/code-quality` before pushing.

If Playwright is available:
- Walk through the user flow end-to-end
- Verify all acceptance criteria
- Save screenshots to `/tmp/agent-artifacts/screenshots/`

## Phase 5: Create PR and Wait for CI

Use `/pr-creation` to create the PR.

```bash
wait-for-checks <PR_NUMBER>
```

## Phase 6: Resume — CI & Review

When resumed after CI:
- **CI failed** → Fix, push, end response
- **CI passed** → Handle review comments with `/review-handling`

## Phase 7-8: Preview & Verification

If preview is available, trigger it, verify acceptance criteria on preview.

## Phase 9: Request Review

Post a summary mapping each acceptance criterion to evidence.
