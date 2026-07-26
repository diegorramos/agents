---
name: spdd-story
description: >
  Break requirements or tasks into INVEST-compliant user stories.
  Use after sdd-workflow, before spdd-analyze.
  Each story must be independently implementable in 1-5 days.
---

1. Read the latest spec from `sdd/specs/<feature>/spec.md`
2. Break it into user stories following the INVEST principle:
   - **I**ndependent — no hard dependency between stories
   - **N**egotiable — scope can be discussed with stakeholders
   - **V**aluable — delivers business value on its own
   - **E**stimable — small enough to estimate (1-5 days)
   - **S**mall — one story per spdd-analyze -> spdd-generate cycle
   - **T**estable — has concrete acceptance criteria in business language
3. Format each story as:
   ```
   Story: <title>
   As a <role>, I want <goal> so that <business value>
   AC1: GIVEN ... WHEN ... THEN ...
   AC2: GIVEN ... WHEN ... THEN ...
   Size: <1-5 days>
   ```
4. Save to `sdd/specs/<feature>/stories.md`
5. Present stories to user and await execution order
