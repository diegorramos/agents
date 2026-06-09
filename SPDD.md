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

> See **Norms Reference** section below for detailed, language-specific rules.

**S - Safeguards**

- Non-negotiable constraints (security, performance)
- Invariants that must never be broken
- Boundary checks and validation rules
- **Performance SLOs with pass/fail thresholds** (e.g., p99 < 500ms, 0% message loss)

> See **Safeguards Reference** section below for checklists and SLO tables.

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

**Only advance to the next task when ALL tests pass.** If any test fails → fix it immediately before moving on.

### 5. Performance Tests (mandatory final phase)

Only after ALL functional code and tests are green:

- Read Canvas Requirements (performance ACs) and Safeguards (SLOs/SLAs)
- Save specs to `spdd/tests/` with `perf-` prefix

**HTTP endpoints** → **Vegeta** (preferred) or **Apache Benchmark (ab)**

```bash
# Vegeta
echo "GET http://localhost:8080/api/orders" \
  | vegeta attack -rate=500 -duration=60s -workers=10 \
  | vegeta report

# Apache Benchmark (alternative)
ab -n 50000 -c 100 -k http://localhost:8080/api/orders
```

**Brokers (RabbitMQ, Kafka)** → **K6** with extensions

```javascript
// Kafka — K6 (k6/x/kafka)
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
    value: JSON.stringify({ id: __VU, amount: Math.random() * 5000, ts: Date.now() }),
  };
  const result = producer.produce([msg]);
  check(result, {
    'message produced': (r) => r.length === 1,
    'no errors':        (r) => r[0].error === '',
  });
  sleep(0.1);
}
```

