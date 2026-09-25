# LATERAL joins

## Why `LATERAL`

A normal subquery in `FROM` can’t see columns from tables to its left. **`LATERAL`** can — like a correlated subquery that returns a set.

```sql
SELECT e.name, t.sold_on, t.amount
FROM adv_lab.employees e
CROSS JOIN LATERAL (
  SELECT s.sold_on, s.amount
  FROM adv_lab.sales s
  WHERE s.employee_id = e.id
  ORDER BY s.amount DESC
  LIMIT 1
) AS t
ORDER BY e.name;
```

Top sale per employee without a window — often plans well with an index on `(employee_id, amount DESC)`.

## `LEFT JOIN LATERAL`

Keep employees with no sales:

```sql
SELECT e.name, t.amount AS top_amount
FROM adv_lab.employees e
LEFT JOIN LATERAL (
  SELECT s.amount
  FROM adv_lab.sales s
  WHERE s.employee_id = e.id
  ORDER BY s.amount DESC
  LIMIT 1
) AS t ON TRUE
ORDER BY e.name;
```

`ON TRUE` is the usual glue for lateral left joins.

## Window vs LATERAL

| Prefer window | Prefer LATERAL |
|---------------|----------------|
| Same expression on every row | Top-N / “for each outer row, run this query” |
| Ranking, running totals | `LIMIT` per parent, set-returning functions |

## Takeaway

`LATERAL` = correlated `FROM` subquery. Perfect for per-parent top-N.
