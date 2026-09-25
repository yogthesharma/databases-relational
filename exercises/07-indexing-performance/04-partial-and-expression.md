# Exercise: Partial & expression indexes

Read: `notes/07-indexing-performance/04-partial-and-expression.md`

## Tasks

1. Create a partial index on `orders(created_at)` **where** `status = 'pending'`.
2. Explain a query that filters `status = 'pending'` and `created_at >= '2024-01-01'`. Does it use the partial index?
3. Create `LOWER(email)` index on `users`.
4. Explain `WHERE LOWER(email) = LOWER('user42@example.com')` — index used?
5. Why won’t `WHERE email = 'user42@example.com'` use the `LOWER(email)` index?

## Stretch

Partial index for inactive users (reactivation queue) — not a second unique on `email` (that’s already `UNIQUE` globally):

```sql
CREATE INDEX users_inactive_idx
  ON perf_lab.users (id)
  WHERE NOT is_active;
```

---

## Solutions

1.

```sql
CREATE INDEX orders_pending_created_idx
  ON perf_lab.orders (created_at)
  WHERE status = 'pending';
```

2. Yes — typically that partial index (if the predicate matches).
3.

```sql
CREATE INDEX users_email_lower_idx ON perf_lab.users (LOWER(email));
```

4. Yes — index scan on `users_email_lower_idx`.
5. The query expression must match the indexed expression; plain `email` ≠ `LOWER(email)`.

Stretch:

```sql
CREATE INDEX users_inactive_idx
  ON perf_lab.users (id)
  WHERE NOT is_active;
```

(`email` is already `UNIQUE` for every row here — a partial unique on active emails would be redundant.)