```javascript
// RabbitMQ — K6 (k6/x/amqp)
import { check, sleep } from 'k6';
import amqp from 'k6/x/amqp';

export const options = { vus: 50, duration: '5m' };

export default function () {
  const body = JSON.stringify({ id: `order-${__VU}-${Date.now()}`, amount: Math.random() * 1000 });
  const result = amqp.publish({
    url:          'amqp://guest:guest@localhost:5672/',
    exchange:     'order.exchange',
    routing_key:  'order.created',
    body:         body,
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

## Norms Reference

Detailed, language-specific rules to be applied in the **N - Norms** Canvas dimension.

### Naming & Style

**Java / Kotlin**
- Classes: `PascalCase` — `OrderService`, `PaymentRepository`
- Methods / variables: `camelCase` — `findByCustomerId`, `totalAmount`
- Constants: `UPPER_SNAKE_CASE` — `MAX_RETRY_ATTEMPTS`
- Packages: `lowercase.separated.by.dots`
- Kotlin: prefer `data class` for DTOs; `sealed class` for typed results with error branches

**Go**
- Exported identifiers: `PascalCase` — `OrderHandler`, `CreateOrder`
- Unexported identifiers: `camelCase` — `parseRequest`, `validateInput`
- Interfaces: noun without prefix/suffix — `Repository`, not `IRepository`
- Sentinel errors: `var ErrNotFound = errors.New("not found")`; typed errors: `type ValidationError struct`

**Node.js / TypeScript**
- Classes / Types / Interfaces: `PascalCase`
- Functions / variables: `camelCase`
- Module-level constants: `UPPER_SNAKE_CASE`
- File names: `kebab-case.ts` — `order-service.ts`
- Prefer `type` for plain shapes; `interface` for extensible contracts

**Rust**
- Structs / Enums / Traits: `PascalCase`
- Functions / variables / modules: `snake_case`
- Constants: `UPPER_SNAKE_CASE`
- Error enums: descriptive variants — `AppError::NotFound`, `AppError::Validation`

---

### Null-Safety — Java 17+

- **Never return `null` from public methods** — use `Optional<T>` for absent values in queries;
  use typed domain errors (e.g., `Result<T, DomainError>` via a sealed interface) for failure paths.
- **`Optional` usage rules**
  - Use as return type only — never as a field, constructor parameter, or method parameter.
  - Prefer `.map()`, `.flatMap()`, `.filter()`, `.orElseThrow()` over `.isPresent()` / `.get()`.
  - Never call `.get()` without a prior `.isPresent()` guard — use `.orElse()`, `.orElseGet()`,
    or `.orElseThrow()` instead.
- **Annotate nullability explicitly** — use `@NonNull` / `@Nullable` (Jakarta or Lombok) on all
  public API boundaries (method parameters, return types, fields). Enable null-check warnings in
  the build tool.
- **Records and sealed interfaces for domain results**
  ```java
  // Prefer sealed interfaces over null/Optional for multi-branch outcomes
  sealed interface OrderResult permits OrderResult.Success, OrderResult.NotFound, OrderResult.Invalid {
      record Success(Order order)       implements OrderResult {}
      record NotFound(OrderId id)       implements OrderResult {}
      record Invalid(String reason)     implements OrderResult {}
  }
  ```
- **Pattern matching instead of null checks**
  ```java
  // Java 17+ — use pattern matching (switch expressions available from Java 21)
  if (result instanceof OrderResult.Success success) {
      process(success.order());
  }
  ```
- **String and collection handling**
  - Use `Objects.requireNonNull(param, "param must not be null")` in constructors and factory methods.
  - Prefer `List.of()`, `Map.of()`, `Set.of()` (null-hostile by design) over mutable collections
    when immutability is acceptable.
  - Use `String.isBlank()` / `Objects.toString(val, "")` instead of manual null + empty checks.
- **Never swallow `NullPointerException`** — it signals a contract violation; fix the root cause.

---

### Error Handling

**Java / Kotlin**
- Use `sealed interface` / `sealed class` for typed domain errors — not exceptions as flow control.
- Checked exceptions only for unrecoverable I/O.
- Never swallow exceptions with an empty `catch` block.
- Domain errors must not extend `RuntimeException` — define dedicated types.

**Go**
- Always handle `error` — never use `_` on calls that return an error.
- Wrap with context: `fmt.Errorf("findOrder: %w", err)`.
- Domain errors as types: `type NotFoundError struct { ID string }`.
- Never return `nil, nil` — ambiguity is forbidden.

**Node.js / TypeScript**
- Use `neverthrow` or `fp-ts` for domain errors instead of throw/catch.
- Async: always `try/catch` on `await` — never leave a promise unhandled.
- Never `catch(e) {}` — log or propagate.
- HTTP handlers: always catch and convert to a structured error response.

**Rust**
- Use `Result<T, E>` for all functions that can fail.
- Prefer `?` operator over `.unwrap()` outside tests.
- `.unwrap()` and `.expect()` are allowed only in tests and in initialization code with an
  explanatory message.
- Public errors derive `thiserror::Error`.

---

### Observability

**Logging**
- Minimum level in production: `INFO`. `DEBUG` only in development — never in prod.
- Structured logging mandatory (JSON): fields `timestamp`, `level`, `service`, `trace_id`,
  `span_id`, `message`.
- **Never log**: PII (CPF, email, password), tokens, card data.
- Log at every input/output boundary: HTTP request received, response sent,
  outbound call started/completed.

**Metrics (RED Method)**
- **R**ate — requests per second
- **E**rrors — error rate (4xx separated from 5xx)
- **D**uration — latency (p50, p95, p99)
- All metrics must carry labels: `service`, `endpoint`, `method`, `status_code`.

**Tracing**
- Propagate `trace_id` across all services (W3C TraceContext or B3).
- Create a span for each significant operation: handler, use case, repository, outbound call.
- Include `trace_id` in all error responses to aid debugging.

---

### Testing Conventions

**Framework — Java**
- Use **JUnit 5** (`org.junit.jupiter`) exclusively — no JUnit 4.
- Annotate every test method with **`@DisplayName`** using a full sentence in English that
  describes the expected behaviour:
  ```java
  @Test
  @DisplayName("should return NOT_FOUND when order id does not exist")
  void shouldReturnNotFoundWhenOrderIdDoesNotExist() { ... }
  ```
- Use `@Nested` classes to group tests by method or scenario, each with its own `@DisplayName`.
- Prefer `assertThat` from AssertJ over JUnit's built-in `assertEquals` for richer failure messages.
- Use `@ExtendWith(MockitoExtension.class)` for unit tests with mocks.
- Integration tests with real infrastructure: Testcontainers + `@SpringBootTest`.

**Coverage minimums**
- Domain (entities, use cases): **90 %**
- Adapters / Infrastructure: **70 %**
- Handlers / Controllers: **80 %**
- Branch coverage mandatory for critical business logic.

**Structure — all languages**
- Mandatory AAA pattern: `// Arrange`, `// Act`, `// Assert`.
- Test name pattern: `should_<result>_when_<condition>` or
  `given<Context>_when<Action>_then<Result>`.
