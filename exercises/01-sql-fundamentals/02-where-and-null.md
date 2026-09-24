# Exercise: WHERE and NULL

Read: `notes/01-sql-fundamentals/02-where-and-null.md`

## Tasks

1. Active employees only (`is_active`).
2. Products with `price` greater than or equal to 200.
3. Engineering employees earning under 100000.
4. Employees with **no** manager (`manager_id` is null).
5. Employees who **have** a manager.
6. Why does `WHERE manager_id = NULL` return zero rows?

## Stretch

Products that are **not** discontinued and have stock (`stock_qty > 0`).

---

## Solutions

```sql
-- 1
SELECT * FROM employees WHERE is_active = TRUE;
-- or: WHERE is_active;

-- 2
SELECT * FROM products WHERE price >= 200;

-- 3
SELECT * FROM employees
WHERE department = 'Engineering' AND salary < 100000;

-- 4
SELECT * FROM employees WHERE manager_id IS NULL;

-- 5
SELECT * FROM employees WHERE manager_id IS NOT NULL;

-- 6
NULL means unknown; `= NULL` is not TRUE, so WHERE drops the row.
Use IS NULL.

-- Stretch
SELECT * FROM products
WHERE is_discontinued = FALSE AND stock_qty > 0;
```
