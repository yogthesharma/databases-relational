# Exercise: Stats, vacuum & checkpoint

Read: `notes/07-indexing-performance/07-stats-vacuum-checkpoint.md`

**Reset the lab** so secondary indexes are gone.

## Tasks

1. Why does the planner need `ANALYZE` / statistics?
2. What does autovacuum do for you (one sentence)?
3. **Checkpoint — before:** run and save the plan shape/time:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, user_id, total, created_at
FROM perf_lab.orders
WHERE user_id = 100
ORDER BY created_at DESC
LIMIT 20;
```

4. Create `orders_user_created_idx` on `(user_id, created_at DESC)`.
5. **Checkpoint — after:** re-run the same `EXPLAIN (ANALYZE, BUFFERS)`. What changed?

## Stretch

Run `ANALYZE perf_lab.orders;` — when would you bother?

---

## Solutions

1. So row/selectivity estimates are realistic enough to pick seq vs index vs join order.
2. Reclaims dead tuples and maintains visibility map (and related cleanup) in the background.
3. Fresh seed: typically **Seq Scan** (or sort on seq) — note actual time.
4.

```sql
CREATE INDEX orders_user_created_idx
  ON perf_lab.orders (user_id, created_at DESC);
```

5. Plan should use the index (index scan / backward); actual time usually drops vs pure seq+sort on 50k rows.

Stretch: after bulk loads or heavy skew changes — when plans look wrong relative to reality.
