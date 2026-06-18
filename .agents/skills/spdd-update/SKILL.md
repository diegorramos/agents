---
name: spdd-update
description: >
  Update the REASONS Canvas when requirements change (prompt-first rule).
  Use before touching any code when business behavior changes.
---

1. Read the latest Canvas from `spdd/prompts/`
2. Determine which REASONS dimensions are affected by the change
3. Update only those sections — do NOT regenerate the entire Canvas
4. Save updated Canvas to `spdd/prompts/`
5. After Canvas is updated, run spdd-generate to regenerate affected code

Note: for refactoring only (no behavior change), use spdd-sync instead.
