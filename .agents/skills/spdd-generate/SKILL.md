---
name: spdd-generate
description: >
  Implement code using strict TDD (Red -> Green -> Refactor) per Canvas Operations.
  Use after spdd-risk-review passes.
---

1. Read `spdd/tdd.md` for TDD rules and task done checklist
2. Read `spdd/n-norms.md` for naming, error handling, observability, and testing conventions
3. Read the latest Canvas from `spdd/prompts/`
4. For EACH task in Canvas Operations (in order):
   - RED: write failing test first, confirm it fails
   - GREEN: write minimal code to pass, confirm it passes
   - REFACTOR: clean up applying Norms, run all tests
5. Only advance to the next task when ALL checklist boxes are checked
6. No scope creep — strictly what the Canvas specifies
