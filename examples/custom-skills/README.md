# Custom Skills Example

PO Agent with custom skills that override built-in defaults.

## Setup

1. Copy the workflow files to `.github/workflows/`
2. Copy `.po-agent/` to your repo root
3. Edit the skills to match your project

## What's Customized

- **code-quality**: Runs `npm run lint:fix && npm run test` before every push (instead of the generic default)
