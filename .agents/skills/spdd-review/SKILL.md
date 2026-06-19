---
name: spdd-review
description: >
  Review the current implementation against the REASONS Canvas.
  Use to validate alignment between code and Canvas intent.
---

1. Read `spdd/n-norms.md` for naming, SOLID, DDD, error handling, observability, testing standards
2. Read `spdd/s-safeguards.md` for security checklist, SOLID/DDD invariants, and SLOs
3. Read the latest Canvas from `spdd/prompts/`
4. Review implementation against:
   - Architecture: does code follow the layer structure defined in S?
   - Business logic: does the usecase/service match Canvas intent in O?
   - Scope: are changes confined to Canvas boundaries?
   - Norms: naming, SOLID, DDD patterns, error handling, observability applied?
   - Safeguards: security checklist passed? SLO thresholds respected?
5. Report any gaps with specific file and line references
