# SDD + SPDD — Agent Orchestration Guide

This project follows **SDD** (Spec-Driven Development) for orchestration and **SPDD** (Structured Prompt-Driven Development) for execution.

Full methodology reference: `SPDD.md` (human reference — do not load unless explicitly needed).

---

## Language

- Responses to user: **Brazilian Portuguese (pt-BR)**
- All artifacts (specs, canvas, tests, code): **English**

---

## Artifact Structure

- `sdd/specs/<feature>/` — spec.md, design.md, tasks.md, stories.md (SDD artifacts)
- `spdd/analysis/` — strategic analysis, risk reviews
- `spdd/prompts/` — REASONS Canvas files
- `spdd/tests/` — functional tests + perf-* performance tests

---

## When the user asks for a new feature or requirement

```
1. sdd-workflow       <- clarify -> spec -> design -> task breakdown
2. spdd-story         <- break tasks into INVEST user stories
3. spdd-analyze       <- scan codebase, identify risks
4. spdd-canvas        <- generate REASONS Canvas
5. spdd-risk-review   <- validate risks before any code
6. spdd-generate      <- TDD implementation per Canvas task
7. spdd-perftest      <- performance tests last
```

## When the user asks to implement a single task (already has spec)

```
1. spdd-analyze       <- scan relevant codebase only
2. spdd-canvas        <- generate REASONS Canvas
3. spdd-risk-review   <- validate risks
4. spdd-generate      <- TDD implementation
```

## When requirements change

```
Behavior change (business logic):
1. spdd-update        <- update Canvas FIRST (prompt-first rule)
2. spdd-generate      <- regenerate affected code

Refactoring only (no behavior change):
1. Change code
2. spdd-sync          <- sync Canvas back to code
```

## When user asks for status

```
sdd-workflow status   <- report feature/task status from sdd/specs/
```

---

## Available Skills

### SDD — Orchestration
- `sdd-workflow` — Full cycle: clarify -> spec -> design -> task breakdown (with confirmation gates)

### SPDD — Execution
- `spdd-story`       — Break tasks into INVEST-compliant user stories
- `spdd-analyze`     — Analyze requirements, scan codebase, surface risks
- `spdd-canvas`      — Generate REASONS Canvas -> reads all 7 `spdd/[r|e|a|s|o|n|s]-*.md` files
- `spdd-risk-review` — Validate all risks before code generation -> reads `spdd/risks.md` + `spdd/a-approach.md`
- `spdd-generate`    — TDD implementation (Red -> Green -> Refactor) -> reads `spdd/tdd.md` + `spdd/n-norms.md`
- `spdd-test`        — Derive functional test scenarios for TDD
- `spdd-perftest`    — Generate performance tests -> reads `spdd/perftest.md` + `spdd/s-safeguards.md`
- `spdd-sync`        — Sync code changes back to Canvas
- `spdd-update`      — Update Canvas when requirements change (prompt-first)
- `spdd-review`      — Review implementation against Canvas -> reads `spdd/n-norms.md` + `spdd/s-safeguards.md`
