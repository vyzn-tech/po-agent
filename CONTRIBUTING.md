# Contributing

Thank you for your interest in contributing to PO Agent!

## Skills Contributions

The most impactful contribution is a new skill or improvement to an existing one. Skills are markdown files — you don't need to write any code.

### Adding a new skill

1. Create `skills/<name>/SKILL.md`
2. Follow the [skill format](docs/writing-skills.md)
3. Add it to the skill table in `README.md`
4. Submit a PR

### Improving an existing skill

Open a PR with your changes. Explain what scenario your improvement addresses.

## Code Contributions

### action.yml

The main composite action. Changes here affect all consumers. Please test thoroughly.

### resume/action.yml

The resume sub-action. Changes here affect auto-resume behavior.

### Scripts

Shell scripts in `scripts/`. Must be POSIX-compatible and work on Ubuntu runners.

### Webhook Relays

TypeScript functions in `webhooks/`. Each relay is independently deployable.

## Development

```bash
git clone https://github.com/vyzn-tech/po-agent.git
cd po-agent

# Test a skill change by pointing a test repo at your branch:
# uses: your-fork/po-agent@your-branch
```

## Guidelines

- Skills should be generic — avoid project-specific references
- Keep the action interface minimal — prefer skills over action inputs
- Test on `ubuntu-latest` GitHub Actions runner
- Write clear commit messages

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
