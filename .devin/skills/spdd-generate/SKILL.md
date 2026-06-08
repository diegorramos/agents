---
name: spdd-generate
description: Implement code using TDD (Red → Green → Refactor) per Canvas Operations
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

Read the latest REASONS Canvas from `spdd/prompts/`. For each task in the Operations section (in order), follow strict TDD:

**RED — Write the test first**
- Write a failing test that defines the expected behavior
- Test must be meaningful: covers the acceptance criterion, not implementation details
- Run the test → confirm it fails (red)

**GREEN — Write minimal code to pass**
- Implement the simplest code that makes the test pass
- No premature optimization, no extra features, no scope creep
- Run the test → confirm it passes (green)

**REFACTOR — Clean up**
- Improve code quality without changing behavior
- Apply Norms (naming, error handling, observability)
- Run ALL existing tests → confirm nothing broke

**Only advance to the next task when ALL tests pass.**
If any test fails → fix it immediately before moving on.

Adhere to the Norms and Safeguards defined in the Canvas. No scope creep. Verify against acceptance criteria after each task.
