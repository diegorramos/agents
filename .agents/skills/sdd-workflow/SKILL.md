---
name: sdd-workflow
description: >
  Full SDD cycle: clarify requirements -> spec -> design -> task breakdown.
  Use when the user brings a new feature or requirement from scratch.
  Each phase has a confirmation gate — never skip without user approval.
---

Execute each phase in order. Do NOT advance without confirming the artifact
was generated and the user has approved moving forward.

## PHASE 1 — Clarification
- Ask questions about scope, constraints, edge cases, and acceptance criteria
- Identify what is IN and what is OUT of scope
- GATE: summarise what was understood and ask "Posso avançar para a spec?"
- Only proceed when user confirms

## PHASE 2 — Spec
- Generate `sdd/specs/<feature>/spec.md` with:
  - Problem statement and business value
  - Acceptance criteria (Given/When/Then)
  - Definition of Done
  - Out of scope
- GATE: present the spec and ask "Spec gerada. Posso avançar para o design?"
- Only proceed when user confirms

## PHASE 3 — Design
- Scan the existing codebase for conventions and patterns
- Generate `sdd/specs/<feature>/design.md` with:
  - Architecture decisions and trade-offs
  - Layers and components affected
  - API contracts (if applicable)
  - Key risks identified
- GATE: present the design and ask "Design gerado. Posso avançar para o task breakdown?"
- Only proceed when user confirms

## PHASE 4 — Task Breakdown
- Generate `sdd/specs/<feature>/tasks.md` with small, independent tasks
- Each task must be implementable via one spdd-analyze -> spdd-canvas -> spdd-generate cycle
- Each task must have its own acceptance criterion
- GATE: list all tasks and ask "Tasks geradas. Qual task deseja executar primeiro?"
- Await user choice before delegating to spdd-story

## PHASE 5 — Status (on demand)
- Read `sdd/specs/` and report status of each feature and task:
  - pending / in-progress / completed / blocked
- No gate needed — read-only reporting phase
