# WHERE and NULL

## Filtering rows

`WHERE` keeps rows that match a condition:

```sql
SELECT sku, name, price
FROM products
WHERE price >= 100;
```

## Common operators

`=`, `<>` / `!=`, `<`, `>`, `<=`, `>=`, `AND`, `OR`, `NOT`

```sql
SELECT first_name, department, salary
FROM employees
WHERE department = 'Engineering' AND salary >= 100000;
```

## NULL is not a value — it’s unknown

```sql
-- Wrong: never matches NULLs
WHERE manager_id = NULL

-- Correct
WHERE manager_id IS NULL
WHERE manager_id IS NOT NULL
```

Three-valued logic: expressions with NULL yield `TRUE` / `FALSE` / `UNKNOWN`. `WHERE` only keeps `TRUE`.

```sql
-- If manager_id is NULL, this row is excluded (UNKNOWN)
WHERE manager_id <> 1
```

## Boolean columns

```sql
SELECT name FROM products WHERE is_discontinued = FALSE;
-- or
SELECT name FROM products WHERE NOT is_discontinued;
```

## Node: parameters in WHERE

```js
await pool.query(
  `SELECT id, name, price FROM products WHERE category = $1 AND price <= $2`,
  ['Laptops', 1000]
);
```

## Takeaway

Filter with `WHERE`. Always use `IS NULL` / `IS NOT NULL`. Treat NULL as contagious unknown, not “empty string.”
