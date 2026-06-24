# TDD Implementation Rules

For EACH task in Canvas Operations (in order):

---

## RED — Write the test first

- Write a failing test that defines the expected behavior
- Test must be meaningful: covers the acceptance criterion, not implementation details
- Run the test → confirm it fails (red)
- **RED gate** — the test must fail for the right reason:
  - Failure due to missing logic → correct, proceed to Green
  - Failure due to compilation error → fix the test structure first, re-run
  - Test passes immediately → the test is wrong; rewrite it before proceeding
- Never modify the test to make it pass — only production code changes in Green

## GREEN — Write minimal code to pass

- Implement the simplest code that makes the test pass
- No premature optimization, no extra features, no scope creep
- Run the test → confirm it passes (green)
- **GREEN gate** — only the minimum code to pass the current test:
  - If other existing tests break → fix them before advancing
  - Never change a test to make it pass — if the test is wrong, return to Red

## REFACTOR — Clean up

- Improve code quality without changing behavior
- Apply Norms from `spdd/n-norms.md` (naming, error handling, observability)
- **Java projects**: run `mvn checkstyle:check` — fix all violations before advancing
- **Java projects**: review every lambda in the changed code:
  - Lambda with internal logic → extract to a private method
  - Private method with compatible signature → convert to `this::method` reference
- Run ALL existing tests → confirm nothing broke
- **REFACTOR gate** — before marking the task done:
  - All tests pass (no regressions)
  - Norms applied: naming, error handling, observability
  - `mvn checkstyle:check` passes with zero violations (Java projects)
  - No new behaviour introduced — refactor only
  - If a test breaks during refactor → revert the change, investigate, retry

---

## Task done checklist

All boxes must be checked before advancing to the next task:

- [ ] Test failed in Red for the right reason (logic missing, not compilation)
- [ ] Minimal production code written in Green — no scope creep
- [ ] All tests pass after Refactor
- [ ] Norms applied (naming, error handling, observability)
- [ ] `mvn checkstyle:check` passes with zero violations (Java projects)
- [ ] Lambdas with internal logic extracted to private methods; method references used where signature is compatible (Java projects)
- [ ] Domain Event published if the task produces a side effect
- [ ] No `TODO`, commented-out code, or debug statements left behind

**Only advance to the next task when ALL boxes are checked.**
If any test fails → fix it immediately before moving on.
