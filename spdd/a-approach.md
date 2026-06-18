# A — Approach

## What to capture

- Design strategy (patterns, algorithms)
- Architectural decisions and trade-offs
- Extension points for future changes
- **OCP decision** (Java/Kotlin/Rust): document whether new behaviour is added via
  polymorphism/strategy or if/else — justify the choice
- **Context Map**: document how this Bounded Context relates to neighbours
  (ACL, events, shared kernel, customer/supplier)
- **Risk mitigation**: for each risk identified in Analysis, document strategy
  (avoid, transfer, mitigate, accept) and contingency plan
- **Risk owner**: who is responsible for monitoring and responding to each risk

## Risk mitigation strategies

- **avoid** — change design to eliminate the risk entirely
- **transfer** — delegate to external system or library
- **mitigate** — reduce likelihood or impact with a specific action
- **accept** — document and monitor; no action taken (requires decision-maker sign-off
  for high/critical severity)

## OCP guidance (Java / Kotlin / Rust)

Add new behaviour without changing existing code — via polymorphism and strategy pattern.

```java
// Violation — grows with every new business type
if (payment.type == CREDIT) { ... }
else if (payment.type == PIX)  { ... }

// OCP — new payment types without touching existing code
interface PaymentProcessor { void process(Payment p); }
class CreditProcessor implements PaymentProcessor { ... }
class PixProcessor    implements PaymentProcessor { ... }
```

## Context Map patterns

- **ACL (Anti-Corruption Layer)** — translate external model to internal domain model
- **Events** — communicate between contexts via domain events (no direct coupling)
- **Shared Kernel** — small shared model agreed by both contexts (use sparingly)
- **Customer/Supplier** — upstream context defines the contract; downstream adapts
