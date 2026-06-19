---
name: spdd-analyze
description: >
  Analyze requirements and scan the relevant codebase to surface domain concepts,
  risks, edge cases, and design direction.
  Use before generating a REASONS Canvas.
---

1. Extract domain keywords from the requirements
2. Scan only relevant parts of the codebase (not all of it)
3. Identify existing concepts vs new concepts
4. Surface key business rules, risks, edge cases, and design direction
5. Classify each risk: severity (low/medium/high/critical), likelihood, impact area
6. Save analysis to `spdd/analysis/<timestamp>-<feature>-analysis.md`
