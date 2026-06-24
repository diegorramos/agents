---
name: spdd-perftest
description: >
  Generate performance tests from the Canvas Safeguards and Requirements.
  Use as the final phase, after all functional tests are green.
---

1. Read `spdd/perftest.md` for tooling reference (Vegeta, K6, ab)
2. Read `spdd/s-safeguards.md` for SLO thresholds and deploy gate rules
3. Read the latest Canvas from `spdd/prompts/`
4. Derive performance test scenarios from:
   - Requirements (R): performance SLAs/ACs
   - Safeguards (S): SLOs with pass/fail thresholds
5. HTTP endpoints -> Vegeta (preferred) or Apache Benchmark
6. Broker endpoints -> K6 (k6/x/kafka or k6/x/amqp)
7. Save to `spdd/tests/perf-<feature>.md`
8. Block deploy if any Safeguard SLO is violated
