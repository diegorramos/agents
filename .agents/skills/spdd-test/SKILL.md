---
name: spdd-test
description: >
  Derive functional test scenarios from the Canvas for TDD implementation.
  Use before or during spdd-generate. For performance tests use spdd-perftest.
---

1. Read the latest Canvas from `spdd/prompts/`
2. Derive test scenarios from Canvas Operations:
   - Normal flow
   - Boundary conditions
   - Error cases
   - Edge cases
3. Save to `spdd/tests/<feature>-tests.md`
