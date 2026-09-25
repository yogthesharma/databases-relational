# Exercise: Temporal types

Read: `notes/05-postgres-types/03-temporal.md`

## Tasks

1. Why prefer `TIMESTAMPTZ` over `TIMESTAMP` for `orders.placed_at`?
2. List customer emails with `created_at` and the same instant shown in `Asia/Kolkata`.
3. Add 3 days to each order’s `placed_at` as `eta`.
4. Which type for a person’s birthday? For `created_at`?
5. Select orders placed on/after `2024-01-01` (lab data is March 2024 — `now() - INTERVAL '365 days'` may miss them depending on today’s date).

## Stretch

Compute `now() - placed_at` for each order — what type is that?

---

## Solutions

1. Stores an absolute instant (UTC); displays in session TZ. Naked `timestamp` loses zone meaning.
2.

```sql
SELECT email, created_at,
       created_at AT TIME ZONE 'Asia/Kolkata' AS local_ist
FROM types_lab.customers;
```

3.

```sql
SELECT id, placed_at, placed_at + INTERVAL '3 days' AS eta
FROM types_lab.orders;
```

4. Birthday → `DATE`. `created_at` → `TIMESTAMPTZ`.
5.

```sql
SELECT * FROM types_lab.orders
WHERE placed_at >= TIMESTAMPTZ '2024-01-01';
-- Real apps often use: placed_at >= now() - INTERVAL '30 days'
```

Stretch: `interval`.
