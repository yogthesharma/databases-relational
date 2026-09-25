# Stats, vacuum, and the checkpoint

## Statistics (`ANALYZE`)

Planner estimates come from catalogs. After big loads or skewed updates:

```sql
ANALYZE perf_lab.orders;
ANALYZE perf_lab.users;
```

The lab seed already runs `ANALYZE`. If plans look insane after heavy writes, re-`ANALYZE`.

## Vacuum / autovacuum (why you care)

Updates/deletes leave dead row versions. **Vacuum** reclaims them and updates the visibility map (helps index-only scans). **Autovacuum** usually does this for you.

You rarely run `VACUUM` by hand in app code — but if a table is huge and “always seq scanning,” check whether vacuum/analyze are falling behind (ops Module 11).

**Bloat** (high level): too many dead tuples / fat indexes → more I/O. Vacuum helps; extreme cases need `VACUUM FULL` / `REINDEX` (locks — not casual).

## Checkpoint — prove an improvement

Reset lab so `orders` has no secondary indexes.

1. Capture a slow plan:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, user_id, total, created_at
FROM perf_lab.orders
WHERE user_id = 100
ORDER BY created_at DESC
LIMIT 20;
```

2. Add a supporting index:

```sql
CREATE INDEX orders_user_created_idx
  ON perf_lab.orders (user_id, created_at DESC);
```

3. Re-run the same `EXPLAIN (ANALYZE, BUFFERS)`. Expect `orders_user_created_idx` in the plan and much lower actual time (a tiny Sort is fine).

## Node angle

ORMs don’t replace `EXPLAIN`. When an endpoint is slow, log SQL → explain → index/rewrite → verify.

## Takeaway

Fresh stats, healthy vacuum, right indexes. Checkpoint = before/after `EXPLAIN ANALYZE` proof — not vibes.
