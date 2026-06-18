# R — Requirements

## What to capture

- Problem statement and business value
- Acceptance criteria (Given/When/Then with concrete examples)
- Definition of Done
- **Performance SLAs/ACs** (e.g., p99 < 200ms with 1000 concurrent users)
- **Ubiquitous Language**: use domain terms from stakeholders literally in acceptance
  criteria — the same words must appear in code, tests, and documentation

## Acceptance Criteria format

```
GIVEN <initial context>
WHEN  <action or event>
THEN  <expected outcome>
```

Every functional requirement must have at least one AC.
Performance ACs are mandatory when the feature has latency or throughput constraints.

## Definition of Done checklist

- [ ] All ACs pass as automated tests
- [ ] Code follows project Norms
- [ ] No new lint/type errors
- [ ] Error paths are logged with correlation ID
- [ ] Performance SLAs validated (if applicable)