- One assertion per behaviour (multiple assertions only when testing the same concept).
- Unit tests: no real I/O — use mocks/stubs for external dependencies.
- Integration tests: real database and messaging (Testcontainers).
- Contract tests (Pact) mandatory for APIs consumed by other services.

**What never to test**
- Trivial getters/setters with no logic.
- Framework code (Spring Boot autowiring, plain Express routing).
- Constants with no associated logic.

---

## Safeguards Reference

Detailed rules to be applied in the **S - Safeguards** Canvas dimension.

### Security Checklist (OWASP Top 10)

**Authentication & Authorization**
- [ ] Every non-public route requires a valid token (JWT / OAuth2).
- [ ] Validate `audience`, `issuer`, and `expiration` of JWTs — never signature alone.
- [ ] Resource-based authorization: verify the requester owns the resource, not just their role.
- [ ] Tokens only in `Authorization: Bearer` header — never in query params.

**Injection (SQL, NoSQL, Command)**
- [ ] No query built by string concatenation.
- [ ] Prepared statements or ORM with bound parameters — mandatory.
- [ ] User input never passed to `exec`, `eval`, or shell commands.

**Sensitive Data Exposure**
- [ ] No sensitive data in logs (PII, tokens, passwords, payment data).
- [ ] Error responses do not expose stack traces in production.
- [ ] Sensitive fields masked in responses (`"****1234"` for card numbers).
- [ ] TLS mandatory for all external communications.

**Input Validation**
- [ ] All input validated at the entry boundary (schema validation mandatory).
- [ ] Reject payloads above the defined maximum size (default: 1 MB).
- [ ] Sanitize inputs that will be rendered in HTML.

**Rate Limiting & DoS**
- [ ] Rate limiting by IP and by authenticated user on all public endpoints.
- [ ] Timeout configured on all outbound calls (HTTP, DB, cache).
- [ ] Circuit breaker on critical dependencies.

---

### Performance SLOs by Endpoint Type

| Endpoint type               | p99 target | p99 max (deploy gate) | Min throughput |
|-----------------------------|------------|----------------------|----------------|
| Simple read (GET by ID)     | < 50 ms    | 100 ms               | 1 000 rps      |
| Read with query / filter    | < 150 ms   | 300 ms               | 500 rps        |
| Write (POST / PUT)          | < 200 ms   | 500 ms               | 300 rps        |
| Async processing (event)    | < 500 ms   | 1 s                  | 1 000 msg/s    |
| Report / batch              | < 5 s      | 10 s                 | 10 rps         |
| Authentication (login)      | < 300 ms   | 600 ms               | 100 rps        |

**Deploy gate rules**
- p99 > column maximum → **block deploy**
- Error rate > 1 % under load test → **block deploy**
- Message loss rate > 0 % → **block deploy**
- All SLOs must be validated at **1.5× expected production peak load**.

---

## Output Structure

For each task, create these artifacts under the project root:

- `spdd/analysis/` — Strategic analysis documents
- `spdd/prompts/` — REASONS Canvas structured prompts
- `spdd/tests/` — Functional test specs and `perf-*` performance tests

---

## Language

Output must be in Brazilian Portuguese (pt-BR). All reasoning, methodology, code, and tooling
remain in English — only final responses to the user should be in Portuguese.
