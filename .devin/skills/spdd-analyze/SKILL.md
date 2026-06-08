---
name: spdd-analyze
description: Analyze requirements and produce strategic analysis with codebase context
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

Execute the SPDD Analysis phase on the current requirements:

1. Extract domain keywords from the requirements
2. Scan the relevant parts of the codebase (not all of it) — identify existing concepts vs new concepts
3. Surface key business rules, risks, edge cases, and design direction
4. **Identify implementation risks**: technical debt, third-party dependencies, performance bottlenecks, security vulnerabilities, unknowns in the domain
5. **Classify each risk**: severity (low/medium/high/critical), likelihood, impact area, and affected entities

Save the analysis to `spdd/analysis/` with a timestamp prefix.
