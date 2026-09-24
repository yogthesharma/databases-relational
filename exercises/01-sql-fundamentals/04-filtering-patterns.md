# Exercise: Filtering patterns

Read: `notes/01-sql-fundamentals/04-filtering-patterns.md`

## Tasks

1. Employees in `Sales` or `HR`.
2. Products with price between 50 and 200 (inclusive).
3. Employees whose email ends with `@example.com`.
4. Products whose name contains `SSD` (case-insensitive).
5. Laptops **or** Displays that are in stock — use parentheses correctly.

## Stretch

Peripherals that are either out of stock **or** discontinued.

---

## Solutions

```sql
-- 1
SELECT * FROM employees
WHERE department IN ('Sales', 'HR');

-- 2
SELECT * FROM products
WHERE price BETWEEN 50 AND 200;

-- 3
SELECT * FROM employees
WHERE email LIKE '%@example.com';

-- 4
SELECT * FROM products
WHERE name ILIKE '%SSD%';

-- 5
SELECT * FROM products
WHERE category IN ('Laptops', 'Displays')
  AND stock_qty > 0;

-- Stretch
SELECT * FROM products
WHERE category = 'Peripherals'
  AND (stock_qty = 0 OR is_discontinued = TRUE);
```
