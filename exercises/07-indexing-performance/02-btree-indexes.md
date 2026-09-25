# Exercise: B-tree indexes

Read: `notes/07-indexing-performance/02-btree-indexes.md`

## Tasks

1. Create a B-tree index on `perf_lab.orders(status)`.
2. `EXPLAIN (ANALYZE, BUFFERS)` selecting `id, user_id, total` where `status = 'cancelled'`. Did the plan use your index?
3. When might the planner **ignore** an index on `status` even if it exists?
4. List indexes in `perf_lab` (`\di perf_lab.*` or catalog query).
5. Drop `orders_status_idx`.

## Stretch

Does `users.email` already have an index? Why?

---

## Solutions

1.

```sql
CREATE INDEX orders_status_idx ON perf_lab.orders (status);
```

2. Yes — typically **Bitmap Index Scan** / **Index Scan** on `orders_status_idx` (exact node can vary).
3. Low selectivity / tiny table / `ANALYZE` stats say seq scan is cheaper; or query wraps the column in a function.
4. `\di perf_lab.*`
5. `DROP INDEX perf_lab.orders_status_idx;`

Stretch: Yes — `UNIQUE` on `email` created a unique B-tree.
