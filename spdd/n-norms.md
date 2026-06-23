# N — Norms

Detailed, language-specific rules to be applied in the N dimension of the Canvas.

---

## Naming & Style

**Java / Kotlin**
- Classes: `PascalCase` — `OrderService`, `PaymentRepository`
- Methods / variables: `camelCase` — `findByCustomerId`, `totalAmount`
- Constants: `UPPER_SNAKE_CASE` — `MAX_RETRY_ATTEMPTS`
- Packages: `lowercase.separated.by.dots`
- Kotlin: prefer `data class` for DTOs; `sealed class` for typed results with error branches

**Code Formatter — Java**
- Formatter: **Checkstyle** (`config/checkstyle/checkstyle.xml`) via `maven-checkstyle-plugin`
- If the project already uses **Spotless**: remove `spotless-maven-plugin` from `pom.xml`
  before any implementation task — never keep both simultaneously
- Line max: **120 characters**; indent: **4 spaces** — no tabs
- Imports: no wildcard; ordered `java → javax → org → com`; no unused imports
- Pipeline indentation: each operator (`.map`, `.flatMap`, `.filter`, `.orElse`,
  `.switchIfEmpty`, `.onErrorResume`, etc.) on its own line; `.` at the start of the next line
- Braces: K&R style — opening brace on the same line, closing brace alone on its own line
- `Optional.get()` is forbidden — use `.orElse()`, `.orElseGet()`, or `.orElseThrow()`
- `.block()` is forbidden in production code — return `Mono`/`Flux` or use `subscribe()`
- Logger: SLF4J only — `System.out`, `System.err`, and `e.printStackTrace()` are forbidden
- Run `mvn checkstyle:check` before marking any task done

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

## SOLID Principles (Java / Kotlin / Rust only)

> Go and Node.js: apply SRP and DIP only. The remaining principles do not map
> naturally to these languages and must not be forced.

**SRP — Single Responsibility**
- Each class has one reason to change — one actor that can demand a modification
- Strict role separation:
  - `Entity` / `Aggregate`: holds business rules and protects invariants
  - `Application Service` / `Use Case`: orchestrates flow — no business logic
  - `Domain Service`: stateless logic that belongs to no single entity
  - `Repository`: persistence abstraction — defined by domain, implemented by infra
  - `Controller` / `Handler`: translates external input — no business logic
- Symptom of violation: a class that changes for two unrelated reasons
  (e.g., `UserService` that validates, persists, sends email, and generates reports)

**OCP — Open/Closed**
- Open for extension, closed for modification
- Add new behaviour without changing existing code — via polymorphism and strategy pattern
- Symptom of violation: `if/else` or `switch` growing with every new business type
```java
// Violation
if (payment.type == CREDIT) { ... }
else if (payment.type == PIX)  { ... }

// OCP — new payment types without touching existing code
interface PaymentProcessor { void process(Payment p); }
class CreditProcessor implements PaymentProcessor { ... }
class PixProcessor    implements PaymentProcessor { ... }
```

**LSP — Liskov Substitution**
- Subtypes must be substitutable for their base type without breaking behaviour
- Preconditions cannot be more restrictive in the subclass
- Postconditions cannot be weaker in the subclass
- Symptom of violation: subclass throws `UnsupportedOperationException` on an
  inherited method — enforced as a hard block in Safeguards

**ISP — Interface Segregation**
- Clients must not depend on methods they do not use
- Break large interfaces into small, cohesive ones segregated by use case need
```java
// Violation — not every repository needs bulk import
interface Repository<T> {
    T findById(Long id);
    void save(T entity);
    void bulkImport(List<T> entities);
}

// ISP
interface Reader<T>     { T findById(Long id); }
interface Writer<T>     { void save(T entity); }
interface BulkWriter<T> { void bulkImport(List<T> entities); }
```

**DIP — Dependency Inversion**
- High-level modules must not depend on low-level modules — both depend on abstractions
- Domain defines the interface; infrastructure implements it
- Already enforced by the DDD/Hexagonal package structure — never import infra types
  into the domain layer

---

## DDD Tactical Patterns (Java / Kotlin / Rust only)

> Ubiquitous Language and Application Service rule apply to **all languages**.

**Factory**
- Use when construction is complex or must enforce creation invariants
- Prefer static factory methods (Effective Java Item 1) or a dedicated Factory class
  over telescoping constructors

---

## Effective Java Best Practices (Java / Kotlin only)

- **Item 1** — Prefer static factory methods over constructors when the name
  adds clarity (`Money.of(100, BRL)` over `new Money(100, BRL)`)
