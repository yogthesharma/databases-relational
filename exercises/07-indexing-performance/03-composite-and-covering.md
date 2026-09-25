# Exercise: Composite & covering

Read: `notes/07-indexing-performance/03-composite-and-covering.md`

Reset if the lab is messy.

## Tasks

1. Create `(user_id, created_at DESC)` on `orders`.
2. Explain this query and confirm index use:

```sql
SELECT id, total, created_at
FROM perf_lab.orders
WHERE user_id = 42
ORDER BY created_at DESC
LIMIT 10;
```

3. Why is `(user_id, created_at)` a poor fit for `WHERE created_at > …` alone?
4. Create an index on `status` that `INCLUDE`s `(id, total)`.
5. Explain `SELECT id, total FROM perf_lab.orders WHERE status = 'pending'` — which index shows up? (Index-only is optional here: `pending` is ~25% of rows, so a bitmap/heap path is normal.)

## Stretch

Would `(created_at, user_id)` serve the query in task 2 as well? Why/why not?

---

## Solutions

1.

```sql
CREATE INDEX orders_user_created_idx
  ON perf_lab.orders (user_id, created_at DESC);
```

2. Expect `orders_user_created_idx` in the plan (bitmap or index scan). A small Sort is OK.
3. Leftmost prefix — without `user_id`, that composite usually isn’t used for `created_at`-only filters.
4.

```sql
CREATE INDEX orders_status_incl_idx
  ON perf_lab.orders (status) INCLUDE (id, total);
```

5. Often a bitmap/index path on a `status` index (`orders_status_incl_idx` or another status index). **Index Only Scan** may appear after `VACUUM` on more selective filters — don’t force it on a fat status value.

Stretch: Weaker for that query — equality on `user_id` wants `user_id` leading (or a skip-unfriendly order).
