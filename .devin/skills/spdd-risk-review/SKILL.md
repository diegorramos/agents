---
name: spdd-risk-review
description: Validate implementation risks before code generation
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

Read the latest REASONS Canvas from `spdd/prompts/` and analysis from `spdd/analysis/`.

Validate:
1. Every identified risk has a documented mitigation in the Approach section
2. Critical/high risks are explicitly accepted by a decision-maker
3. No risk makes the implementation infeasible (if so, return to Analysis)

Document the outcome in `spdd/analysis/` with `risk-review-` prefix.
If the review fails, loop back to analysis.
