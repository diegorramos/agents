---
name: spdd-sync
description: Sync code changes back to the REASONS Canvas (code-to-prompt)
triggers:
  - user
  - model
subagent: true
allowed-tools:
  - read
  - grep
  - glob
  - write
  - edit
---

Compare the current code against the REASONS Canvas in `spdd/prompts/`. Identify any code-side changes (refactoring, fixes, new components) that are not reflected in the Canvas.

Update the Canvas to match the current code state.

This is a **code-to-prompt** sync (for prompt-to-code updates, use `/spdd-update` to fix the Canvas first then regenerate).
