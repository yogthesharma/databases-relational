# Composite indexes and covering

## Column order matters

A composite index on `(a, b)` is great for:

- `WHERE a = ?`
- `WHERE a = ? AND b = ?`
- `WHERE a = ? ORDER BY b`

It is **not** (generally) used for `WHERE b = ?` alone — leftmost prefix rule.

```sql
CREATE INDEX orders_user_created_idx
  ON perf_lab.orders (user_id, created_at);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, total, created_at
FROM perf_lab.orders
WHERE user_id = 42
ORDER BY created_at DESC
LIMIT 10;
```

## Covering / index-only (overview)

If the index contains every column the query needs, Postgres may do an **Index Only Scan** (heap fetch avoided when the visibility map says OK).

```sql
CREATE INDEX orders_status_id_total_idx
  ON perf_lab.orders (status)
  INCLUDE (id, total);  -- payload columns (Postgres 11+)

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, total FROM perf_lab.orders WHERE status = 'pending';
```

`INCLUDE` columns aren’t sort keys; they just help covering. Index-only scans also need a fresh enough visibility map (`VACUUM`) and a selective enough query — don’t expect them on “25% of the table” filters.

## Takeaway

Put equality filters first in composites, then range/`ORDER BY`. Covering is an optimization — prove it with `EXPLAIN`.
