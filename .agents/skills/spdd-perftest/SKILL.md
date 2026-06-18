---
name: spdd-perftest
description: >
  Generate performance tests from the Canvas Safeguards and Requirements.
  Use as the final phase, after all functional tests are green.
---

1. Read `spdd/perftest.md` for tooling reference (Vegeta, K6, ab)
2. Read the latest Canvas from `spdd/prompts/`
3. Derive performance test scenarios from:
   - Requirements: performance SLAs/ACs
   - Safeguards: SLOs with pass/fail thresholds
4. HTTP endpoints → Vegeta (preferred) or Apache Benchmark
5. Broker endpoints → K6 (k6/x/kafka or k6/x/amqp)
6. Save to `spdd/tests/perf-<feature>.md`
7. Block deploy if any Safeguard SLO is violated
