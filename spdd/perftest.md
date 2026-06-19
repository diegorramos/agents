# Performance Tests

Run ONLY after ALL functional tests are green.
Read SLOs from `spdd/s-safeguards.md` — block deploy if any is violated.
Save to: `spdd/tests/perf-<feature>.md`

---

## HTTP endpoints → Vegeta (preferred)

```bash
echo "GET http://localhost:8080/api/orders" \
  | vegeta attack -rate=500 -duration=60s -workers=10 \
  | vegeta report
```

## HTTP endpoints → Apache Benchmark (alternative)

```bash
ab -n 50000 -c 100 -k http://localhost:8080/api/orders
```

---

## Kafka → K6 (k6/x/kafka)

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
      id: __VU,
      amount: Math.random() * 5000,
      ts: Date.now(),
    }),
  };
  const result = producer.produce([msg]);
  check(result, {
    'message produced': (r) => r.length === 1,
    'no errors':        (r) => r[0].error === '',
  });
  sleep(0.1);
}
```

---

## RabbitMQ → K6 (k6/x/amqp)

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
