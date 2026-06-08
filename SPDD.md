# SPDD — Structured Prompt-Driven Development

REASONS Canvas methodology for prompt-driven development.
Tool-agnostic — works with opencode, Claude Code, Devin CLI, Cursor, etc.

---

## Core Workflow

### 1. Analysis Phase
Before writing any code:
- Understand requirements deeply; ask clarifying questions when ambiguous
- Identify domain entities, relationships, and business rules
- Analyze existing codebase structure (relevant files, patterns, conventions)
- Map scope boundaries (what's IN and what's OUT)
- Document risks, edge cases, and definition of done
- **Identify implementation risks**: technical debt, third-party dependencies,
  performance bottlenecks, security vulnerabilities, unknowns in the domain
- **Classify each risk**: severity (low/medium/high/critical), likelihood,
  impact area, and affected entities
- Save analysis to `spdd/analysis/` with timestamp prefix

### 2. REASONS Canvas Generation
Generate a structured prompt covering ALL 7 dimensions. Save to `spdd/prompts/`:

**R - Requirements**
- Problem statement and business value
- Acceptance criteria (Given/When/Then with concrete examples)
- Definition of Done
- **Performance SLAs/ACs** (e.g., p99 < 200ms with 1000 concurrent users)

**E - Entities**
- Domain entities, their fields, relationships, and lifecycle
- New vs existing entities
- Key business rules and invariants

**A - Approach**
- Design strategy (patterns, algorithms)
- Architectural decisions and trade-offs
- Extension points for future changes
- **Risk mitigation**: for each risk identified in Analysis, document strategy
  (avoid, transfer, mitigate, accept) and contingency plan
- **Risk owner**: who is responsible for monitoring and responding to each risk

**S - Structure**
- Where changes fit in the codebase (layers, modules)
- Component dependencies and interfaces
- API contracts (request/response shapes)
- **Package organization follows language-specific architecture pattern:**

  **DDD (Eric Evans)** — Java, Kotlin, Rust:
  ```
  Java/Kotlin (com/example/)          Rust (src/)
  ──────────────────────              ──────────────
  domain/                             domain/
    model/                              model/
    repository/                         repository/
    service/                            service/
    event/                              event/
  application/                        application/
    usecase/                            usecase/
    dto/                                dto/
  infrastructure/                     infrastructure/
    persistence/                        persistence/
    messaging/                          messaging/
    web/                                web/
  shared/                             shared/
  ```

  **Hexagonal (Ports & Adapters)** — Go, Node.js and similar:
  ```
  Go (internal/)                      Node.js (src/)
  ──────────────                      ──────────────
  core/                               core/
    domain/                             domain/
    port/                               port/
      inbound/                            inbound/
      outbound/                           outbound/
    service/                            service/
  adapter/                            adapter/
    inbound/                            inbound/
      rest/                               rest/
      cli/                                cli/
    outbound/                           outbound/
      postgres/                           postgres/
      eventbus/                           eventbus/
  config/                             config/
  cmd/main.go                         main.ts
  ```

**O - Operations**
- Concrete implementation steps (method-level)
- Task breakdown in execution order
- Each task is independently testable — **write the test first (TDD)**
- **Performance test tasks go at the end** (after all functional code)

**N - Norms**
- Naming conventions, code style
- Error handling strategy
- Observability (logging, metrics)
- Testing standards

**S - Safeguards**
- Non-negotiable constraints (security, performance)
- Invariants that must never be broken
- Boundary checks and validation rules
- **Performance SLOs with pass/fail thresholds**
  (e.g., p99 < 500ms, 0% message loss)

### 3. Risk Review Gate
Before any code is written, validate the Canvas:
- Every identified risk has a documented mitigation in Approach
- Critical/high risks are explicitly accepted by a decision-maker
- No risk makes the implementation infeasible (if so, return to Analysis)
- Save review outcome to `spdd/analysis/` with `risk-review-` prefix

### 4. TDD Implementation
For EACH task in the Canvas Operations section (in order), follow strict TDD:

**RED — Write the test first**
- Write a failing test that defines the expected behavior
- Test must be meaningful: covers the acceptance criterion, not implementation details
- Run the test → confirm it fails (red)