- **Item 2** — Use Builder when a constructor has 4+ parameters or optional fields
- **Item 17** — Minimise mutability; prefer immutable classes — immutable objects
  are thread-safe by nature
- **Item 18** — Favour composition over inheritance; use inheritance only when
  a true is-a relationship exists and the superclass is designed for it
- **Item 54** — Return empty collections (`List.of()`, `Collections.emptyList()`),
  never `null`
- **Item 55** — Return `Optional<T>` for absent values; never use `Optional` as a
  field, constructor parameter, or method parameter
- **Item 61** — Prefer primitives over boxed primitives; auto-unboxing `null`
  throws `NullPointerException`
- **Item 72** — Use standard exceptions: `IllegalArgumentException`,
  `IllegalStateException`, `UnsupportedOperationException`, `NullPointerException`
- **Item 73** — Exception translation: catch low-level exceptions at layer boundaries
  and rethrow as domain or application exceptions
- **Item 77** — Never ignore exceptions — empty `catch` blocks are forbidden
  (enforced also in Safeguards)

**Small Functions and Method References (Java 17+)**
- Each method does one thing — if a method needs a comment to explain what a block does,
  extract that block into a well-named private method; aim for ~20 lines max
- **Lambda with internal logic → extract to a private method**; if the method signature
  is compatible with the expected functional interface → use `this::method` (method reference)
- Use lambda only when it captures a variable from the outer scope that prevents extraction,
  or when the logic is trivial (single expression with no business meaning)

```java
// Prefer method references
orders.stream()
      .map(Order::getCustomer)
      .map(Customer::getName)
      .collect(toList());

// Avoid unnecessary lambdas
orders.stream()
      .map(order -> order.getCustomer())
      .map(customer -> customer.getName())
      .collect(toList());

// Lambda acceptable when logic is non-trivial
orders.stream()
      .filter(order -> order.total().compareTo(MINIMUM) > 0)
      .collect(toList());

// Lambda with internal logic → extract to private method + method reference
// Bad
flux.flatMap(order -> customerRepo.findById(order.getCustomerId())
        .map(customer -> new OrderSummary(order, customer)));

// Good
flux.flatMap(this::enrichWithCustomer);

private Mono<OrderSummary> enrichWithCustomer(Order order) {
    return customerRepo.findById(order.getCustomerId())
            .map(customer -> new OrderSummary(order, customer));
}
```

---

## Null-Safety — Java 17+

- **Never return `null` from public methods** — use `Optional<T>` for absent values in queries;
  use typed domain errors via a sealed interface for failure paths
- **`Optional` usage rules**
  - Use as return type only — never as a field, constructor parameter, or method parameter
  - Prefer `.map()`, `.flatMap()`, `.filter()`, `.orElseThrow()` over `.isPresent()` / `.get()`
  - Never call `.get()` without a prior `.isPresent()` guard
- **Annotate nullability explicitly** — use `@NonNull` / `@Nullable` (Jakarta or Lombok) on all
  public API boundaries
- **Records and sealed interfaces for domain results**
```java
sealed interface OrderResult permits OrderResult.Success, OrderResult.NotFound, OrderResult.Invalid {
    record Success(Order order)       implements OrderResult {}
    record NotFound(OrderId id)       implements OrderResult {}
    record Invalid(String reason)     implements OrderResult {}
}
```
- **Pattern matching instead of null checks**
```java
if (result instanceof OrderResult.Success success) {
    process(success.order());
}
```
- Use `Objects.requireNonNull(param, "param must not be null")` in constructors and factory methods
- Prefer `List.of()`, `Map.of()`, `Set.of()` (null-hostile by design) over mutable collections
- Use `String.isBlank()` / `Objects.toString(val, "")` instead of manual null + empty checks
- **Never swallow `NullPointerException`** — it signals a contract violation; fix the root cause

---

## Error Handling

**Java / Kotlin**
- Use `sealed interface` / `sealed class` for typed domain errors — not exceptions as flow control
- Checked exceptions only for unrecoverable I/O
- Never swallow exceptions with an empty `catch` block
- Domain errors must not extend `RuntimeException` — define dedicated types

**Go**
- Always handle `error` — never use `_` on calls that return an error
- Wrap with context: `fmt.Errorf("findOrder: %w", err)`
- Domain errors as types: `type NotFoundError struct { ID string }`
- Never return `nil, nil` — ambiguity is forbidden

**Node.js / TypeScript**
- Use `neverthrow` or `fp-ts` for domain errors instead of throw/catch
- Async: always `try/catch` on `await` — never leave a promise unhandled
- Never `catch(e) {}` — log or propagate
- HTTP handlers: always catch and convert to a structured error response

