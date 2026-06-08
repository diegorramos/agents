---
name: spdd-review
description: Review implementation against the REASONS Canvas
triggers:
  - user
  - model
subagent: true
allowed-tools:
  - read
  - grep
  - glob
  - exec
---

Review the current implementation against the REASONS Canvas.

Check:
1. **Architecture** — Does the code follow the 3-tier/defined architecture?
2. **Business logic** — Does the Service layer match the Canvas intent?
3. **Scope** — Are changes confined to Canvas boundaries?

Report any gaps found, referencing specific file paths and line numbers.
