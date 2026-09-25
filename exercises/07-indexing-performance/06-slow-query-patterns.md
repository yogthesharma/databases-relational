# Exercise: Slow-query patterns

Read: `notes/07-indexing-performance/06-slow-query-patterns.md`

## Tasks

1. Why is `WHERE date(created_at) = DATE '2024-06-01'` hard to index well with a plain B-tree on `created_at`?
2. Rewrite that filter as a half-open `timestamptz` range.
3. What’s wrong with `OFFSET 100000 LIMIT 20` for deep pages?
4. Create useful indexes, then explain:

```sql
SELECT o.id, o.total
FROM perf_lab.orders o
JOIN perf_lab.users u ON u.id = o.user_id
WHERE u.country = 'IN' AND o.status = 'paid';
```

5. Name one reason selecting `*` slows you down vs selecting two columns.

## Stretch

Keyset idea: instead of offset, filter `WHERE (created_at, id) < (?, ?)` for the next page (words OK).

---

## Solutions

1. Function wrap prevents a plain `created_at` B-tree from matching (needs expr index or rewrite).
2.

```sql
WHERE created_at >= TIMESTAMPTZ '2024-06-01'
  AND created_at <  TIMESTAMPTZ '2024-06-02'
```

3. Postgres still walks/skips many rows — cost grows with page depth.
4. Example indexes:

```sql
CREATE INDEX users_country_idx ON perf_lab.users (country);
CREATE INDEX orders_status_user_idx ON perf_lab.orders (status, user_id);
```

Then `EXPLAIN (ANALYZE, BUFFERS)` the join — look for those indexes in the plan (hash/nested loop + bitmap/index).
5. Extra heap I/O; harder index-only scans; more data over the wire.

Stretch: seek to the last seen `(created_at, id)` and read the next N ordered rows — no giant offset.