**Rust**
- Use `Result<T, E>` for all functions that can fail
- Prefer `?` operator over `.unwrap()` outside tests
- `.unwrap()` and `.expect()` are allowed only in tests and initialization code with an explanatory message
- Public errors derive `thiserror::Error`

---

## Observability

**Logging**
- Minimum level in production: `INFO`. `DEBUG` only in development — never in prod
- Structured logging mandatory (JSON): fields `timestamp`, `level`, `service`, `trace_id`,
  `span_id`, `message`
- **Never log**: PII (CPF, email, password), tokens, card data
- Log at every input/output boundary: HTTP request received, response sent,
  outbound call started/completed

**Metrics (RED Method)**
- **R**ate — requests per second
- **E**rrors — error rate (4xx separated from 5xx)
- **D**uration — latency (p50, p95, p99)
- All metrics must carry labels: `service`, `endpoint`, `method`, `status_code`

**Tracing**
- Propagate `trace_id` across all services (W3C TraceContext or B3)
- Create a span for each significant operation: handler, use case, repository, outbound call
- Include `trace_id` in all error responses to aid debugging

---

## Testing Conventions

**Framework — Java**
- Use **JUnit 5** (`org.junit.jupiter`) exclusively — no JUnit 4
- Annotate every test method with **`@DisplayName`** using a full sentence in English:
```java
@Test
@DisplayName("should return NOT_FOUND when order id does not exist")
void shouldReturnNotFoundWhenOrderIdDoesNotExist() { ... }
```
- Use `@Nested` classes to group tests by method or scenario, each with its own `@DisplayName`
- Prefer `assertThat` from AssertJ over JUnit's built-in `assertEquals`
- Use `@ExtendWith(MockitoExtension.class)` for unit tests with mocks
- Integration tests with real infrastructure: Testcontainers + `@SpringBootTest`

**Coverage minimums**
- Domain (entities, use cases): **90%**
- Adapters / Infrastructure: **70%**
- Handlers / Controllers: **80%**
- Branch coverage mandatory for critical business logic

**Structure — all languages**
- Mandatory AAA pattern: `// Arrange`, `// Act`, `// Assert`
- Test name pattern: `should_<result>_when_<condition>` or `given<Context>_when<Action>_then<Result>`
- One assertion per behaviour (multiple assertions only when testing the same concept)
- Unit tests: no real I/O — use mocks/stubs for external dependencies
- Integration tests: real database and messaging (Testcontainers)
- Contract tests (Pact) mandatory for APIs consumed by other services

**What never to test**
- Trivial getters/setters with no logic
- Framework code (Spring Boot autowiring, plain Express routing)
- Constants with no associated logic

---

## Documentation Standards

**General Rule**
- Document only what is necessary — avoid noise and redundant comments
- Code should be self-documenting: clear naming eliminates need for explanation
- Comments explain **why**, not **what** — the code shows what; comments explain intent

**When to write Javadoc / doc comments**
- Public API boundaries (interfaces, public methods, public classes)
- Complex algorithms or non-obvious logic
- Aggregate roots and Domain Services: document the business rule being protected
- Factory methods: document invariants enforced during creation
- Exceptions: document which conditions trigger each exception type

**When NOT to write**
- Trivial getters/setters — `getId()` does not need "returns the id"
- Simple one-liner methods — obvious from signature
- Constants with obvious names — `MAX_RETRIES` does not need explanation
- Test methods — use `@DisplayName` instead (mandatory for Java)

**Style rules**
- Write in present tense, active voice: "Returns the order" not "Will return"
- For methods: start with a verb — "Calculates", "Validates", "Publishes"
- For classes: start with a noun — "Aggregate root for managing orders"
- Keep first sentence under 80 characters

```java
/**
 * Calculates the discount for an order based on customer tier and total amount.
 *
 * @param order the order to evaluate (must not be null)
 * @param tier the customer tier (must not be null)
 * @return the discount percentage as a value between 0 and 1
 * @throws IllegalArgumentException if order or tier is null
 */
public BigDecimal calculateDiscount(Order order, CustomerTier tier) { ... }
```

**Inline comments**
- Use sparingly — only to explain **why**, not **what**
- Never comment out code — delete it or use version control

```java
// Bad
i++; // increment i

// Good — explains why, not what
// We cap retries at 3 because the upstream API has a 5-second timeout
// and each retry adds latency; 3 attempts ≈ 15s which is our SLA limit
if (retryCount >= MAX_RETRIES) { ... }
```
