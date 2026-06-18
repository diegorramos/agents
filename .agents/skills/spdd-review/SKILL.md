---
name: spdd-review
description: >
  Review the current implementation against the REASONS Canvas.
  Use to validate alignment between code and Canvas intent.
---

1. Read the latest Canvas from `spdd/prompts/`
2. Review the implementation against:
   - Architecture: does code follow the layer structure defined in S?
   - Business logic: does the usecase/service match Canvas intent in O?
   - Scope: are changes confined to Canvas boundaries?
   - Norms: are all Norms from AGENTS.md applied?
   - Safeguards: are all invariants respected?
3. Report any gaps found with specific file and line references
