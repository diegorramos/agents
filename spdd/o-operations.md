# O — Operations

## What to capture

- Concrete implementation steps (method-level)
- Task breakdown in execution order
- Each task is independently testable — **write the test first (TDD)**
- **Domain Events**: publishing the event is an explicit task after persistence —
  never implicit or inside the aggregate
- **Performance test tasks go at the end** (after all functional code)

## Task format

Each operation must specify:
- What method/function is being implemented
- Which layer it belongs to (domain / application / infrastructure)
- The acceptance criterion it satisfies
- Whether it emits a Domain Event (explicit publish step required)

## Task ordering rules

1. Domain model changes first (entities, VOs, aggregates)
2. Domain service if needed
3. Repository interface (domain layer)
4. Application service / use case
5. Infrastructure adapter (repository impl, event publisher)
6. HTTP handler / controller
7. Domain Event publish step (explicit, after persistence)
8. Performance tests (always last)

## TDD per task

For each task: RED → GREEN → REFACTOR
See `spdd/tdd.md` for the full TDD rules.

## Domain Event publish rule

Publishing a Domain Event is **always** an explicit, separate task — never implicit:

```
Task O-04: Persist order aggregate        ← persistence
Task O-05: Publish OrderPlaced event      ← explicit publish step
```

Never embed the publish inside the aggregate method or the persistence step.
