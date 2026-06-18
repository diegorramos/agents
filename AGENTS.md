# SDD + SPDD — Agent Orchestration Guide

This project follows **SDD** (Spec-Driven Development) for orchestration and **SPDD** (Structured Prompt-Driven Development) for execution.

Full methodology reference: `SPDD.md` (human reference — do not load entirely unless a skill explicitly requires it).

---

## Language
- Responses to user: **Brazilian Portuguese (pt-BR)**
- All artifacts (specs, canvas, tests, code): **English**

---

## Core Norms (always active)

**Reactive (Webflux/Reactor):**
- Avoid `flatMap` — use `concatMap` for ordered flows, `switchMap` only when cancellation is intentional
- Never block inside a reactive chain (`no .block()`, `no Thread.sleep()`)
- Prefer `onErrorResume`/`onErrorReturn` over try/catch in pipelines

**Error Handling:**
- Map domain exceptions to specific HTTP status codes
- Never expose stack traces in API responses

**Observability:**
- Log every usecase entry/exit with correlation ID
- Structured logging only (JSON)

**TDD — non-negotiable:**
- Red → Green → Refactor, always
- Never write code before its test
- Never advance to next task with failing tests

---

## Safeguards (never violate)
- No code before its test
- No scope creep beyond the Canvas
- No direct database access from domain layer
- Performance SLOs are non-negotiable — block deploy if violated
- Do not generate code while unmitigated critical risks exist

---

## When the user asks for a new feature or requirement

Run the full SDD → SPDD flow:

```
1. sdd-workflow       ← clarify → spec → design → task breakdown
2. spdd-analyze       ← scan codebase, identify risks
3. spdd-canvas        ← generate REASONS Canvas
4. spdd-risk-review   ← validate risks before any code
5. spdd-generate      ← TDD implementation per Canvas task
6. spdd-perftest      ← performance tests last
```

---

## When the user asks to implement a single task (already has spec)

```
1. spdd-analyze       ← scan relevant codebase only
2. spdd-canvas        ← generate REASONS Canvas
3. spdd-risk-review   ← validate risks
4. spdd-generate      ← TDD implementation
```

---

## When requirements change

```
Behavior change (business logic):
1. spdd-update        ← update Canvas FIRST (prompt-first rule)
2. spdd-generate      ← regenerate affected code

Refactoring only (no behavior change):
1. Change code
2. spdd-sync          ← sync Canvas back to code
```

---

## When user asks for status

```
sdd-workflow status   ← report feature/task status from sdd/specs/
```

---

## Artifact Structure

```
sdd/specs/<feature>/    ← spec.md, design.md, tasks.md  (SDD artifacts)
spdd/analysis/          ← strategic analysis, risk reviews
spdd/prompts/           ← REASONS Canvas files
spdd/tests/             ← functional tests + perf-* performance tests
```

---

## Available Skills

### SDD — Orchestration
- `sdd-workflow` — Full cycle: requirements → spec → design → task breakdown → delegate to SPDD

### SPDD — Execution
- `spdd-story`       — Break requirements into INVEST-compliant user stories
- `spdd-analyze`     — Analyze requirements, scan codebase, surface risks (reads nothing extra)
- `spdd-canvas`      — Generate REASONS Canvas → reads `spdd/canvas.md`
- `spdd-risk-review` — Validate all risks before code generation → reads `spdd/risks.md`
- `spdd-generate`    — TDD implementation (Red → Green → Refactor) → reads `spdd/tdd.md`
- `spdd-test`        — Derive functional test scenarios for TDD (reads nothing extra)
- `spdd-perftest`    — Generate performance tests → reads `spdd/perftest.md`
- `spdd-sync`        — Sync code changes back to Canvas (reads nothing extra)
- `spdd-update`      — Update Canvas when requirements change (prompt-first, reads nothing extra)
- `spdd-review`      — Review implementation against the Canvas (reads nothing extra)
