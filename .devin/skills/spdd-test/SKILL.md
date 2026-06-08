---
name: spdd-test
description: Derive functional test scenarios for TDD implementation
triggers:
  - user
  - model
subagent: true
allowed-tools:
  - read
  - grep
  - glob
  - write
---

Read the latest REASONS Canvas from `spdd/prompts/`. Derive FUNCTIONAL test scenarios from the Operations section for TDD implementation.

Cover:
- Normal flow (happy path)
- Boundary conditions
- Error cases (validation failures, auth failures, not found, conflict)
- Edge cases (empty data, large payloads, concurrent access)

Format each scenario as a structured Given/When/Then.

Save to `spdd/tests/` with a descriptive name.

For performance tests, use `/spdd-perftest` instead.
