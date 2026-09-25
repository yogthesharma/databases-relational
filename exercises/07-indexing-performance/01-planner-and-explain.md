# Exercise: Planner & EXPLAIN

Read: `notes/07-indexing-performance/01-planner-and-explain.md`

Reset the lab so you’re on a clean seed.

## Tasks

1. How many users and orders are in `perf_lab`?
2. What’s the difference between `EXPLAIN` and `EXPLAIN (ANALYZE)`?
3. `EXPLAIN` a `count(*)` of orders with `status = 'paid'`. What scan type do you see (no extra indexes yet)?
4. Re-run with `EXPLAIN (ANALYZE, BUFFERS)`. Name two fields that appear only with `ANALYZE`.
5. Why is `EXPLAIN ANALYZE` risky on a huge `DELETE` in production?

## Stretch

What do “cost” numbers represent — measurements or estimates?

---

## Solutions

1.

```sql
SELECT
  (SELECT count(*) FROM perf_lab.users)  AS users,
  (SELECT count(*) FROM perf_lab.orders) AS orders;
-- 5000 / 50000
```

2. `EXPLAIN` = estimated plan only; `ANALYZE` **executes** and shows actual time/rows.
3. **Seq Scan** on `perf_lab.orders` (typical on fresh seed).
4. **actual time**, **rows** (actual); with `BUFFERS`: shared hit/read.
5. It runs the delete for real.

Stretch: **estimates** the planner uses to choose a plan (not wall-clock until `ANALYZE`).
