---
name: spdd-story
description: Break requirements into INVEST-compliant user stories
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

Execute the SPDD Story phase: break the current requirements into independent, deliverable user stories following INVEST principle (1-5 days each). Include acceptance criteria in business language for each story.

Save the output to `spdd/analysis/` with a descriptive filename including a timestamp prefix.
