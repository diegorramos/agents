# S — Safeguards

Non-negotiable constraints to be applied in the S dimension of the Canvas.

---

## Security Checklist (OWASP Top 10)

**Authentication & Authorization**
- [ ] Every non-public route requires a valid token (JWT / OAuth2)
- [ ] Validate `audience`, `issuer`, and `expiration` of JWTs — never signature alone
- [ ] Resource-based authorization: verify the requester owns the resource, not just their role
- [ ] Tokens only in `Authorization: Bearer` header — never in query params

**Injection (SQL, NoSQL, Command)**
- [ ] No query built by string concatenation
- [ ] Prepared statements or ORM with bound parameters — mandatory
- [ ] User input never passed to `exec`, `eval`, or shell commands

**Sensitive Data Exposure**
- [ ] No sensitive data in logs (PII, tokens, passwords, payment data)
- [ ] Error responses do not expose stack traces in production
- [ ] Sensitive fields masked in responses (`"****1234"` for card numbers)
- [ ] TLS mandatory for all external communications

**Input Validation**
- [ ] All input validated at the entry boundary (schema validation mandatory)
- [ ] Reject payloads above the defined maximum size (default: 1 MB)
- [ ] Sanitize inputs that will be rendered in HTML

**Rate Limiting & DoS**
- [ ] Rate limiting by IP and by authenticated user on all public endpoints
- [ ] Timeout configured on all outbound calls (HTTP, DB, cache)
- [ ] Circuit breaker on critical dependencies

---

## Code Style Gate (Java only)

- [ ] Spotless (`spotless-maven-plugin`) removed from `pom.xml` if present — never coexist with Checkstyle
- [ ] `config/checkstyle/checkstyle.xml` present in the repository
- [ ] `mvn checkstyle:check` passes with zero violations — **blocks task completion if it fails**

---

## SOLID & DDD Invariants (Java / Kotlin / Rust only)

- [ ] LSP: no subclass throws `UnsupportedOperationException` on an inherited method
      or silently ignores a postcondition of the parent contract
- [ ] Aggregate boundary: transactions do not cross aggregate boundaries;
      internal entities are never exposed or modified directly from outside
- [ ] Repository rule: no repository interface for an entity that is internal
      to an aggregate — only Aggregate Roots have repositories
- [ ] ACL: domain layer never imports types from external Bounded Contexts directly;
      an Anti-Corruption Layer or shared event contract is mandatory
- [ ] Application Service: no business logic (`if/else` on domain rules) inside
      use case / application service classes
- [ ] Empty catch: no `catch` block that swallows exceptions silently (Effective Java Item 77)

---

## Performance SLOs by Endpoint Type

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
- Error rate > 1% under load test → **block deploy**
- Message loss rate > 0% → **block deploy**
- All SLOs must be validated at **1.5× expected production peak load**
