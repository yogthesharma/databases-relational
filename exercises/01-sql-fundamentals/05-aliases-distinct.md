# Exercise: Aliases and DISTINCT

Read: `notes/01-sql-fundamentals/05-aliases-distinct.md`

## Tasks

1. Select employee names as `full_name` by concatenating `first_name` and `last_name` with a space (`||`).
2. Select `salary / 12` as `monthly_salary` for active employees.
3. List distinct `department` values.
4. List distinct `category` from products, ordered alphabetically.
5. Distinct pairs of `(department, job_title)`.

## Stretch

Using a table alias `p`, select `p.sku` and `p.name` from products.

---

## Solutions

```sql
-- 1
SELECT first_name || ' ' || last_name AS full_name
FROM employees;

-- 2
SELECT salary / 12 AS monthly_salary
FROM employees
WHERE is_active = TRUE;

-- 3
SELECT DISTINCT department FROM employees;

-- 4
SELECT DISTINCT category FROM products ORDER BY category;

-- 5
SELECT DISTINCT department, job_title FROM employees;

-- Stretch
SELECT p.sku, p.name FROM products AS p;
```
