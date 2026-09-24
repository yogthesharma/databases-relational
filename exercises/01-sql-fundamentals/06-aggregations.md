# Exercise: Aggregations

Read: `notes/01-sql-fundamentals/06-aggregations.md`

## Tasks

1. Total number of employees.
2. Average salary in Engineering (active only).
3. Per department: `headcount` and `avg_salary` (active only), highest headcount first.
4. Per product `category`: count of products and `max(price)`.
5. Categories that have **at least 3** products (`HAVING`).
6. How many products have `stock_qty = 0`?

## Stretch

One query: company-wide `min(salary)`, `max(salary)`, `avg(salary)` for active employees.

---

## Solutions

```sql
-- 1
SELECT count(*) FROM employees;

-- 2
SELECT avg(salary) FROM employees
WHERE department = 'Engineering' AND is_active = TRUE;

-- 3
SELECT department, count(*) AS headcount, avg(salary) AS avg_salary
FROM employees
WHERE is_active = TRUE
GROUP BY department
ORDER BY headcount DESC;

-- 4
SELECT category, count(*) AS n, max(price) AS max_price
FROM products
GROUP BY category;

-- 5
SELECT category, count(*) AS n
FROM products
GROUP BY category
HAVING count(*) >= 3;

-- 6
SELECT count(*) FROM products WHERE stock_qty = 0;

-- Stretch
SELECT min(salary), max(salary), avg(salary)
FROM employees
WHERE is_active = TRUE;
```
