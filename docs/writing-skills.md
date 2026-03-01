# Writing Skills

Skills are markdown files that teach the agent how to do specific things. They live in `.po-agent/skills/<name>/SKILL.md`.

## Anatomy of a Skill

```markdown
---
name: my-skill
description: What this skill does. Shown in the skill list.
allowed-tools: Bash, Read, Edit    # Optional: restrict which tools this skill can use
disable-model-invocation: true      # Optional: prevents auto-loading (must be invoked with /my-skill)
---

# My Skill Title

Instructions for the agent in plain English/markdown.

## Step 1

Do this thing:

\`\`\`bash
some-command --flag
\`\`\`

## Step 2

Then do this other thing.
```

## How Skills Are Discovered

1. The action links framework default skills into `.claude/skills/`
2. Your `.po-agent/skills/` are linked on top — **your skills override framework defaults by name**
3. Claude Code discovers all skills in `.claude/skills/` at startup
4. Skills with `disable-model-invocation: true` must be invoked explicitly with `/skill-name`

## Overriding Built-in Skills

To override a built-in skill, create a file with the **same name**:

```
.po-agent/skills/code-quality/SKILL.md    ← Your override
```

This replaces the framework's `code-quality` skill entirely.

## Adding New Skills

Create a skill with any name that doesn't conflict:

```
.po-agent/skills/deploy-staging/SKILL.md    ← New skill (no framework equivalent)
```

The agent can invoke it with `/deploy-staging`.

## Referencing Other Skills

Skills can reference each other:

```markdown
After implementing, run `/code-quality` before pushing.
Then create a PR with `/pr-creation`.
```

## Passing Secrets to Skills

Skills can read environment variables. Pass secrets via the workflow:

```yaml
- uses: vyzn-tech/po-agent@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    secrets: |
      DB_HOST=${{ secrets.DB_HOST }}
      DB_PASSWORD=${{ secrets.DB_PASSWORD }}
```

Then in your skill:

```markdown
Connect to the database:
\`\`\`bash
mysql -h $DB_HOST -u readonly -p$DB_PASSWORD
\`\`\`
```

## Tips

- Keep skills focused — one skill per concern
- Use `allowed-tools` to restrict dangerous operations
- Use `disable-model-invocation: true` for workflow skills that should only run when explicitly invoked
- Skills are just markdown — they're simultaneously agent instructions AND human documentation
