# Exercise: CASE expressions

Read: `notes/01-sql-fundamentals/07-case-expressions.md`

## Tasks

1. For each product, select `name`, `price`, and `price_band`:
   - `free` if price = 0
   - `budget` if price < 100
   - `mid` if price < 500
   - else `premium`
2. For each employee, label `level` as `junior` if salary < 80000, `mid` if < 120000, else `senior`.
3. Count how many products fall in each `price_band` (hint: group by the same `CASE`, or wrap in a subquery/CTE if you prefer).

## Stretch

Add a column `status_label`: `'gone'` if discontinued, `'oos'` if stock 0, else `'ok'`.

---

## Solutions

```sql
-- 1
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

-- 2
SELECT
  first_name,
  salary,
  CASE
    WHEN salary < 80000 THEN 'junior'
    WHEN salary < 120000 THEN 'mid'
    ELSE 'senior'
  END AS level
FROM employees;

-- 3 (repeat the CASE in GROUP BY — same expression as SELECT)
SELECT
  CASE
    WHEN price = 0 THEN 'free'
    WHEN price < 100 THEN 'budget'
    WHEN price < 500 THEN 'mid'
    ELSE 'premium'
  END AS price_band,
  count(*) AS n
FROM products
GROUP BY
  CASE
    WHEN price = 0 THEN 'free'
    WHEN price < 100 THEN 'budget'
    WHEN price < 500 THEN 'mid'
    ELSE 'premium'
  END
ORDER BY n DESC;

-- Stretch
SELECT
  name,
  CASE
    WHEN is_discontinued THEN 'gone'
    WHEN stock_qty = 0 THEN 'oos'
    ELSE 'ok'
  END AS status_label
FROM products;
```
