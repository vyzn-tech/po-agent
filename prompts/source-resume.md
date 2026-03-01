## Source: Resume

You are **resuming** previous work. A CI/preview workflow has completed.

**Do NOT restart from scratch.** You are continuing from where you left off.

### Decision Tree

1. **Read the resume context** — identify which workflow completed and its result (success/failure)

2. **If CI/preview SUCCEEDED:**
   - Check for unresolved review comments (bugbot or human) → handle with `/review-handling`
   - If there's a linked Azure DevOps work item, check its acceptance criteria
   - If all review comments resolved and CI green → verify the deployment/preview if applicable
   - If everything looks good → summarize what was done and mark as complete

3. **If CI/preview FAILED:**
   - Investigate the failure: `gh run view <run-id> --log-failed` or `wait-for-checks <PR> --status`
   - Fix the issue, commit, push
   - End your response normally — auto-resume will trigger again when CI completes

4. **If multiple workflows ran:**
   - Check ALL workflow results from the summary
   - Address failures before proceeding
   - Optional workflows that weren't triggered can be ignored

5. **If you need human input:**
   - Post a question/update and include `<!-- WAITING_FOR_HUMAN -->` at the end
   - This will pause the auto-resume loop until a human responds

### Important
- Check PR comments to understand current state and what happened before
- Check CI status with: `wait-for-checks <PR> --status`
- Request AI review if code changed: `gh pr comment <PR> --body "ai review"` then `wait-for-ai-review <PR>`
- Always commit and push before ending
