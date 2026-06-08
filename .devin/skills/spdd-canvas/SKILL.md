---
name: spdd-canvas
description: Generate a complete REASONS Canvas structured prompt from analysis
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

Generate a complete REASONS Canvas from the analysis context. Cover ALL 7 dimensions:

**R - Requirements**: Acceptance criteria (Given/When/Then with concrete examples), Definition of Done, Performance SLAs/ACs

**E - Entities**: Domain model, fields, relationships, lifecycle, business rules, invariants

**A - Approach**: Design strategy, patterns, trade-offs, extension points, risk mitigation for each identified risk (avoid/transfer/mitigate/accept), risk owner

**S - Structure**: Components, dependencies, API contracts (request/response shapes), language-specific package layout following DDD (Java/Kotlin/Rust) or Hexagonal (Go/Node.js) patterns

**O - Operations**: Concrete method-level implementation steps in execution order, each independently testable via TDD, performance test tasks at the end

**N - Norms**: Naming conventions, error handling strategy, observability (logging, metrics), testing standards

**S - Safeguards**: Non-negotiable constraints, invariants, security rules, performance SLOs with pass/fail thresholds

Save to `spdd/prompts/` with a descriptive name including the task ID.
