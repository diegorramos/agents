---
name: spdd-risk-review
description: >
  Validate that all risks are mitigated before any code is written.
  Use after spdd-canvas, before spdd-generate.
---

1. Read `spdd/risks.md` for classification criteria and gate rules
2. Read `spdd/a-approach.md` for risk mitigation strategies reference
3. Read the latest Canvas from `spdd/prompts/`
4. Read the latest analysis from `spdd/analysis/`
5. Validate the gate:
   - Every risk has a mitigation in Canvas Approach
   - Critical/high risks explicitly accepted
   - No risk blocks implementation
6. Save outcome to `spdd/analysis/risk-review-<timestamp>.md`
7. Block code generation if gate fails — return to spdd-analyze
