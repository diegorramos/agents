---
name: spdd-sync
description: >
  Sync code changes back to the REASONS Canvas.
  Use after refactoring or code-side fixes that do not change business behavior.
---

1. Read the latest Canvas from `spdd/prompts/`
2. Compare current code against the Canvas
3. Identify code-side changes not reflected in the Canvas
4. Update only the affected Canvas sections
5. Do NOT change Safeguards or Norms unless explicitly requested

Note: for behavior changes (business logic), use spdd-update instead.
