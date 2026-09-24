# Exercise: SELECT / FROM

Read: `notes/01-sql-fundamentals/01-select-from.md`

## Tasks

Write SQL for:

1. All columns from `products`.
2. Only `first_name`, `last_name`, `email` from `employees`.
3. `sku` and `price` from `products`.
4. Each employee’s `salary` and a computed yearly → monthly value (`salary / 12`) — column can be unnamed for now.

## Stretch

Why is `SELECT *` a bad default in a Nest/Express JSON API?

---

## Solutions

```sql
-- 1
SELECT * FROM products;

-- 2
SELECT first_name, last_name, email FROM employees;

-- 3
SELECT sku, price FROM products;

-- 4
SELECT salary, salary / 12 FROM employees;
```

Stretch: over-fetching, unstable response shape when columns change, accidental leakage of sensitive columns.
