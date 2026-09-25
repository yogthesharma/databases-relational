# Slow-query patterns

## Classic footguns

| Pattern | Why it hurts | Direction |
|---------|--------------|-----------|
| `WHERE LOWER(col) = …` without expr index | Can’t use plain B-tree on `col` | Expression index or store canonical form |
| `WHERE date(created_at) = …` | Same | Range on `timestamptz`: `>= day AND < day+1` |
| Leading `%` `LIKE '%foo%'` | Can’t use normal B-tree | `pg_trgm` / GIN later; or rethink search |
| `OR` across columns | Often seq scan / bitmap weirdness | `UNION` sometimes; or composite design |
| Select `*` when you need 2 cols | More I/O; harder index-only | Select needed columns |
| Offset pagination `OFFSET 100000` | Still walks many rows | Keyset pagination (`WHERE id > ?`) |

## Rewrite example (lab)

Bad shape:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM perf_lab.orders
WHERE note IS NOT NULL OR status = 'cancelled';
```

Often better as two queries `UNION ALL` if each arm is index-friendly — or accept bitmap/seq if selectivity is poor. Measure; don’t rewrite blindly.

## Selective filter first

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT o.id, o.total
FROM perf_lab.orders o
JOIN perf_lab.users u ON u.id = o.user_id
WHERE u.country = 'IN' AND o.status = 'paid';
```

Indexes on `users.country` and/or `orders (status, user_id)` / `(user_id, status)` change the join plan. Try before/after.

## Takeaway

Most “slow SQL” is a shape problem + missing index + bad pagination. Fix the query shape, then index what the plan still needs.
