# Aggregations: GROUP BY and HAVING

## Aggregate functions

Collapse many rows into a value:

| Function | Role |
|----------|------|
| `COUNT(*)` | Number of rows |
| `COUNT(col)` | Non-NULL values in col |
| `SUM`, `AVG`, `MIN`, `MAX` | Obvious |

```sql
SELECT count(*) FROM employees WHERE is_active;
SELECT avg(salary) FROM employees WHERE department = 'Engineering';
SELECT max(price), min(price) FROM products;
```

## GROUP BY

One result row per group:

```sql
SELECT department, count(*) AS headcount, avg(salary) AS avg_salary
FROM employees
WHERE is_active = TRUE
GROUP BY department
ORDER BY headcount DESC;
```

Rules of thumb:

- Every non-aggregated column in `SELECT` must appear in `GROUP BY` (required for portable SQL; follow this always in this course).
- Filter **rows before grouping** with `WHERE`.
- Filter **groups after aggregation** with `HAVING`.

## HAVING

```sql
SELECT category, count(*) AS n, avg(price) AS avg_price
FROM products
WHERE is_discontinued = FALSE
GROUP BY category
HAVING count(*) >= 3   -- drop small categories after grouping
ORDER BY avg_price DESC;
```

On our seed, that keeps categories with enough products (e.g. Peripherals) and drops thinner ones.

## COUNT pitfalls

```sql
COUNT(*)        -- all rows in group
COUNT(email)    -- skips NULL emails
COUNT(DISTINCT department)  -- distinct values
```

## Node dashboard query

```js
const { rows } = await pool.query(`
  SELECT department, count(*)::int AS headcount
  FROM employees
  WHERE is_active = TRUE
  GROUP BY department
  ORDER BY headcount DESC
`);
```

`::int` casts bigint count to int for nicer JSON (optional).

## Takeaway

`WHERE` filters rows → `GROUP BY` buckets → aggregates compute → `HAVING` filters groups. This is how dashboards and admin stats should be done in SQL, not with JS loops over full tables.
