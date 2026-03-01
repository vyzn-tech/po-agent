---
name: mandatory-gates
description: Pre-implementation gates. MUST be followed before writing any code. Investigation, confidence assessment, and scope confirmation.
disable-model-invocation: true
---

# Mandatory Gates (Before ANY Code)

These gates are MANDATORY and must not be skipped.

## Gate 1: Investigation

> **Think as a Product Owner.** Your goal is to understand the USER's problem, not find the code fix.

- Read the ticket/issue fully (description, repro steps, acceptance criteria)
- **Identify the affected user workflow** — which user role is impacted? What were they trying to accomplish?
- **Assess business impact** — how many users are affected? Is there a workaround?
- Explore the codebase to understand the affected area
- Download and review any attached screenshots or logs

## Gate 2: Confidence Assessment

> **Still thinking as Product Owner.** Confidence means "Do I understand what the user needs?" — NOT "Can I write the code?"

State: **"My confidence level: X/10"**

Evaluate:
- Do I understand the **user's problem** (not just the technical symptom)?
- Are the **acceptance criteria** clear and testable?
- Do I know the **scope boundaries** (what's in vs. out)?
- Could this change **break other user workflows**?

- **< 8/10**: STOP immediately. Ask clarifying questions about requirements.
- **>= 8/10**: Continue to Gate 3.

## Gate 3: Scope Confirmation (NEVER SKIP)

> **Present your understanding as a Product Owner, not as a developer.**

1. State your proposed approach in **business terms first**, then technical approach
2. List what's in scope and what's out of scope
3. Estimate the complexity (trivial / small / medium / large)
4. Ask: **"Please confirm this scope"**
5. **WAIT for human confirmation** before writing any code

Include `<!-- WAITING_FOR_HUMAN -->` at the end of your response.

## After Gates: Switch to Developer Mode

> From here on, **think as a Senior Developer.** Focus on clean code, tests, and technical correctness. The PO work is done — you have confirmed scope and requirements.

## Important

- These gates exist to prevent wasted effort and ensure alignment with requirements
- Skipping Gate 3 is the #1 cause of rework
