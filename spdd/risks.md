# Risk Classification and Review Gate

---

## Classify each identified risk

- Severity: low / medium / high / critical
- Likelihood: low / medium / high
- Impact area: domain / performance / security / integration
- Affected entities

## Mitigation strategies

- **avoid** — change design to eliminate the risk entirely
- **transfer** — delegate to external system or library
- **mitigate** — reduce likelihood or impact with a specific action
- **accept** — document and monitor; no action taken (requires decision-maker sign-off for high/critical)

---

## Gate — must pass before any code is written

1. Every identified risk has a documented mitigation in Canvas Approach
2. Critical/high risks explicitly accepted by a decision-maker
3. No risk makes the implementation infeasible
   → if infeasible: return to analysis phase, do not proceed

Save outcome to: `spdd/analysis/risk-review-<timestamp>.md`

**Block code generation if gate fails.**
