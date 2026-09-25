# B-tree indexes

## Default index type

`CREATE INDEX` → **B-tree** unless you say otherwise. Great for `=`, `<`, `>`, `BETWEEN`, `IN`, `ORDER BY` on sortable types.

```sql
CREATE INDEX orders_status_idx ON perf_lab.orders (status);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, user_id, total
FROM perf_lab.orders
WHERE status = 'cancelled';
```

You should see an **Index Scan** or **Bitmap** path instead of a pure seq scan (for selective enough filters).

## When indexes help

- High selectivity (few rows match)  
- Repeated filters / joins on that column  
- Supporting `ORDER BY` / `UNIQUE`

## When they hurt / don’t help

- Tiny tables (seq scan is cheaper)  
- Low selectivity (`status` matching 50% of rows — planner may still seq scan)  
- Write-heavy tables (every `INSERT`/`UPDATE` maintains indexes)  
- Wrapping the column in a function (`WHERE LOWER(email) = …`) without an expression index

## PK / UNIQUE already index

`users.email` UNIQUE and `orders.id` PK already have B-trees. Don’t recreate those.

## Drop / list

```sql
DROP INDEX perf_lab.orders_status_idx;
\di perf_lab.*
```

## Takeaway

B-tree is the workhorse. Index selective filter/join columns; measure with `EXPLAIN ANALYZE`, don’t spray indexes everywhere.
