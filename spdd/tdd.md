# TDD Implementation Rules

For EACH task in Canvas Operations (in order):

---

## RED — Write the test first
- Write a failing test that covers the acceptance criterion
- Test must be meaningful: behavior, not implementation details
- Run the test → confirm it fails (red)

## GREEN — Write minimal code to pass
- Implement the simplest code that makes the test pass
- No premature optimization, no extra features, no scope creep
- Run the test → confirm it passes (green)

## REFACTOR — Clean up
- Improve code quality without changing behavior
- Apply Norms from AGENTS.md (naming, error handling, observability)
- Run ALL existing tests → confirm nothing broke

---

## Rules (non-negotiable)
- Never write code before its test
- Never advance to the next task while any test is failing
- Fix failures immediately — do not accumulate debt
- Unit tests cover domain and usecase layers
- Integration tests cover infrastructure adapters
- Only advance when ALL tests pass
