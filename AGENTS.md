# SDD + SPDD — Structured Prompt-Driven Development

This project follows the **SDD (Spec-Driven Development)** and **SPDD (Structured Prompt-Driven Development)** methodology defined in `SPDD.md`.

## Methodology Reference

`SPDD.md` at project root defines the complete REASONS Canvas + TDD workflow.

## Artifact Structure

- `sdd/specs/<feature>/` — Spec, design, task breakdown (SDD artifacts)
- `spdd/analysis/` — Strategic analysis documents
- `spdd/prompts/` — REASONS Canvas structured prompts
- `spdd/tests/` — Functional and performance test specs (`perf-*` prefix)

## Available Skills

### SDD — Orchestration

- **`/sdd-workflow`** — Full SDD cycle: clarify requirements → structured spec → technical design → task breakdown → delegate each task to SPDD for TDD implementation

### SPDD — Execution (can be invoked directly or auto-invoked by SDD)

- **`/spdd-story`** — Break requirements into INVEST-compliant user stories
- **`/spdd-analyze`** — Analyze requirements, scan codebase, produce strategic analysis
- **/spdd-canvas** — Generate a complete REASONS Canvas from analysis
- **`/spdd-risk-review`** — Validate that all risks are mitigated before code generation
- **`/spdd-generate`** — Implement code using strict TDD (Red → Green → Refactor)
- **`/spdd-test`** — Derive functional test scenarios for TDD
- **`/spdd-perftest`** — Generate performance tests (Vegeta, K6)
- **`/spdd-sync`** — Sync code changes back to the REASONS Canvas
- **`/spdd-update`** — Update Canvas when requirements change (prompt-first)
- **`/spdd-review`** — Review implementation against the Canvas

## Language

- User-facing responses in **Brazilian Portuguese (pt-BR)**
- All artifacts (spec, design, analysis, canvas, tests) in **English**
