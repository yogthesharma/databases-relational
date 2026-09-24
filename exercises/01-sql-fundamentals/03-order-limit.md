# Exercise: ORDER BY / LIMIT

Read: `notes/01-sql-fundamentals/03-order-limit.md`

## Tasks

1. Products sorted by `price` descending.
2. Top 3 highest-paid employees (`first_name`, `last_name`, `salary`).
3. Employees sorted by `department` ascending, then `salary` descending.
4. “Page 2” of products by `id`, page size 5 (`LIMIT`/`OFFSET`).
5. Why is deep `OFFSET` painful on large tables?

## Stretch

Cheapest 5 products that are still sold (`is_discontinued = FALSE`).

---

## Solutions

```sql
-- 1
SELECT * FROM products ORDER BY price DESC;

-- 2
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 3;

-- 3
SELECT * FROM employees
ORDER BY department ASC, salary DESC;

-- 4
SELECT * FROM products
ORDER BY id
LIMIT 5 OFFSET 5;

-- 5
Postgres still has to scan/skip the offset rows; cost grows with page number.

-- Stretch
SELECT * FROM products
WHERE is_discontinued = FALSE
ORDER BY price ASC
LIMIT 5;
```
