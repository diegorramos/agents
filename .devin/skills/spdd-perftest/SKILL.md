---
name: spdd-perftest
description: Generate performance tests from the REASONS Canvas (Vegeta, K6)
triggers:
  - user
  - model
subagent: true
allowed-tools:
  - read
  - grep
  - glob
  - write
  - exec
---

Read the latest REASONS Canvas from `spdd/prompts/`. Derive performance test scenarios from Requirements (performance ACs) and Safeguards (SLOs).

- **HTTP endpoints** → Use **Vegeta** (preferred) or **Apache Benchmark (ab)**
- **Brokers (RabbitMQ, Kafka)** → Use **K6** with extensions

Define pass/fail criteria from Canvas Safeguards.

Save to `spdd/tests/` with `perf-` prefix.

If any Safeguard is violated → **block deploy** and report which Safeguard was violated.
