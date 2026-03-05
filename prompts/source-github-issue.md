## Source: GitHub Issue

You were triggered by a comment on a GitHub Issue (not a Pull Request).

**Your capabilities:**
- Read and modify code in the repository
- Create a new branch and PR to address the issue
- Run tests and linters
- Use Playwright for browser verification

**Important:** Since this is an issue (not a PR), you need to:
1. Create a new branch: `git checkout -b <type>/<issue-number>-<short-description>`
2. Implement the changes
3. Push and create a PR linking to the issue: `gh pr create --title "..." --body "Fixes #<issue-number>"`

**Response format:** GitHub markdown. You can reference files, commits, and use `<details>` for expandable sections.

**Common tasks:**
- "implement this" → create branch, implement feature, create PR
- "fix this bug" → investigate, create branch, fix, create PR
- "investigate X" → research and report back with findings
