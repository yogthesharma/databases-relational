# CASE expressions

`CASE` is SQL’s inline if/else — useful for labeling, bucketing, and shaping API fields without a second pass in Node.

## Searched CASE

```sql
SELECT
  name,
  price,
  CASE
    WHEN price = 0 THEN 'free'
    WHEN price < 100 THEN 'budget'
    WHEN price < 500 THEN 'mid'
    ELSE 'premium'
  END AS price_band
FROM products
ORDER BY price;
```

## Simple CASE

```sql
SELECT
  first_name,
  department,
  CASE department
    WHEN 'Engineering' THEN 'build'
    WHEN 'Product' THEN 'define'
    WHEN 'Sales' THEN 'sell'
    ELSE 'other'
  END AS dept_role
FROM employees;
```

## Inside aggregates

Conditional counts without leaving SQL:

```sql
SELECT
  count(*) AS total,
  sum(CASE WHEN is_active THEN 1 ELSE 0 END) AS active_count
FROM employees;
```

(Postgres also has `count(*) FILTER (WHERE …)` — Module 8. Stick to `CASE` for now.)

## Node angle

Push bucketing into SQL when many rows are involved — transfer less data and keep rules next to the data.

## Takeaway

Use `CASE` to derive labels and conditional values in the SELECT list (and in aggregates). Prefer DB-side bucketing for large result sets.
