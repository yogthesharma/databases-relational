# Exercise: inet, ranges & type choices

Read: `notes/05-postgres-types/07-inet-and-ranges.md`

## Tasks

1. Select customers whose `signup_ip` is in subnet `203.0.113.0/24`.
2. List orders with a `ship_window`, showing `lower` and `upper`.
3. Which orders’ ship window contain `2024-03-12 12:00:00+00`?
4. Why store `signup_ip` as `INET` instead of `TEXT`?
5. **Checkpoint:** For a “room booking” app, pick types for: `rooms.id`, `rooms.code`, `bookings.starts_at`, `bookings.ends_at` *or* a single range column, `bookings.price`, `bookings.status`, `bookings.meta`. Justify each in one short line.

## Stretch

Use a `tstzrange` overlap check: does Asha’s ship window overlap Deepa’s?

---

## Solutions

1.

```sql
SELECT email, signup_ip FROM types_lab.customers
WHERE signup_ip << '203.0.113.0/24'::cidr;
```

2.

```sql
SELECT id, lower(ship_window), upper(ship_window)
FROM types_lab.orders
WHERE ship_window IS NOT NULL;
```

3.

```sql
SELECT id, status FROM types_lab.orders
WHERE ship_window @> '2024-03-12 12:00:00+00'::timestamptz;
```

4. Validates IPs, supports v4/v6, subnet operators — text is just a string.
5. Example answers (variants OK if justified):

| Column | Type | Why |
|--------|------|-----|
| `rooms.id` | `SERIAL` or `UUID` | Surrogate PK |
| `rooms.code` | `TEXT` UNIQUE | Natural business code |
| `starts_at`/`ends_at` or `during tstzrange` | `TIMESTAMPTZ` / `TSTZRANGE` | Absolute booking window |
| `price` | `NUMERIC(12,2)` or cents `INTEGER` | Exact money |
| `status` | `ENUM` or lookup | Tiny frozen vs evolving |
| `meta` | `JSONB` | Optional leftovers |

Stretch:

```sql
SELECT a.id AS asha_order, d.id AS deepa_order,
       a.ship_window && d.ship_window AS overlaps
FROM types_lab.orders a
JOIN types_lab.customers ca ON ca.id = a.customer_id AND ca.email = 'asha@example.com'
JOIN types_lab.orders d
  ON d.ship_window IS NOT NULL
JOIN types_lab.customers cd ON cd.id = d.customer_id AND cd.email = 'deepa@example.com';
```