**GREEN — Write minimal code to pass**
- Implement the simplest code that makes the test pass
- No premature optimization, no extra features, no scope creep
- Run the test → confirm it passes (green)

**REFACTOR — Clean up**
- Improve code quality without changing behavior
- Apply Norms (naming, error handling, observability)
- Run ALL existing tests → confirm nothing broke

**Only advance to the next task when ALL tests pass.**
If any test fails → fix it immediately before moving on.

### 5. Performance Tests (mandatory final phase)
Only after ALL functional code and tests are green:

- Read Canvas Requirements (performance ACs) and Safeguards (SLOs/SLAs)
- Save specs to `spdd/tests/` with `perf-` prefix
- **HTTP endpoints** → **Vegeta** (preferred) or **Apache Benchmark (ab)**

  **Vegeta:**
  ```bash
  echo "GET http://localhost:8080/api/orders" \
    | vegeta attack -rate=500 -duration=60s -workers=10 \
    | vegeta report
  ```

  **Apache Benchmark (alternative):**
  ```bash
  ab -n 50000 -c 100 -k http://localhost:8080/api/orders
  ```

- **Brokers (RabbitMQ, Kafka)** → **K6** with extensions

  **Kafka — K6 (k6/x/kafka):**
  ```javascript
  import { check, sleep } from 'k6';
  import kafka from 'k6/x/kafka';

  const producer = kafka.newProducer({
    brokers: ['localhost:9092'],
    topic: 'order-events',
  });

  export const options = {
    scenarios: {
      load: {
        executor: 'ramping-vus',
        startVUs: 0,
        stages: [
          { duration: '2m', target: 100 },
          { duration: '5m', target: 100 },
          { duration: '2m', target: 0 },
        ],
      },
    },
  };

  export default function () {
    const msg = {
      key: `order-${__VU}-${Date.now()}`,
      value: JSON.stringify({
        id: __VU, amount: Math.random() * 5000, ts: Date.now(),
      }),
    };
    const result = producer.produce([msg]);
    check(result, {
      'message produced': (r) => r.length === 1,
      'no errors': (r) => r[0].error === '',
    });
    sleep(0.1);
  }
  ```

  **RabbitMQ — K6 (k6/x/amqp):**
  ```javascript
  import { check, sleep } from 'k6';
  import amqp from 'k6/x/amqp';

  export const options = { vus: 50, duration: '5m' };

  export default function () {
    const body = JSON.stringify({
      id: `order-${__VU}-${Date.now()}`,
      amount: Math.random() * 1000,
    });
    const result = amqp.publish({
      url: 'amqp://guest:guest@localhost:5672/',
      exchange: 'order.exchange',
      routing_key: 'order.created',
      body: body,
      content_type: 'application/json',
    });
    check(result, { 'message published': (r) => r === true });
    sleep(0.2);
  }
  ```

- Define pass/fail criteria from Canvas Safeguards
- If it fails → **block deploy** and report which Safeguard was violated

### 6. Sync & Iterate
When requirements change:
1. Update the Canvas FIRST (prompt-first)
2. Then regenerate/update code

When refactoring (no behavior change):
1. Change code FIRST
2. Then sync back to Canvas

---

## Golden Rules

1. **Prompt-first**: When reality diverges from intent, fix the prompt first, then update code
2. **No scope creep**: Generate strictly what the Canvas specifies
3. **Prompts are artifacts**: Save every Canvas to `spdd/prompts/` with descriptive names
4. **One-to-one mapping**: Code must correspond directly to Canvas Operations
5. **Review intent first**: Before reviewing implementation, verify the Canvas captures correct intent
6. **Iterate tightly**: Successive iterations compound domain knowledge in the prompts
7. **Risk-first**: Do not generate code while unmitigated critical risks exist
8. **TDD is mandatory**: No code is written before its test. Every task follows
   Red → Green → Refactor. Never skip to the next task with failing tests.

---

## Output Structure

For each task, create these artifacts under the project root:
- `spdd/analysis/` — Strategic analysis documents
- `spdd/prompts/` — REASONS Canvas structured prompts
- `spdd/tests/` — Functional test specs and `perf-*` performance tests

---

## Language

Output must be in Brazilian Portuguese (pt-BR). All reasoning, methodology, code, and tooling remain in English — only final responses to the user should be in Portuguese.
