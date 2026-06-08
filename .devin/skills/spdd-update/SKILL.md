---
name: spdd-update
description: Update REASONS Canvas when requirements change (prompt-first)
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
  - exec
---

Incrementally update the REASONS Canvas when requirements change.

1. Determine which REASONS dimensions are affected by the change
2. Update only those sections — do NOT regenerate the entire Canvas
3. After updating the Canvas, regenerate code to match

This is **prompt-first**: intent changes first, then code follows.
