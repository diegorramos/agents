# SDD + SPDD — Agent Orchestration Guide

This project follows **SDD** (Spec-Driven Development) for orchestration and **SPDD** (Structured Prompt-Driven Development) for execution.

Full methodology reference:  (human reference — do not load unless explicitly needed).

---

## Language

- Responses to user: **Brazilian Portuguese (pt-BR)**
- All artifacts (specs, canvas, tests, code): **English**

---

## Artifact Structure

-  — spec.md, design.md, tasks.md (SDD artifacts)
-  — strategic analysis, risk reviews
-  — REASONS Canvas files
-  — functional tests + perf-* performance tests

---

## When the user asks for a new feature or requirement



## When the user asks to implement a single task (already has spec)



## When requirements change



## When user asks for status



---

## Available Skills

### SDD — Orchestration
-  — Full cycle: requirements → spec → design → task breakdown → delegate to SPDD

### SPDD — Execution
-        — Break requirements into INVEST-compliant user stories
-      — Analyze requirements, scan codebase, surface risks
-       — Generate REASONS Canvas → reads all 7  files
-  — Validate all risks before code generation → reads  + 
-     — TDD implementation (Red → Green → Refactor) → reads  + 
-         — Derive functional test scenarios for TDD
-     — Generate performance tests → reads  + 
-         — Sync code changes back to Canvas
-       — Update Canvas when requirements change (prompt-first)
-       — Review implementation against Canvas → reads  + 
