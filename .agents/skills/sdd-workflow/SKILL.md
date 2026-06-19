---
name: sdd-workflow
description: >
  Full SDD cycle: clarify requirements → spec → design → task breakdown → delegate to SPDD.
  Use when the user brings a new feature or requirement from scratch.
---

Execute the full SDD cycle in order:

1. Clarify requirements — ask questions if ambiguous, confirm scope
2. Produce `sdd/specs/<feature>/spec.md` — problem statement, ACs, DoD
3. Produce `sdd/specs/<feature>/design.md` — technical design, architecture decisions
4. Produce `sdd/specs/<feature>/tasks.md` — small independent tasks, each implementable via spdd-analyze → spdd-canvas → spdd-risk-review → spdd-generate
5. Report task list to user and await execution order
