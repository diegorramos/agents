# S — Structure

## What to capture

- Where changes fit in the codebase (layers, modules)
- Component dependencies and interfaces
- API contracts (request/response shapes)
- **DIP enforced by structure** (Java/Kotlin/Rust): domain defines interfaces
  (Repository, EventPublisher); infrastructure implements — never the reverse
- **Bounded Context boundary**: list which external contexts this feature touches
  and how (API call, event, ACL)

## Package organization by language

### DDD (Eric Evans) — Java, Kotlin, Rust

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

### Hexagonal (Ports & Adapters) — Go, Node.js

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

## DIP rules (Java / Kotlin / Rust)

- Domain layer defines interfaces (`OrderRepository`, `EventPublisher`)
- Infrastructure layer implements them (`JpaOrderRepository`, `KafkaEventPublisher`)
- Domain layer **never** imports types from infrastructure layer
- Application service depends on the domain interface — not the implementation

## Application Service rule (all languages)

- Orchestrates: fetch aggregate → call domain method → persist → publish event
- Contains **zero** business logic — all decisions live in the domain
- Symptom of violation: `if/else` on domain rules inside the use case class
