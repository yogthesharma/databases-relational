# Planner and EXPLAIN

## What happens when you run SQL

1. **Parse / rewrite** — syntax + views/rules  
2. **Plan** — planner estimates costs, picks a plan (seq scan, index scan, join order, …)  
3. **Execute** — runs that plan  

Indexes don’t “make queries fast” by magic — they give the planner cheaper options.

## `EXPLAIN` vs `EXPLAIN ANALYZE`

```sql
EXPLAIN
SELECT * FROM perf_lab.orders WHERE status = 'shipped';

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM perf_lab.orders WHERE status = 'shipped';
```

| Form | Shows |
|------|--------|
| `EXPLAIN` | Estimated plan only (safe, no run) |
| `EXPLAIN (ANALYZE)` | Runs the query; **actual** timing + rows |
| `+ BUFFERS` | Shared hit/read blocks (I/O hint) |

`ANALYZE` executes the query — don’t use it blindly on huge `UPDATE`/`DELETE` in prod.

## Nodes you’ll see early

| Node | Meaning |
|------|---------|
| **Seq Scan** | Read whole table |
| **Index Scan** | Use index, fetch heap rows |
| **Index Only Scan** | Answer from index (needs visibility map / covering) |
| **Bitmap Index Scan** + **Bitmap Heap Scan** | Good for many matches |

Also note: **cost** (startup..total estimate), **rows** (estimate), and with `ANALYZE`: **actual time** and **rows**.

## Lab baseline (no secondary indexes yet)

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*) FROM perf_lab.orders WHERE status = 'paid';
```

Expect a **Seq Scan** on `orders` until you add an index.

## Takeaway

Read plans before guessing. Estimates vs actuals tell you if stats/indexes are off. `EXPLAIN (ANALYZE, BUFFERS)` is your microscope.
