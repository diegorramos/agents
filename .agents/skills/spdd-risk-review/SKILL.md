---
name: spdd-risk-review
description: >
  Validate that all risks identified in analysis are mitigated in the Canvas before any code is written.
  Use after spdd-canvas, before spdd-generate.
---

1. Read `spdd/risks.md` for classification criteria and gate rules
2. Read the latest Canvas from `spdd/prompts/`
3. Read the latest analysis from `spdd/analysis/`
4. Validate the gate:
   - Every risk has a mitigation in Canvas Approach
   - Critical/high risks explicitly accepted
   - No risk blocks implementation
5. Save outcome to `spdd/analysis/risk-review-<timestamp>.md`
6. Block code generation if gate fails — return to spdd-analyze
