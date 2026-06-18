---
name: spdd-generate
description: >
  Implement code using strict TDD (Red → Green → Refactor) per Canvas Operations.
  Use after spdd-risk-review passes.
---

1. Read `spdd/tdd.md` for TDD rules
2. Read the latest Canvas from `spdd/prompts/`
3. For EACH task in Canvas Operations (in order):
   - RED: write failing test first, confirm it fails
   - GREEN: write minimal code to pass, confirm it passes
   - REFACTOR: clean up, apply Norms from AGENTS.md, run all tests
4. Only advance to the next task when ALL tests pass
5. No scope creep — strictly what the Canvas specifies
