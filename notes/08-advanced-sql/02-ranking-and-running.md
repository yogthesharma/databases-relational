# Ranking and running totals

## Ranking family

| Function | Behavior |
|----------|----------|
| `ROW_NUMBER()` | Unique 1..n in partition (ties get different numbers) |
| `RANK()` | Ties share rank; skips next (1,2,2,4) |
| `DENSE_RANK()` | Ties share; no skip (1,2,2,3) |

```sql
SELECT
  e.name,
  s.amount,
  rank() OVER (ORDER BY s.amount DESC) AS overall_rank,
  rank() OVER (PARTITION BY s.region ORDER BY s.amount DESC) AS region_rank
FROM adv_lab.sales s
JOIN adv_lab.employees e ON e.id = s.employee_id
ORDER BY s.amount DESC;
```

## Top-N per group (pattern)

```sql
WITH ranked AS (
  SELECT
    s.*,
    row_number() OVER (
      PARTITION BY s.employee_id
      ORDER BY s.amount DESC
    ) AS rn
  FROM adv_lab.sales s
)
SELECT employee_id, amount, sold_on
FROM ranked
WHERE rn = 1;
```

## Running / moving aggregates

```sql
SELECT
  sold_on,
  amount,
  sum(amount) OVER (ORDER BY sold_on) AS company_running,
  avg(amount) OVER (
    ORDER BY sold_on
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS moving_avg_3
FROM adv_lab.sales
ORDER BY sold_on;
```

## Takeaway

`ROW_NUMBER` for top-N filters; `RANK`/`DENSE_RANK` when ties matter. Running totals = `sum() OVER (ORDER BY …)`.
