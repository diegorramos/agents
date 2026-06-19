# E — Entities

## What to capture

- Domain entities, their fields, relationships, and lifecycle
- New vs existing entities
- Key business rules and invariants
- **Aggregate design** (Java/Kotlin/Rust): identify Aggregate Root, internal entities,
  boundary, and invariants protected by the root
- **Value Objects** (Java/Kotlin/Rust): list VOs and their immutability contract
- **Domain Events**: list events emitted by this feature (past tense — `OrderPlaced`)
- **Domain Services** (Java/Kotlin/Rust): identify logic that belongs to no single entity

## Aggregate rules

- Only the Aggregate Root is accessible from outside — internal entities are never
  returned or modified directly
- Transactions do not cross aggregate boundaries — use Domain Events for
  cross-aggregate consistency
- No repository interface for entities internal to an aggregate — only Aggregate Roots
  have repositories

## Value Object rules

- Defined by attributes, not identity — two VOs with the same data are equal
- Always immutable — use `record` (Java 16+), `data class` (Kotlin), `struct` (Rust)
- Never use `null` inside a VO — validate in the constructor/factory

```java
public record Money(BigDecimal amount, Currency currency) {
    public Money {
        Objects.requireNonNull(amount, "amount required");
        Objects.requireNonNull(currency, "currency required");
        if (amount.compareTo(BigDecimal.ZERO) < 0)
            throw new IllegalArgumentException("amount must be non-negative");
    }
}
```

## Domain Event rules

- Named in past tense — `OrderPlaced`, `PaymentProcessed`
- Immutable — it is a fact, not a command
- Published as an explicit step in Operations, after persistence — never inside
  the aggregate method itself

## Domain Service rules

- Stateless — no fields, no state between calls
- Used only when logic belongs to no single entity or VO
- Example: `PricingService.calculateDiscount(Order, CustomerTier)`

## Ubiquitous Language (all languages)

- Use domain terms from stakeholders literally in code, tests, and documentation
- Forbidden in domain layer: `Manager`, `Helper`, `Util`, `Data`, `Info`, `Processor`
  (unless the business actually calls it that)
- If the business says "pedido", the code has `Order` — not `OrderDTO`, `OrderEntity`
