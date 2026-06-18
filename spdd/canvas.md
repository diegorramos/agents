# REASONS Canvas Structure

Generate a structured prompt covering all 7 dimensions below.
Save to: `spdd/prompts/<feature>-canvas.md`

---

## R — Requirements
- Problem statement and business value
- Acceptance criteria (Given/When/Then with concrete examples)
- Definition of Done
- Performance SLAs (e.g. p99 < 200ms at 1000 concurrent users)

## E — Entities
- Domain entities, fields, relationships, and lifecycle
- New vs existing entities
- Key business rules and invariants

## A — Approach
- Design strategy (patterns, algorithms)
- Architectural decisions and trade-offs
- Extension points for future changes
- Risk mitigation per risk identified in analysis:
  - Strategy: avoid / transfer / mitigate / accept
  - Contingency plan
  - Risk owner

## S — Structure
- Where changes fit in the codebase (layers, modules)
- Component dependencies and interfaces
- API contracts (request/response shapes)
- Package layout by language:

  **Java / Kotlin / Rust → DDD:**
  ```
  domain/
    model/ repository/ service/ event/
  application/
    usecase/ dto/
  infrastructure/
    persistence/ messaging/ web/
  shared/
  ```

  **Go / Node.js → Hexagonal:**
  ```
  core/
    domain/ port/inbound/ port/outbound/ service/
  adapter/
    inbound/rest/ inbound/cli/
    outbound/postgres/ outbound/eventbus/
  config/
  ```

## O — Operations
- Concrete method-level implementation steps in execution order
- Each step must be independently testable via TDD
- Performance test tasks go at the end (after all functional steps)

## N — Norms
- Inherited from AGENTS.md — do not duplicate here
- Add only feature-specific norms if needed

## S — Safeguards
- Non-negotiable constraints (security, invariants)
- Performance SLOs with explicit pass/fail thresholds
- Boundary checks and validation rules
- No nullable domain identifiers without explicit backward-compatibility justification
