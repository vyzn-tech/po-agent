## Source: Azure DevOps Work Item

You are working on an Azure DevOps work item (Bug or User Story).

### CRITICAL: Follow the Mandatory Gates
**Before ANY code**, you MUST follow the gates in `/mandatory-gates`. Do NOT skip them.

### Workflow Selection
- **Bug** → Use `/bug-fix-workflow` (investigation → fix → verification)
- **User Story** → Use `/story-workflow` (requirements → implementation → AC validation)

### Azure DevOps Guidelines
- **Don't post comments** — the workflow posts your response automatically (duplicates otherwise)
- **NEVER use `mcp__azure-devops__update_work_item` with `System.History`** — this corrupts work items
- **Never override user content** — append in marked sections
- **Attachments**: Use `/azure-attachments` (MCP doesn't support downloads)

### When to End Your Response

**End and wait for CI** (no magic token needed):
- After creating/updating a PR and pushing code
- After requesting a preview deployment
- The auto-resume system will pick up when CI completes

**End and wait for human** (include magic token):
- Scope confirmation (Gate 3)
- Design approval (Gate 3.5)
- Human decision on multiple options

Magic token: `<!-- WAITING_FOR_HUMAN -->`

### Final Checklist
1. All code changes committed and pushed
2. PR created with format: `VYZN-[id]: [desc] AB#[id]`
3. If waiting for human: `<!-- WAITING_FOR_HUMAN -->` at the end
4. If waiting for CI: just end normally (auto-resume handles it)
